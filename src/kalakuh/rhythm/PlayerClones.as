package kalakuh.rhythm
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	public class PlayerClones extends Sprite
	{
		public var clones : Array = new Array();
		
		private var _beginScale : Number = Player.$scale;
		
		public function PlayerClones () : void {
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update (event : Event) : void {
			var toDestroy : Array = new Array();
			
			// decrease the alpha value of "clones" and resize them
			var counter : int = -1;
			for each (var n : Sprite in clones) {
				n.parent.setChildIndex(n, 0);
				n.alpha -= 0.1;
				n.rotation += 5;
				n.scaleX -= (_beginScale / 10);
				n.scaleY -= (_beginScale / 10);
				
				counter++;
				if (n.alpha <= 0) {
					n.parent.removeChild(n);
					toDestroy.push(counter);
				}
			}
			
			for each (var z : int in toDestroy) {
				// delete clone at 'z'
				clones.splice(z, 1);
			}
		}
	}
	
}