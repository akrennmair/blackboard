#import('dart:html');
#import('dart:json');

void main() {
	window.on.contentLoaded.add( (e) {
		bool mouseDown = false;
		CanvasElement canvas = document.query('#bb');
		CanvasRenderingContext2D ctx = canvas.getContext("2d");
		List<int> coords;
		int left_offset, top_offset;

		Future<ElementRect> f = canvas.rect; f.then((ElementRect rect) {
			left_offset = rect.offset.left;
			top_offset = rect.offset.top;
		});

		canvas.on.mouseDown.add( (MouseEvent e) {
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

		canvas.on.mouseMove.add( (MouseEvent e) {
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

		canvas.on.mouseUp.add( (MouseEvent e) {
			if (mouseDown) {
				mouseDown = false;
				print("mouseDown = false");
				ws_send.send(JSON.stringify(coords));
				coords = [];
			}
		});
	});

}
