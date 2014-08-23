package kalakuh.rhythm
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	public class MenuLogic extends Sprite
	{	
		// Menu images
		[Embed(source = "../Assets/menuimg1.svg")] private var lvl1img : Class;
		[Embed(source = "../Assets/menuimg2.svg")] private var lvl2img : Class;
		[Embed(source = "../Assets/menuimg3.svg")] private var lvl3img : Class;
		[Embed(source = "../Assets/menuimg4.svg")] private var lvl4img : Class;
		
		// Default image if menu image doesn't exist
		[Embed(source = "../Assets/lvldefault.svg")] private var panelImg : Class;
		
		// level completed/not completed image
		[Embed(source = "../Assets/completed.png")]private var complImg : Class;
		[Embed(source = "../Assets/notcompleted.png")]private var notComplImg : Class;
		
		private var _panel : Sprite;
		private var _level : uint;
		private var _xVel : Number = 0;
		
		// for moving hazards
		public static var $xVel : int = 0;
		
		// now we can call functions from Main class
		private var _main : Main;
		
		private var _saving : SharedObject = SharedObject.getLocal("data");
		private var _n : int = 0;
		private var _r : int = 0;
		private var _complSpr : Bitmap;
		private var _notComplSpr : Bitmap;
		
		public function MenuLogic (main : Main, level : uint = 1) : void {
			this._level = level;
			this._main = main;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			switch (this._level) {
				case 1:
					this._panel = new lvl1img();
					break;
				case 2:
					this._panel = new lvl2img();
					break;
				case 3:
					this._panel = new lvl3img();
					break;
				case 4:
					this._panel = new lvl4img();
					break;
				default:
					this._panel = new panelImg();
					break;
			}
			addChild(this._panel);
		}
		
		private function init (e : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_complSpr = new complImg();
			addChild(_complSpr);
			_complSpr.y = (stage.stageHeight / 2) + 60;
			_complSpr.x = (stage.stageWidth / 2) - (_complSpr.width / 2) + ((this._level - 1) * stage.stageWidth);
			
			_notComplSpr = new notComplImg();
			_notComplSpr.width *= 0.9;
			addChild(_notComplSpr);
			_notComplSpr.y = _complSpr.y;
			_notComplSpr.x = (stage.stageWidth / 2) - (_notComplSpr.width / 2) + ((this._level - 1) * stage.stageWidth);
			
			_panel.height *= 2;
			_panel.width *= 2;
			_panel.addEventListener(MouseEvent.CLICK, onClick);
			_panel.addEventListener(Event.ENTER_FRAME, frameEnter);
			_panel.y = (stage.stageHeight / 2) - (_panel.height / 2);
			_panel.x = ((stage.stageWidth / 2) - (_panel.width / 2)) + ((this._level - 1) * stage.stageWidth);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyAction);
		}
		
		private function keyAction (e : KeyboardEvent) : void {
			if (Main.$mode == "Menu") {
				if (_xVel == 0) {
					if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.A) {
						this._xVel = 0;
						this._n = 50;
					}
					if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.D) {
						this._xVel = 0;
						this._n = -50;
					}
				}
			}
			if (e.keyCode == Keyboard.SPACE) {
				if ($xVel == 0) {
					if (_panel.x > 0 && _panel.x < stage.stageWidth) {
						if (_panel.alpha == 1) {
							Main.$mode = "Game";
							Main.$level = this._level;
							_main.playLevel(this._level);
							var disTime : Timer = new Timer (25, 10);
							
							disTime.addEventListener(TimerEvent.TIMER, disappear);
							disTime.start();
							_panel.alpha = 1;
							_r = 10;
						}
					}
				}
			}
		}
		
		private function isCompleted (level : uint, dataName : * ) : void {
			if (this._level == level) {
				if (dataName == true) {
					this._complSpr.visible = true;
					this._notComplSpr.visible = false;
				} else {
					this._complSpr.visible = false;
					this._notComplSpr.visible = true;
				}
			}
		}
		
		private function frameEnter (e : Event) : void {
			// check completed levels and display bitmaps
			isCompleted(1, _saving.data.first);
			isCompleted(2, _saving.data.second);
			isCompleted(3, _saving.data.third);
			isCompleted(4, _saving.data.fourth);
			
			// reappear if alpha is 0 and level selection is open
			if (Main.$mode == "Menu" && this._panel.alpha == 0) {
				this._panel.alpha = 0.05;
				var reTime : Timer = new Timer (25, 19);
				_r = reTime.repeatCount;
				reTime.addEventListener(TimerEvent.TIMER, reappear);
				reTime.start();
			}
			
			// TODO: Make the following code shorter
			if (this._n != 0) {
				if (this._n > 0) {
					if (this._n > 25) {
						this._xVel++;
						if (_xVel > 20) {
							_panel.x--;
							_complSpr.x--;
							_notComplSpr.x--;
						}
						_panel.x += _xVel;
						_complSpr.x += _xVel;
						_notComplSpr.x += _xVel;
					} else {
						if (_xVel > 20) {
							_panel.x--;
							_complSpr.x--;
							_notComplSpr.x--;
						}
						_panel.x += _xVel;
						_complSpr.x += _xVel;
						_notComplSpr.x += _xVel;
						this._xVel--;
					}
					this._n--;
				} else {
					if (this._n < -25) {
						this._xVel--;
						if (_xVel < -20) {
							_panel.x++;
							_complSpr.x++;
							_notComplSpr.x++;
						}
						_panel.x += _xVel;
						_complSpr.x += _xVel;
						_notComplSpr.x += _xVel;
					} else {
						if (_xVel < -20) {
							_panel.x++;
							_complSpr.x++;
							_notComplSpr.x++;
						}
						_panel.x += _xVel;
						_complSpr.x += _xVel;
						_notComplSpr.x += _xVel;
						this._xVel++;
					}
					this._n++;
				}
				$xVel = this._xVel;
			}
			
			// hazard color changing
			if (this._panel.x > 0 && this._panel.x < stage.stageWidth) {
				Main.$level = this._level;
			}
			
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			
			spriteActions(_panel);
			bitmapActions(_complSpr);
			bitmapActions(_notComplSpr);
			
			addChild(_complSpr);
			addChild(_notComplSpr);
			
			_complSpr.alpha = _panel.alpha;
			_notComplSpr.alpha = _panel.alpha;
		}
		
		private function onClick (e : MouseEvent) : void {
			if ($xVel == 0) {
				if (_panel.alpha == 1) {
					Main.$mode = "Game";
					Main.$level = this._level;
					_main.playLevel(this._level);
					var disTime : Timer = new Timer (25, 10);
					
					disTime.addEventListener(TimerEvent.TIMER, disappear);
					disTime.start();
					_panel.alpha = 1;
					_r = 10;
				}
			}
		}
		
		// change position of sprite/bitmap if it's x < -stageWidth / 2 or x > stageWidth * levelCount
		private function spriteActions (spr : Sprite) : void {
			if (spr.x <= (stage.stageWidth / 2) - (spr.width / 2) - stage.stageWidth) {
					spr.x += Main.$levelCount * stage.stageWidth;
			}
			if (spr.x > ((stage.stageWidth / 2) - (spr.width / 2)) + ((Main.$levelCount - 1) * stage.stageWidth)) {
					spr.x -= Main.$levelCount * stage.stageWidth;
			}
		}
		
		private function bitmapActions (bitmap : Bitmap) : void {
			if (bitmap.x <= (stage.stageWidth / 2) - (bitmap.width / 2) - stage.stageWidth) {
					bitmap.x += Main.$levelCount * stage.stageWidth;
			}
			if (bitmap.x > ((stage.stageWidth / 2) - (bitmap.width / 2)) + ((Main.$levelCount - 1) * stage.stageWidth)) {
					bitmap.x -= Main.$levelCount * stage.stageWidth;
			}
		}
		
		private function disappear (e : TimerEvent) : void {
			this._panel.alpha -= 0.1;
			this._r--;
			// make sure that alpha is 0 after the timer ends
			if (this._r == 0) {
				this._panel.alpha = 0;
			}
		}
		
		private function reappear (e : TimerEvent) : void {
			this._panel.alpha += 0.05;
			this._r--;
			// make sure that alpha is 1 after the timer ends
			if (this._r == 0) {
				this._panel.alpha = 1;
			}
		}
	}	
}