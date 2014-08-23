package kalakuh.rhythm
{
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Kalakuh
	 */
	public class HazardManager extends Sprite
	{
		public var hazards : Array = new Array();
		
		public function HazardManager () : void {
			this.addEventListener(Event.ENTER_FRAME, frameUpdate);
		}
		
		private function frameUpdate (e : Event) : void {
			var destroy : Array = new Array();
			var counter : int = -1;
			for each (var n : Hazard in hazards) {
				counter++;
				if (n.getB()) {
					destroy.push(counter);
					n.removeEventListener(Event.ENTER_FRAME, n.update);
					
					// there was a small bug which caused error - this isn't probably needed anymore
					try {
						n.parent.removeChild(n);
					} catch (err:Error) { trace("Couldn't remove child 'n'"); }
					
					n.spr = null;
				}
			}
			for (var d : uint = 0; d < destroy.length; d++) {
				hazards.splice(d, 1);
			}
		}
		
		public function cleanAll () : void {
			for each (var a : Hazard in hazards) {
				a.removeEventListener(Event.ENTER_FRAME, a.update);
				a.parent.removeChild(a);
				a.spr = null;
			}
			hazards.splice(0, hazards.length);
		}
	}
	
}