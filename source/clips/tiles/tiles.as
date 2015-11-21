package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.ColorTransform;
	import flash.net.SharedObject;
	
	public class tiles extends MovieClip
	{
		private var commonObj:Object;
		private var strokeColor:uint;
		private var fillColor:uint;
		private var strokeArr:Array = ["strokeTile1a", "strokeTile2a", "strokeTile1b", "strokeTile2b"];
		private var fillArr:Array = ["fillTile1a", "fillTile2a", "fillTile1b", "fillTile2b"];
		private var cwArr:Array = ["strokeTile1a", "fillTile1a", "strokeTile2b", "fillTile2b"];
		private var ccwArr:Array = ["strokeTile2a", "fillTile2a", "strokeTile1b", "fillTile1b"];
		
		private var rotStep:Number = 0.5;
		
		public function tiles():void
		{
			commonObj = SharedObject.getLocal("common-object", "/");
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void
		{
			strokeColor = (commonObj.data.strokeColor) ? commonObj.data.strokeColor : 0x000000;
			fillColor = (commonObj.data.fillColor) ? commonObj.data.fillColor : 0x444444;
			for each(var strokeName in strokeArr)
			{
				colorMC(this[strokeName], strokeColor);
			}
			for each(var fillName in fillArr)
			{
				colorMC(this[fillName], fillColor);
			}
			addEventListener(Event.ENTER_FRAME, turn);
		}
		
		public function turn(e:Event = null):void
		{
			for each(var cwName in cwArr)
			{
				this[cwName].rotation += rotStep;
			}
			for each(var ccwName in ccwArr)
			{
				this[ccwName].rotation -= rotStep;
			}
		}
	
		public function colorMC(targetMC:MovieClip, newColor:uint):void
		{
			var colorTransform:ColorTransform = targetMC.transform.colorTransform;
			colorTransform.color = newColor;
			targetMC.transform.colorTransform = colorTransform;
		}
	}
}