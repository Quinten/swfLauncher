package{
import flash.display.MovieClip;
import flash.events.*;
import flash.geom.ColorTransform;
import flash.net.SharedObject;
public class solidFill extends MovieClip {
	
	private var commonObj:SharedObject;
	
	public function solidFill():void
	{
    	addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		commonObj = SharedObject.getLocal("common-object", "/");
		colorMC(bgMC, commonObj.data.bgColor);
		//trace(commonObj.data.textStr);
		//trace(commonObj.data.bgColor);
	}
	
	public function colorMC(targetMC:MovieClip, newColor:uint):void
	{
		var colorTransform:ColorTransform = targetMC.transform.colorTransform;
		colorTransform.color = newColor;
		targetMC.transform.colorTransform = colorTransform;
	}

	private function onAddedToStage(e:Event):void
	{
		bgMC.width = stage.stageWidth;
		bgMC.height = stage.stageHeight;
	}
}
}