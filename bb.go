package main

import (
	"net/http"
	"fmt"
	"code.google.com/p/go.net/websocket"
)

type NewConn struct {
	conn *websocket.Conn
	ch chan []int
}

var new_coords chan []int
var add_conn chan NewConn
var del_conn chan *websocket.Conn

func recvdataServer(ws *websocket.Conn) {
	new_coords := make(chan []int, 10)
	newConn := NewConn{conn: ws, ch: new_coords}
	add_conn <- newConn
	for {
		coords := <-new_coords
		err := websocket.JSON.Send(ws, coords)
		if err != nil {
			fmt.Printf("websocket.JSON.Send failed: %s\n", err.Error())
			break
		}
		fmt.Println("sent coords")
	}
	del_conn <- ws
}

func senddataServer(ws *websocket.Conn) {
	var coords []int
	for {
		err := websocket.JSON.Receive(ws, &coords)
		if err != nil {
			fmt.Printf("websocket.JSON.Receive failed: %s\n", err.Error())
			break
		}
		fmt.Println("received coords")
		new_coords <- coords
	}
}

func dispatch_coords() {
	conns := make(map[*websocket.Conn]chan []int)
	for {
		select {
		case coords := <-new_coords:
			for _, ch := range(conns) {
				ch <- coords
			}
			fmt.Printf("send coords to %d connections\n", len(conns))
		case new_conn := <-add_conn:
			conns[new_conn.conn] = new_conn.ch
		case conn := <-del_conn:
			delete(conns, conn)
		}
	}
}

func main() {
	new_coords = make(chan []int, 1)
	add_conn = make(chan NewConn, 10)
	del_conn = make(chan *websocket.Conn, 10)
	go dispatch_coords()

	servemux := http.NewServeMux()

	servemux.Handle("/recvdata", websocket.Handler(recvdataServer))
	servemux.Handle("/senddata", websocket.Handler(senddataServer))
	servemux.Handle("/", http.FileServer(http.Dir(".")))

	httpsrv := &http.Server{Handler: servemux, Addr: "0.0.0.0:8000"}
	httpsrv.ListenAndServe()
}
