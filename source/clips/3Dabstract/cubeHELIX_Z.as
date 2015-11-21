	/**
	 * ...
	 * @author Quinten Clause
	 */
	
package  
{
import flash.net.*;
import flash.display.*;
import flash.utils.setInterval;
import flash.events.*;

import org.papervision3d.objects.DisplayObject3D;
import org.papervision3d.objects.primitives.Cube;
import org.papervision3d.view.BasicView;
import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
import org.papervision3d.materials.WireframeMaterial;
import org.papervision3d.lights.PointLight3D;
import org.papervision3d.materials.utils.MaterialsList;

public class cubeHELIX_Z extends Sprite
{
	private var baseview:BasicView;
	private var helixShaded:DisplayObject3D;
	private var helixWireFr:DisplayObject3D;
	private var shadedCube:Array;
	private var wireFrCube:Array;
	private var filledCube:Array;
	private var shadedStair:Array;
	private var wireFrStair:Array;
	private var posStair:Array;
	private var numberStairs:Number = 48;
	private var heightStairs:Number = 80;
	private var offsetStairs:Number = 240;
	private var anglesStairs:Number = 40;//divide 360 by the number of stairs you want for each round of 360 degrees
	private var bottomHelix:Number = -720;
	private var topOffHelix:Number;
	
	public function cubeHELIX_Z(viewportWidth:Number = 720, viewportHeight:Number = 576, scaleToStage:Boolean = false, interactive:Boolean = false, cameraType:String = "CAMERA3D") 
	{
		baseview = new BasicView(viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
		this.addChild(baseview);
		
		//create the shadedHelix Container object
		helixShaded = new DisplayObject3D();
		helixShaded.rotationX = 90;
		baseview.scene.addChild(helixShaded);
		
		//create the wireframeHelix Container object
		helixWireFr = new DisplayObject3D();
		helixWireFr.rotationX = 90;
		helixWireFr.visible = false;
		baseview.scene.addChild(helixWireFr);
	
		//materials
		var flatShadeMaterial:FlatShadeMaterial = new FlatShadeMaterial(new PointLight3D(), 0x01df01, 0x01dffd);
		var materialsList:MaterialsList = new MaterialsList();
		materialsList.addMaterial(flatShadeMaterial, "all");
		var wireFrameMaterial:WireframeMaterial = new WireframeMaterial(0x000000, 100, 2);
		var materialsLine:MaterialsList = new MaterialsList();
		materialsLine.addMaterial(wireFrameMaterial, "all");
		var fillShadeMaterial:FlatShadeMaterial = new FlatShadeMaterial(new PointLight3D(), 0xffffff, 0xffffff);
		var materialsFill:MaterialsList = new MaterialsList();
		materialsFill.addMaterial(fillShadeMaterial, "all");
		
		//generate the grid positions
		shadedStair = new Array(numberStairs);
		wireFrStair = new Array(numberStairs);
		shadedCube = new Array(numberStairs);
		wireFrCube = new Array(numberStairs);
		filledCube = new Array(numberStairs);
		topOffHelix = numberStairs * heightStairs;
		for(var s:int = 0; s < numberStairs; s++)
		{
			var ypos:Number = bottomHelix + (s * heightStairs);
			var angl:Number = s * anglesStairs;
			//creating the stairs or spine
			shadedStair[s] = new DisplayObject3D();
			shadedStair[s].y = ypos;
			shadedStair[s].rotationY = angl;
			helixShaded.addChild(shadedStair[s]);
			wireFrStair[s] = new DisplayObject3D();
			wireFrStair[s].y = ypos;
			wireFrStair[s].rotationY = angl;
			helixWireFr.addChild(wireFrStair[s]);
			//the cubes
			shadedCube[s] = new Cube(materialsList, 120, 120, 120);
			shadedCube[s].x = offsetStairs;
			shadedStair[s].addChild(shadedCube[s]);
			wireFrCube[s] = new Cube(materialsLine, 120, 120, 120);
			wireFrCube[s].x = offsetStairs;
			wireFrStair[s].addChild(wireFrCube[s]);
			filledCube[s] = new Cube(materialsFill, 120, 120, 120);
			filledCube[s].x = offsetStairs;
			wireFrStair[s].addChild(filledCube[s]);
		}
		
		baseview.renderer.renderScene(baseview.scene, baseview.camera, baseview.viewport);
		
		this.renderHelix();
		var autoPilot:int = setInterval(switchLinesToFill, 4000);
	}	
	
	private function renderHelix():void
		{
			addEventListener(Event.ENTER_FRAME, onFrame);
			baseview.viewport.containerSprite.cacheAsBitmap = false;
		}
	
	private function switchLinesToFill():void
		{
			if(helixWireFr.visible == false){
				helixShaded.visible = false;
				helixWireFr.visible = true;
			}else{
				helixShaded.visible = true;
				helixWireFr.visible = false;
			}
		}
	
	private function onFrame(event:Event = null):void 
	{
		helixShaded.yaw(2);
		if(helixShaded.z > -4200){
			helixShaded.z -= 10;
		}else{
			helixShaded.z = 2400;
		}
		helixWireFr.yaw(2);
		if(helixWireFr.z > -4200){
			helixWireFr.z -= 10;
		}else{
			helixWireFr.z = 2400;
		}
		baseview.renderer.renderScene(baseview.scene, baseview.camera, baseview.viewport);
	}
	
		
}//End Class
	
}//End Package