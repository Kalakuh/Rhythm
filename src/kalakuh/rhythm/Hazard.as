package kalakuh.rhythm
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	public class Hazard extends Sprite
	{
		[Embed(source = "../Assets/death.mp3")]private var _dthSound : Class;
		private var deathsong : Sound = new _dthSound();
		private var _type : uint;
		public var spr : Sprite = new Sprite();
		private var _firstColor : Array = new Array(0xFF0000, 0xFF3333, 0xFF00FF, 0xFF33FF, 0xFF66FF, 0xFF0066);
		private var _secondColor : Array = new Array(0xAAAAFF, 0xAADDFF, 0x66AAFF, 0xBBFFFF, 0xAACCFF, 0x66FFFF);
		private var _thirdColor : Array = new Array(0xFFDBAA, 0xFFDD66, 0xFFFF33, 0xFFFF00, 0xFEDD33, 0xEEDD33);
		private var _fourthColor : Array = new Array(0xAAFFAA, 0xAAFF66, 0x66FFAA, 0x66FFCC, 0x33DD66, 0xBBFFCC);
		private var _color : uint;
		private var _dir : int;
		private var _n : uint = 0;
		private var _a : Number = 1;
		private var _i : int = 0;
		private var _b : Boolean = false;
		private var _startX : Number = 0;
		
		public function Hazard (type : uint = 1) : void {
			this._type = type;
			addChild(spr);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function randomColor(a : Array) : uint {
			return a[Math.floor(Math.random() * a.length)];
		}
		
		public function getB () : Boolean {
			return this._b;
		}
		
		private function init (e : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			var n : uint = Math.floor(Math.random() * 4);
			
			switch(n) {
				case 0:
					spr.x = Math.random() * stage.stageWidth;
					spr.y = 0;
					_dir = 1;
					break;
				case 1:
					spr.x = Math.random() * stage.stageWidth;
					spr.y = stage.stageHeight;
					_dir = 2;
					break;
				case 2:
					spr.x = 0;
					spr.y = Math.random() * stage.stageHeight;
					_dir = 3;
					break;
				case 3:
					spr.x = stage.stageWidth;
					spr.y = Math.random() * stage.stageHeight;
					_dir = 4;
					break;
				default:
					trace("Error: switch scope failed - n: " + n);
					break;
			}
			this._startX = spr.x;
			
			switch (this._type) {
				case 1:
					this._color = randomColor(_firstColor);
					break;
					
				case 2:
					this._color = randomColor(_secondColor);
					break;
					
				case 3:
					this._color = randomColor(_thirdColor);
					break;
				case 4:
					this._color = randomColor(_fourthColor);
					break;
				default:
					break;
			}
		}
		
		// must be public so HazardManager can remove Event Listener
		public function update (e : Event) : void {
			if (spr != null) {
				if (this._n < 40) {
				this._n++;
			} else if (!(this._n > 40)) {
				if (this._dir <= 2) {
					this._n = stage.stageHeight;
				} else {
					this._n = stage.stageWidth;
				}
			} else {
				this._a -= 0.05;
				if (this._a <= 0) {
					this._b = true;
				}
			}
			// reset it before defining it again!
			spr.graphics.clear();
			spr.graphics.lineStyle(15, this._color, this._a);
			switch(this._dir) {
				case 1:
					spr.graphics.lineTo(0, _n);
					spr.y = 0;
					break;
				case 2:
					spr.graphics.lineTo(0, -_n);
					spr.y = stage.stageHeight;
					break;
				case 3:
					spr.graphics.lineTo(_n, 0);
					spr.x = _startX;
					break;
				case 4:
					spr.graphics.lineTo(-_n, 0);
					spr.x = _startX;
					break;
				default:
					trace("Error: _dir is defined incorrecly - dir: " + _dir);
					break;
			}
			}
			if (Player.$alive && Main.$mode == "Game") {
				switch (this._dir) {
					case 1:						
					case 2:
						if (_n == stage.stageHeight) {
							if (Player.$x < spr.x + 20 && Player.$x > spr.x - 20 && _a == 1) {
								Player.$alive = false;
								deathsong.play();
							}
						}
						break;
					case 3:
					case 4:
						if (_n == stage.stageWidth) {
							if (Player.$y < spr.y + 20 && Player.$y > spr.y - 20 && _a == 1) {
								Player.$alive = false;
								deathsong.play();
							}
						}
						break;
					default:
						break;
				}
			}
			spr.x += MenuLogic.$xVel;
			_startX += MenuLogic.$xVel;
		}
	}
	
}
