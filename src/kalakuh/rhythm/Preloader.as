package kalakuh.rhythm
{
	import flash.accessibility.ISearchableText;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.text.*;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Kalakuh
	 */
	public class Preloader extends MovieClip
	{
		[Embed(source = "../Assets/thumbnail.PNG")]private var img : Class;
		[Embed(source = "../Assets/credits.svg")]private var cred : Class;
		private var _thumbnail : Bitmap = new img();
		private var _loadingField : TextField = new TextField();
		private var _credits : Sprite = new cred();
		private var _format : TextFormat = new TextFormat(null, 30, 0xFFFFFF, null, null, null, null, null, "center");
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			
			addChild(this._thumbnail);
			addChild(this._loadingField);
			this._loadingField.defaultTextFormat = this._format;
			this._loadingField.width = stage.stageWidth;
			this._loadingField.height = stage.stageHeight;
			this._loadingField.y = stage.stageHeight / 2;
			
			addChild(this._credits);
			this._credits.y = stage.stageHeight - 45;
			this._credits.width *= 0.85;
			this._credits.x = (stage.stageWidth / 2) - (this._credits.width / 2);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			this._loadingField.text = "Loading...\n" + e.bytesLoaded + " / " + e.bytesTotal + " bytes loaded";
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			
			var n : Timer = new Timer(1000, 1);
			n.addEventListener(TimerEvent.TIMER, begin);
			n.start();
		}
		
		private function startup() : void 
		{
			var mainClass:Class = getDefinitionByName("kalakuh.rhythm.Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
		private function begin (e : TimerEvent) : void {
			this._loadingField.parent.removeChild(this._loadingField);
			this._loadingField = null;
			this._credits.parent.removeChild(this._credits);
			this._credits = null;
			this._thumbnail.parent.removeChild(this._thumbnail);
			this._thumbnail = null;
			startup();
		}
		
	}
	
}