package{

import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.geom.ColorTransform;

public class wurmhole extends MovieClip
{
	public var ringArr:Array = new Array();
	public const nRing:int = 20;
	public var rotationSpeed:Number = 2;
	public var scaleSpeed:Number = 0.02;
	public var size:Number = 500;
	
	public function wurmhole():void
	{
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function init(e:Event = null):void
	{
		size = stage.stageWidth*5;
		for(var r:int = 0; r < nRing; r++){
			var ringObj:ring = new ring();
			ringObj.x = stage.stageWidth * 2 / 3;
			ringObj.y = stage.stageHeight/2;
			ringObj.rotation = Math.floor(Math.random()*180);
			ringObj.scaleX = ringObj.scaleY = r;
			//ringObj.transform.colorTransform = new ColorTransform(1,Math.random(),Math.random(),1,0,Math.random()*255,Math.random()*255,1);
			ringObj.transform.colorTransform = new ColorTransform(Math.random(),Math.random(),Math.random(),1,Math.random()*255,Math.random()*255,Math.random()*255,1);
			ringArr[r] = ringObj;
			addChild(ringArr[r]);
		}
		addEventListener(Event.ENTER_FRAME, animationLoop);
	}
	
	public function animationLoop(e:Event):void
	{
		for each(var ringObj in ringArr){
			//ringObj.rotation += rotationSpeed;
			if(ringObj.width > size && ringObj.height > size){
				ringObj.scaleX = ringObj.scaleY = 0;
				this.setChildIndex(ringObj, 0);
				//ringObj.transform.colorTransform = new ColorTransform(1,Math.random(),Math.random(),1,0,Math.random()*255,Math.random()*255,1);
				ringObj.transform.colorTransform = new ColorTransform(Math.random(),Math.random(),Math.random(),1,Math.random()*255,Math.random()*255,Math.random()*255,1);
			}else{
				ringObj.scaleX = ringObj.scaleY = ringObj.scaleX + (1 + ringObj.scaleX) * scaleSpeed;
			}
		}
	}
}
}