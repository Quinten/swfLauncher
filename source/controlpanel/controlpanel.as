package	{

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.ColorTransform;
	import flash.net.*;
	import fl.controls.List;
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;
	
public class controlpanel extends MovieClip 
{
	public var swfLauncherXML:XML;
	public var launchObj:Object;
	public var launchBatch:Array = new Array();
	public var batchIndex:int = 0;
	public var batchIntervalID:uint;
	public var currentBatch:int = 0;
	
	private var launch_so:SharedObject;
	private var nc:NetConnection;
	private var paramObj:Object;
	//private var rtmpGo:String = "failure";
	private var rtmpGo:String = "rtmp://localhost/ConnectToSharedObject";
	private var good:Boolean;
	private var actionIndex:int = 0;
	
	private var commonObj:Object;
	private var colorPallette:SharedObject;
	private var colorPalletteArr:Array = new Array();

	public function controlpanel():void 
	{
		trace("Let's control the panel!");
		init();
	}
	
	public function init():void 
	{
		commonObj = new Object();
		launchObj = new Object();
		launchObj.stackClip = "";
		launchObj.stackLayer = 0;
		colorPallette = SharedObject.getLocal("color-pallette");
		colorPalletteArr = (colorPallette.data.colorArr == undefined) ? colorPalletteArr : colorPallette.data.colorArr;
		createUI();
		loadXML();
		paramObj = this.root.loaderInfo.parameters;
		rtmpGo = (paramObj['rtmpGo']) ? paramObj['rtmpGo'] : rtmpGo;
		nc = new NetConnection( );
		nc.connect (rtmpGo);
		nc.addEventListener (NetStatusEvent.NET_STATUS,doSO);
	}
	
	private function doSO (e:NetStatusEvent):void
	{
		good=e.info.code == "NetConnection.Connect.Success";
		if(good){
			launch_so=SharedObject.getRemote("launcherSO",nc.uri,false);
			launch_so.connect (nc);
			//launch_so.addEventListener (SyncEvent.SYNC,checkSO);
		}
	}
	
	 private function saveColor(event:MouseEvent):void {
		var newColorObj:Object = new Object();
		newColorObj.name = labelPickerBox.text;
		newColorObj.bgColor = backgroundPicker.selectedColor;
		newColorObj.shapefillColor = shapefillPicker.selectedColor;
		newColorObj.lightColor = lightPicker.selectedColor;
		newColorObj.strokeColor = strokePicker.selectedColor;
		newColorObj.fillColor = fillPicker.selectedColor;
		newColorObj.txtColor = textPicker.selectedColor;
		colorList.addItem({label:newColorObj.name, data:newColorObj});
		trace(colorPallette.data.colorArr);
		//colorPalletteArr = colorPallette.data.colorArr;
		colorPalletteArr.push(newColorObj);
		colorPallette.data.colorArr = colorPalletteArr;
		
		var flushStatus:String = null;
		try {
			flushStatus = colorPallette.flush(10000);
		} catch (error:Error) {
			trace("Error...Could not write SharedObject to disk\n");
		}
		if (flushStatus != null) {
			switch (flushStatus) {
				case SharedObjectFlushStatus.PENDING:
					trace("Requesting permission to save object...\n");
					//colorPallette.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
					break;
				case SharedObjectFlushStatus.FLUSHED:
					trace("Value flushed to disk.\n");
					break;
			}
		}
	}
	
	 private function saveText(event:MouseEvent):void {
		var newTextStr:String = textBox.text;
		textList.addItem({label:newTextStr, data:newTextStr});
	}
	
	public function loadXML():void
	{
		var XMLlocationStr:String = "swfLauncher.xml";
		var XMLloader:URLLoader = new URLLoader(new URLRequest(XMLlocationStr));
		XMLloader.addEventListener(Event.COMPLETE, xmlLoaded);
	}
	
	public function xmlLoaded(e:Event):void
	{
		swfLauncherXML = new XML(e.currentTarget.data);
		//trace(swfLauncherXML.toXMLString());
		clipList.addEventListener(Event.CHANGE, changeStackClip);
		for each(var clipPathStr in swfLauncherXML.clipList.clipPath)
		{
			trace(clipPathStr);
			clipList.addItem({label:clipPathStr, data:clipPathStr});
		}
		for each(var textStr in swfLauncherXML.textList.textStr)
		{
			trace(textStr);
			textList.addItem({label:textStr, data:textStr});
		}
		for each(var colorObjXML in swfLauncherXML.colorList.colorObj)
		{
			var newColorObj:Object = new Object();
			newColorObj.name = colorObjXML.name;
			newColorObj.bgColor = uint(colorObjXML.bgColor);
			newColorObj.shapefillColor = uint(colorObjXML.shapefillColor);
			newColorObj.lightColor = uint(colorObjXML.lightColor);
			newColorObj.strokeColor = uint(colorObjXML.strokeColor);
			newColorObj.fillColor = uint(colorObjXML.fillColor);
			newColorObj.txtColor = uint(colorObjXML.txtColor);
			colorList.addItem({label:newColorObj.name, data:newColorObj});
		}
	}
	
	public function changeStackClip(e:Event):void
	{
		trace("stackClip changed to " + e.target.selectedItem.data);
		launchObj.stackClip = e.target.selectedItem.data;
	}
	
	
	public function createUI():void
	{
		layerList.addEventListener(Event.CHANGE, changeStackLayer);
		for(var a:int = 0; a < 5; a++){
			layerList.addItem({label:"L" + a + " : no clips", data:a});
		}
		loadClipButton.label = "load";
		loadClipButton.addEventListener(MouseEvent.CLICK, loadClip);
		clearLayerButton.label = "clear";
		clearLayerButton.addEventListener(MouseEvent.CLICK, clearLayer);
		addBatchButton.label = "add";
		addBatchButton.addEventListener(MouseEvent.CLICK, addBatch);
		removeBatchButton.label = "remove";
		removeBatchButton.addEventListener(MouseEvent.CLICK, removeBatch);
		runBatchButton.label = "run";
		runBatchButton.addEventListener(MouseEvent.CLICK, runBatch);
		backgroundPicker.addEventListener(ColorPickerEvent.CHANGE, colorChange);
		shapefillPicker.addEventListener(ColorPickerEvent.CHANGE, colorChange);
		lightPicker.addEventListener(ColorPickerEvent.CHANGE, colorChange);
		strokePicker.addEventListener(ColorPickerEvent.CHANGE, colorChange);
		fillPicker.addEventListener(ColorPickerEvent.CHANGE, colorChange);
		textPicker.addEventListener(ColorPickerEvent.CHANGE, colorChange);
		saveColorButton.label = "save";
		saveColorButton.addEventListener(MouseEvent.CLICK, saveColor);
		for each(var savedColorObj:Object in colorPalletteArr){ 
			colorList.addItem({label:savedColorObj.name, data:savedColorObj});
		}
		colorList.addEventListener(Event.CHANGE, changeStackColor);
		textList.addEventListener(Event.CHANGE, changeStackText);
		saveTextButton.label = "save";
		saveTextButton.addEventListener(MouseEvent.CLICK, saveText);
		applyTextButton.label = "apply";
		applyTextButton.addEventListener(MouseEvent.CLICK, passStackText);
		applyColorButton.label = "apply";
		applyColorButton.addEventListener(MouseEvent.CLICK, passStackColor);
		//misc
		refreshButton.label = "refresh";
		refreshButton.addEventListener(MouseEvent.CLICK, refreshBrowser);
		//fscreenButton.label = "fsrcn";
		//fscreenButton.addEventListener(MouseEvent.CLICK, fullscreenBrowser);
		bgfillButton.label = "bgfill";
		bgfillButton.addEventListener(MouseEvent.CLICK, bgfillReload);
	}

	public function refreshBrowser(e:MouseEvent = null):void
	{
		trace("Forced browser refresh...");
		launchObj.stackAction = "refreshBrowser";
		// pass launchObj
		passLaunchObj();		
	}

	public function fullscreenBrowser(e:MouseEvent = null):void
	{
		trace("Forced browser to go fullscreen...");
		launchObj.stackAction = "fullscreenBrowser";
		// pass launchObj
		passLaunchObj();
	}

	public function bgfillReload(e:MouseEvent = null):void
	{
		trace("Reloading the backgroundfill...");
		launchObj.stackLayer = 0;
		launchObj.stackClip = "clips/background/solidFill.swf";
		launchObj.stackAction = "loadClip";
		trace(launchObj.stackAction + " with " + launchObj.stackClip + " on to L" + launchObj.stackLayer);
		layerList.removeItemAt(launchObj.stackLayer);
		layerList.addItemAt({label:"L" + launchObj.stackLayer + " : " + launchObj.stackClip, data:launchObj.stackLayer}, launchObj.stackLayer);
		layerList.selectedItem = layerList.getItemAt(launchObj.stackLayer);
		//layerList.selectedItem.label = "L" + launchObj.stackLayer + " : " + launchObj.stackClip;
		// pass launchObj
		passLaunchObj();
	}

	public function passStackText(e:MouseEvent = null):void
	{
		launch_so.setProperty ("stackAction", "applyText");
		launch_so.setProperty ("stackText", commonObj.stackText);
		launch_so.setProperty ("actionIndex", actionIndex++);
	}

	public function passStackColor(e:MouseEvent = null):void
	{
		launch_so.setProperty ("stackAction", "applyColor");
		launch_so.setProperty ("stackColor_name", commonObj.stackColor.name);
		launch_so.setProperty ("stackColor_bgColor", commonObj.stackColor.bgColor);
		launch_so.setProperty ("stackColor_shapefillColor", commonObj.stackColor.shapefillColor);
		launch_so.setProperty ("stackColor_lightColor", commonObj.stackColor.lightColor);
		launch_so.setProperty ("stackColor_strokeColor", commonObj.stackColor.strokeColor);
		launch_so.setProperty ("stackColor_fillColor", commonObj.stackColor.fillColor);
		launch_so.setProperty ("stackColor_txtColor", commonObj.stackColor.txtColor);
		launch_so.setProperty ("actionIndex", actionIndex++);
	}
		
	private function changeStackText(e:Event):void
	{
		commonObj.stackText = e.target.selectedItem.data;
		trace("stackText changed to " + e.target.selectedItem.data);
	}
	
	private function changeStackColor(e:Event):void
	{
		commonObj.stackColor = e.target.selectedItem.data;
		trace("stackColor changed to " + commonObj.stackColor.name);
		colorMC(previewPaletMC.backgroundMC, commonObj.stackColor.bgColor);
		colorMC(previewPaletMC.shapefillMC, commonObj.stackColor.shapefillColor);
		colorMC(previewPaletMC.lightMC, commonObj.stackColor.lightColor);
		colorMC(previewPaletMC.strokeMC, commonObj.stackColor.strokeColor);
		colorMC(previewPaletMC.fillMC, commonObj.stackColor.fillColor);
		colorMC(previewPaletMC.textMC, commonObj.stackColor.txtColor);
	}
	
	private function colorChange(e:ColorPickerEvent):void {
		var cp:ColorPicker = e.target as ColorPicker;
        	switch (cp) {
        		case backgroundPicker:
                    colorMC(mixPaletMC.backgroundMC, cp.selectedColor);
                    break;
        		case shapefillPicker:
                    colorMC(mixPaletMC.shapefillMC, cp.selectedColor);
                    break;
        		case lightPicker:
                    colorMC(mixPaletMC.lightMC, cp.selectedColor);
                    break;
        		case strokePicker:
                    colorMC(mixPaletMC.strokeMC, cp.selectedColor);
                    break;
        		case fillPicker:
                    colorMC(mixPaletMC.fillMC, cp.selectedColor);
                    break;
        		case textPicker:
                    colorMC(mixPaletMC.textMC, cp.selectedColor);
                    break;
                default:
                    break;
            }
    }

	public function colorMC(targetMC:MovieClip, newColor:uint):void
	{
		var colorTransform:ColorTransform = targetMC.transform.colorTransform;
		colorTransform.color = newColor;
		targetMC.transform.colorTransform = colorTransform;
	}
	
	public function changeStackLayer(e:Event):void
	{
		trace("stackLayer changed to " + e.target.selectedItem.data);
		launchObj.stackLayer = e.target.selectedItem.data;
	}
	
	public function loadClip(e:MouseEvent):void
	{
		launchObj.stackAction = "loadClip";
		trace(launchObj.stackAction + " with " + launchObj.stackClip + " on to L" + launchObj.stackLayer);
		layerList.removeItemAt(launchObj.stackLayer);
		layerList.addItemAt({label:"L" + launchObj.stackLayer + " : " + launchObj.stackClip, data:launchObj.stackLayer}, launchObj.stackLayer);
		layerList.selectedItem = layerList.getItemAt(launchObj.stackLayer);
		//layerList.selectedItem.label = "L" + launchObj.stackLayer + " : " + launchObj.stackClip;
		// pass launchObj
		passLaunchObj();
	}
	
	public function clearLayer(e:MouseEvent):void
	{
		launchObj.stackAction = "clearLayer";
		trace(launchObj.stackAction + " L" + launchObj.stackLayer);
		layerList.removeItemAt(launchObj.stackLayer);
		layerList.addItemAt({label:"L" + launchObj.stackLayer + " : no clips", data:launchObj.stackLayer}, launchObj.stackLayer);
		layerList.selectedItem = layerList.getItemAt(launchObj.stackLayer);
		// pass launchObj
		passLaunchObj();
	}
	
	public function passLaunchObj():void
	{
		if(launch_so.data.stackClip != launchObj.stackClip || launch_so.data.stackAction != launchObj.stackAction || launch_so.data.stackLayer != launchObj.stackLayer ){
			launch_so.setProperty ("stackAction", launchObj.stackAction);
			launch_so.setProperty ("stackLayer", launchObj.stackLayer);
			launch_so.setProperty ("stackClip", launchObj.stackClip);
			launch_so.setProperty ("actionIndex", actionIndex++);
		}
	}
	
	public function addBatch(e:MouseEvent):void
	{
		batchList.addItem({label:"Load: " + launchObj.stackClip + " on L" + launchObj.stackLayer});
		launchBatch[batchIndex] = new Object();
		launchBatch[batchIndex].stackClip = launchObj.stackClip;
		launchBatch[batchIndex].stackLayer = launchObj.stackLayer;
		batchIndex++;
	}
	
	public function removeBatch(e:MouseEvent):void
	{
		var targetIndex:int = batchList.selectedIndex; 
		batchList.removeItemAt(targetIndex);
		launchBatch[targetIndex] = null;
	}
	
	public function runBatch(e:MouseEvent):void
	{
		var secInt:Number = Number(secondIntervalBox.text);
		trace("Starting batch with a " + secInt + " second interval.");
		runBatchButton.label = "stop";
		runBatchButton.removeEventListener(MouseEvent.CLICK, runBatch);
		runBatchButton.addEventListener(MouseEvent.CLICK, stopBatch);
		batchIntervalID = setInterval(batchLoad, secInt * 1000);
		batchLoad();
	}
	
	public function batchLoad():void
	{
		var launchTMP:Object = launchBatch[currentBatch];
		trace("New Batch Load.");
		if(launchTMP != null && (launch_so.data.stackClip != launchTMP.stackClip || launch_so.data.stackLayer != launchTMP.stackLayer)){
			launch_so.setProperty ("stackAction", "loadClip");
			launch_so.setProperty ("stackLayer", launchTMP.stackLayer);
			launch_so.setProperty ("stackClip", launchTMP.stackClip);
			launch_so.setProperty ("actionIndex", actionIndex++);
			layerList.removeItemAt(launchTMP.stackLayer);
			layerList.addItemAt({label:"L" + launchTMP.stackLayer + " : " + launchTMP.stackClip, data:launchTMP.stackLayer}, launchObj.stackLayer);
			layerList.selectedItem = layerList.getItemAt(launchTMP.stackLayer);
		}
		if(currentBatch == (launchBatch.length - 1)){
			refreshBrowser();
		}
		currentBatch = (currentBatch < launchBatch.length) ? currentBatch + 1 : 0;
		if(launchTMP == null){
			batchLoad();
		}
	}
	
	public function stopBatch(e:MouseEvent):void
	{
		trace("Stopping batch.");
		runBatchButton.label = "run";
		runBatchButton.removeEventListener(MouseEvent.CLICK, stopBatch);
		runBatchButton.addEventListener(MouseEvent.CLICK, runBatch);
		clearInterval(batchIntervalID);
	}

}//END class
}//END package