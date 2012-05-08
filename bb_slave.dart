#import('dart:html');
#import('dart:json');

void main() {
	window.on.contentLoaded.add( (e) {
		CanvasElement canvas = document.query('#bb');
		CanvasRenderingContext2D ctx = canvas.getContext("2d");

		WebSocket ws_recv = new WebSocket("ws://" + window.location.host + "/recvdata");
		ws_recv.on.message.add((event) {
			print("received data: ${event.data}");
			List<int> coords = JSON.parse(event.data);
			ctx.beginPath();
			for (int i=0;i<coords.length;i+=2) {
				ctx.lineTo(coords[i], coords[i+1]);
			}
			ctx.stroke();
		});
	});
}

