package kalakuh.rhythm
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	public class Player extends Sprite
	{
		public static var $alive : Boolean = true;
		public static var $scale : Number = 0.75;
		private var _clones : PlayerClones = new PlayerClones();
		[Embed(source = "../Assets/PlayerImg.svg")] private var playerImg : Class;
		private var _sprimg : Sprite = new playerImg();
		public static var $x : Number = 0;
		public static var $y : Number = 0;
		
		public function Player () {
			this.addEventListener(Event.ENTER_FRAME, playerLogic);
			addChild(this._sprimg);
			addChild(this._clones);
			this._sprimg.x = 320;
			this._sprimg.y = 240;
			this._sprimg.scaleX = $scale;
			this._sprimg.scaleY = $scale;
		}
		
		private function playerLogic (movingSpeed : uint = 5) : void {
			this.parent.setChildIndex(this, 0);
			this._sprimg.x += (mouseX - this._sprimg.x) / 5;
			this._sprimg.y += (mouseY - this._sprimg.y) / 5;
			this._sprimg.rotation += 5;
			$x = this._sprimg.x;
			$y = this._sprimg.y;
			
			if ($alive) {
				var clone : Sprite = new playerImg();
				stage.addChild(clone);
				clone.parent.setChildIndex(clone, 0);
				clone.x = _sprimg.x;
				clone.y = _sprimg.y;
				clone.scaleX = $scale;
				clone.scaleY = $scale;
				clone.rotation = _sprimg.rotation;
				_clones.clones.push(clone);
			}
		}
	}
	
}