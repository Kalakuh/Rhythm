package kalakuh.rhythm
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	
	// NOTE: This class is currently not used, but it may be used in the future versions!
	public class Instructions extends Sprite
	{
		private var _i : Number = 0;
		[Embed(source = "../Assets/instructions.svg")]private var img : Class;
		private var _inst : Sprite = new img();
		
		public function Instructions () {
			addChild(this._inst);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init (e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_inst.x = (stage.stageWidth / 2) - (_inst.width / 2);
			_inst.y = stage.stageHeight - _inst.height - 15;
		}
		
		private function update (e : Event) : void {
			// alpha changes between 0.5 and 1.0
			_i += 0.05;
			_inst.alpha = 0.5 + ((Math.sin(_i) / 4) + 0.25);
			
			if (Main.$mode == "Menu") {
				_inst.visible = true;
			} else {
				_inst.visible = false;
			}
		}
	}
	
}