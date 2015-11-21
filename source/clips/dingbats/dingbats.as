package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.SharedObject;
	import flash.utils.setInterval;
	import fl.motion.Animator;
	
	public class dingbats extends MovieClip
	{
		private var refWidth:Number = 700;
		private var refHeight:Number = 576;
		private var stageW:Number = 1024;
		private var stageH:Number = 576;
		private var commonObj:Object;
		private var dingbatLoopStr:String = "IADFHJKLCB";
		private var batIndex:int = 0;
		private var lastUniqueChar:String;
		private var intervalID:uint;
		
		public function dingbats():void
		{
			mainMC.textbox.autoSize = TextFieldAutoSize.CENTER;
			commonObj = SharedObject.getLocal("common-object", "/");
			dingbatLoopStr = (commonObj.data.textStr) ? commonObj.data.textStr : dingbatLoopStr;
			//dingbatLoopStr = dingbatLoopStr.toUpperCase();
			//dingbatLoopStr = dingbatLoopStr.toLowerCase();
			mainMC.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
			//mainMC.textbox.text = newTitle;
			//addEventListener(Event.ENTER_FRAME, renderBat);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
			intervalID = setInterval(renderBat, 120);
		}
		
		public function renderBat(e:Event = null):void
		{
			lastUniqueChar = nextUniqueChar();
			mainMC.textbox.text = lastUniqueChar;
			if(mainMC.width > mainMC.height){
				var oldWidth:Number = mainMC.width;
				mainMC.width = refWidth;
				mainMC.height = refWidth * (mainMC.height/oldWidth);
			}else{
				var oldHeight:Number = mainMC.height;
				mainMC.height = refHeight;
				mainMC.width = refHeight * (mainMC.width/oldHeight);				
			}
			mainMC.x = (stageW/2) - (mainMC.width/2);
			mainMC.y = (stageH/2) - (mainMC.height/2);
		}
		
		public function nextUniqueChar():String
		{
			var uniqueChar:String = dingbatLoopStr.substr(batIndex, 1);
			trace(uniqueChar);
			if(batIndex < (dingbatLoopStr.length - 1)){
				batIndex++;
			}else{
				batIndex = 0;
			}
			if(uniqueChar == lastUniqueChar || uniqueChar == " "){
				uniqueChar = nextUniqueChar();
			}
			return uniqueChar;
		}
	}
}