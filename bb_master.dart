import 'dart:html';
import 'dart:json' as JSON;
import 'dart:async';

void main() {
	print("entered main");
	bool mouseDown = false;
	CanvasElement canvas = document.query('#bb');
	CanvasRenderingContext2D ctx = canvas.context2D;
	List<int> coords;
	int left_offset, top_offset;

	Rectangle rect = canvas.getBoundingClientRect();
	left_offset = rect.left;
	top_offset = rect.top;

	canvas.onMouseDown.listen( (MouseEvent e) {
		mouseDown = true;
		ctx.beginPath();
		coords = [];
		int x = e.clientX - left_offset;
		int y = e.clientY - top_offset;
		coords.add(x);
		coords.add(y);
		print("mouseDown = true x = ${x} y = ${y}");
		ctx.moveTo(x, y);
	});

	canvas.onMouseMove.listen( (MouseEvent e) {
		if (mouseDown) {
			int x = e.clientX - left_offset;
			int y = e.clientY - top_offset;
			ctx.lineTo(x, y);
			coords.add(x);
			coords.add(y);
			ctx.stroke();
			print("stroke x = ${x} y = ${y}");
		}
	});

	WebSocket ws_send = new WebSocket("ws://" + window.location.host + "/senddata");

	canvas.onMouseUp.listen( (MouseEvent e) {
		if (mouseDown) {
			mouseDown = false;
			print("mouseDown = false");
			ws_send.send(JSON.stringify(coords));
			coords = [];
		}
	});

}
