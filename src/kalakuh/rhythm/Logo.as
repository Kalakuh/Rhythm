package kalakuh.rhythm
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	
	public class Logo extends Sprite
	{
		[Embed(source = "../Assets/Logo.svg")] private var logoImg : Class;
		private var _logospr : Sprite = new logoImg();
		private var _scaleVel : Number = 0.0;
		private var _b : Boolean = false;
		private var _fadeOut : Timer;
		private var _f : Boolean = false;
		
		public function Logo () : void {
			this.addEventListener(Event.ENTER_FRAME, logoLogic);
			addChild(_logospr);
			_logospr.x = 320 - (_logospr.width / 2);
			_logospr.y = 240 - (_logospr.height / 2);
			_logospr.alpha = 0;
			_logospr.scaleX = 2;
			_logospr.scaleY = 2;
		}
		
		private function fade (e : TimerEvent) : void {
			_f = true;
		}
		
		private function logoLogic (e : Event) : void {
			if (_logospr != null) {
				_scaleVel += 0.0005;
				if (_scaleVel <= 0.025) {
					_logospr.alpha += 0.02;
					_logospr.scaleY += _scaleVel;
					_logospr.scaleX += _scaleVel;
					_logospr.x = 320 - (_logospr.width / 2);
					_logospr.y = 240 - (_logospr.height / 2);
				} else {
					if (!_b) {
						_fadeOut = new Timer(1000, 1);
						_fadeOut.addEventListener(TimerEvent.TIMER, fade);
						_fadeOut.start();
						_b = true;
					} else if (_f) {
						if (_logospr.alpha <= 0) {
							this.removeEventListener(Event.ENTER_FRAME, logoLogic);
							Main.$mode = "Menu";
							_logospr = null;
						} else {
							_logospr.alpha -= 0.1;
						}
					}
				}
			}
		}
	}
	
}