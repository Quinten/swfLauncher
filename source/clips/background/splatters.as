package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.SharedObject;
	import flash.utils.*;
	
	public class splattersRainbow extends MovieClip
	{
		private var stageW:Number = 1024;
		private var stageH:Number = 576;
		private var commonObj:Object;
		private var splatterLoopStr:String = "abcdefghijklmnopqrstuvwxABCDEFGHIJKLMNOPQRST";
		private var intervalID:uint;
		
		public function splattersRainbow():void
		{
			commonObj = SharedObject.getLocal("common-object", "/");
			//dingbatLoopStr = (commonObj.data.textStr) ? commonObj.data.textStr : dingbatLoopStr;
			//dingbatLoopStr = dingbatLoopStr.toUpperCase();
			//dingbatLoopStr = dingbatLoopStr.toLowerCase();
			//mainMC.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
			intervalID = setInterval(splat, 120);
		}
		
		public function splat(e:Event = null):void
		{
			if(this.numChildren < 1000){
				var newSplatter:splatter = new splatter();
				newSplatter.x = (Math.random() * (stageW + 200)) - 200;
				newSplatter.y = (Math.random() * (stageH + 200)) - 200;
				var randomCharIndex:int = Math.floor(Math.random() * splatterLoopStr.length);
				newSplatter.textbox.text = " " +  splatterLoopStr.substr(randomCharIndex ,1);
				var randomColorIndex:int = Math.floor(Math.random() * 5);
				switch(randomColorIndex){
					case 0:
						newSplatter.textbox.textColor = (commonObj.data.shapefillColor) ? commonObj.data.shapefillColor : 0x000000;					
					    break;
					case 1:
						newSplatter.textbox.textColor = (commonObj.data.lightColor) ? commonObj.data.lightColor : 0x000000;
						break;
					case 2:
						newSplatter.textbox.textColor = (commonObj.data.strokeColor) ? commonObj.data.strokeColor : 0x000000;
						break;
					case 3:
						newSplatter.textbox.textColor = (commonObj.data.fillColor) ? commonObj.data.fillColor : 0x000000;
						break;
					case 4:
						newSplatter.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
					break;
					default:
				}
				//newSplatter.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
				this.addChild(newSplatter);
			}else{
				clearInterval(intervalID);
			}
			
		}
	}
}