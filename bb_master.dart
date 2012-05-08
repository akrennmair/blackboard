#import('dart:html');
#import('dart:json');

void main() {
	window.on.contentLoaded.add( (e) {
		bool mouseDown = false;
		CanvasElement canvas = document.query('#bb');
		CanvasRenderingContext2D ctx = canvas.getContext("2d");
		List<int> coords;

		canvas.on.mouseDown.add( (MouseEvent e) {
			mouseDown = true;
			ctx.beginPath();
			coords = [];
			Future<ElementRect> f = canvas.rect; f.then((ElementRect rect) {
				int x = e.clientX - rect.offset.left;
				int y = e.clientY - rect.offset.top;
				coords.add(x);
				coords.add(y);
				print("mouseDown = true x = ${x} y = ${y}");
				ctx.moveTo(x, y);
			});
		});

		canvas.on.mouseMove.add( (MouseEvent e) {
			if (mouseDown) {
				Future<ElementRect> f = canvas.rect; f.then((ElementRect rect) {
					int x = e.clientX - rect.offset.left;
					int y = e.clientY - rect.offset.top;
					ctx.lineTo(x, y);
					coords.add(x);
					coords.add(y);
					ctx.stroke();
					print("stroke x = ${x} y = ${y}");
				});
			}
		});

		WebSocket ws_send = new WebSocket("ws://" + window.location.host + "/senddata");

		canvas.on.mouseUp.add( (MouseEvent e) {
			if (mouseDown) {
				mouseDown = false;
				print("mouseDown = false");
				ws_send.send(JSON.stringify(coords));
			}
		});
	});

}
