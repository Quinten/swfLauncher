package{
import flash.display.MovieClip;
import flash.events.*;
import flash.geom.ColorTransform;
import flash.net.SharedObject;
public class sunbeam extends MovieClip {
	
	private var commonObj:SharedObject;
	
	public function sunbeam():void
	{
    	addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		commonObj = SharedObject.getLocal("common-object", "/");
		colorMC(sunbeamShape, commonObj.data.strokeColor);
		//trace(commonObj.data.textStr);
		//trace(commonObj.data.bgColor);
		this.addEventListener(Event.ENTER_FRAME, rotatebeam);
	}
	
	public function colorMC(targetMC:MovieClip, newColor:uint):void
	{
		var colorTransform:ColorTransform = targetMC.transform.colorTransform;
		colorTransform.color = newColor;
		targetMC.transform.colorTransform = colorTransform;
	}

	private function onAddedToStage(e:Event):void
	{
		sunbeamShape.x = stage.stageWidth /2;
		sunbeamShape.y = stage.stageHeight /2;
	}
	
	private function rotatebeam(e:Event):void
	{
		sunbeamShape.rotation += 0.4;
	}
	
}
}