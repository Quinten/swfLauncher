package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.SharedObject;
	import flash.utils.setInterval;
	import fl.motion.Animator;
	
	import randomUnique;
	
	public class horbats extends MovieClip
	{
		private var refWidth:Number = 100;
		private var refHeight:Number = 100;
		private var step:Number = 5;
		private var nRows:int = 6;
		private var stageW:Number = 1024;
		private var stageH:Number = 576;
		private var dingColor:int = 0xffffff;
		private var commonObj:Object;
		private var dingbatLoopStr:String = "abcdefghijklmnopqrstuvwxyz";
		private var letterIndex:int = 0;
		private var randomShuffleArr:Array;
		private var batIndex:int = 0;
		private var lastUniqueChar:String;
		private var intervalID:uint;
		
		public function horbats():void
		{
			//mainMC.textbox.autoSize = TextFieldAutoSize.CENTER;
			commonObj = SharedObject.getLocal("common-object", "/");
			dingColor = (commonObj.data.fillColor) ? commonObj.data.fillColor : dingColor;
			//dingbatLoopStr = (commonObj.data.textStr) ? commonObj.data.textStr : dingbatLoopStr;
			//dingbatLoopStr = dingbatLoopStr.toUpperCase();
			//dingbatLoopStr = dingbatLoopStr.toLowerCase();
			//mainMC.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
			//mainMC.textbox.text = newTitle;
			//addEventListener(Event.ENTER_FRAME, renderBat);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
			refHeight = stageH / nRows;
			//intervalID = setInterval(renderBat, 120);
			buildbat();
		}
		
		private function buildbat():void
		{
			randomShuffleArr = randomUnique.between(0, 25);
			var toUpper:Boolean = false;
			var toLeft:Boolean = false;
			for(var row:int = 0; row < nRows; row++){
				var rowWidth:Number = 0;
				while(rowWidth < (stageW + 800)){
					var newdingbat:dingbat = createbat(rowWidth, toLeft, toUpper);
					newdingbat.y = refHeight * row;
					rowWidth += newdingbat.width;
					this.addChild(newdingbat);
				}
				toUpper = (toUpper) ? false : true;
				toLeft = (toLeft) ? false : true;
			}
			addEventListener(Event.ENTER_FRAME, renderbat);
		}
		
		private function createbat(xpos:Number, left:Boolean = false, upperc:Boolean = false):dingbat
		{
			var newdingbat:dingbat = new dingbat();
			newdingbat.x = xpos;
			newdingbat.toLeft = left;
			newdingbat.textbox.autoSize = TextFieldAutoSize.RIGHT;
			var newtext:String = dingbatLoopStr.substr(randomShuffleArr[letterIndex], 1);
			newtext = (upperc) ? newtext.toUpperCase() : newtext;
			newdingbat.textbox.text = newtext;
			newdingbat.textbox.textColor = dingColor;
			letterIndex++;
			if(letterIndex == 26){letterIndex = 0;}
			var oldHeight:Number = newdingbat.height;
			newdingbat.height = refHeight;
			newdingbat.width = refHeight * (newdingbat.width/oldHeight);
			return newdingbat;
		}
		
		private function renderbat(e:Event):void
		{
			for(var c:int = 0; c < this.numChildren; c++){
				var targetdingbat:dingbat = this.getChildAt(c) as dingbat;
				targetdingbat.x += (targetdingbat.toLeft) ? -step : step;
				if(targetdingbat.toLeft && targetdingbat.x < (- 400)){
					targetdingbat.x += stageW + 800;
				}
				if(!targetdingbat.toLeft && targetdingbat.x > (stageW + 400)){
					targetdingbat.x -= stageW + 800;
				}
			}
		}
		
/*		public function renderBat(e:Event = null):void
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
		}*/
	}
}