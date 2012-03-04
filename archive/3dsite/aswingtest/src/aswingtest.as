package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.*;
	
	public class aswingtest extends Sprite
	{
		private var myLoader:Loader = null;
		
		public function aswingtest()
		{
			//var t:test = new test();
			
			myLoader = new Loader();
			//myLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressStatus);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderReady);
			
			var fileRequest:URLRequest = new URLRequest("djc_alpha.png");
			myLoader.load(fileRequest);
			
			var t:aswing2 = new aswing2();
			//t.bringToTop();
			addChild(t);
		}
		
		
		public function onProgressStatus(e:ProgressEvent):void {   
			// this is where progress will be monitored     
			trace(e.bytesLoaded, e.bytesTotal); 
		}
		
		public function onLoaderReady(e:Event):void {     
			// the image is now loaded, so let's add it to the display tree!   
			myLoader.x = 100;
			myLoader.y = 100;
			addChild(myLoader);
		}
	}
}