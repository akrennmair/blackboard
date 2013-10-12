import 'dart:html';
import 'dart:json' as JSON;

void main() {
	CanvasElement canvas = document.query('#bb');
	CanvasRenderingContext2D ctx = canvas.context2D;

	WebSocket ws_recv = new WebSocket("ws://" + window.location.host + "/recvdata");
	ws_recv.onMessage.listen((event) {
		print("received data: ${event.data}");
		List<int> coords = JSON.parse(event.data);
		ctx.beginPath();
		for (int i=0;i<coords.length;i+=2) {
			ctx.lineTo(coords[i], coords[i+1]);
		}
		ctx.stroke();
	});
}

