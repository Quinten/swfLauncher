package	{

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
public class receptor extends MovieClip 
{	
	private var launch_so:SharedObject;
	private var nc:NetConnection;
	private var paramObj:Object;
	//private var rtmpGo:String = "failure";
	private var rtmpGo:String = "rtmp://localhost/ConnectToSharedObject";
	private var httpGo:String = "index.html";
	private var good:Boolean;
	private var commonObj:SharedObject;

	public function receptor():void 
	{
		trace("Ready to receive broadcasting!");
		//this.addEventListener(Event.ADDED_TO_STAGE, fullscreenBrowser);
		init();
	}
	
	public function init():void 
	{
		paramObj = this.root.loaderInfo.parameters;
		rtmpGo = (paramObj['rtmpGo']) ? paramObj['rtmpGo'] : rtmpGo;
		httpGo = (paramObj['httpGo']) ? paramObj['httpGo'] : httpGo;
		nc = new NetConnection( );
		nc.connect (rtmpGo);
		nc.addEventListener (NetStatusEvent.NET_STATUS,doSO);
		commonObj = SharedObject.getLocal("common-object", "/");
		trace(commonObj.data.textStr);
	}
	
	private function doSO (e:NetStatusEvent):void
	{
		good=e.info.code == "NetConnection.Connect.Success";
		if(good){
			launch_so=SharedObject.getRemote("launcherSO",nc.uri,false);
			launch_so.connect (nc);
			launch_so.addEventListener (SyncEvent.SYNC,launchResponse);
		}
	}
	
	private function launchResponse (e:SyncEvent):void
	{
		for (var chng:uint; chng<e.changeList.length; chng++){
			switch (e.changeList[chng].code){
				case "clear" :
				break;
				case "success" :
				break;
				case "change" :
					//textBox.appendText (text_so.data.msg + "\n");
					//trace(launch_so.data.stackClip);
					//trace(launch_so.data.stackLayer);
					//trace(launch_so.data.stackAction);
					//trace(e.changeList[chng].name);
					if(e.changeList[chng].name == "actionIndex"){
						if(launch_so.data.stackAction == "loadClip"){
							clearLayer(launch_so.data.stackLayer);
							loadClip(launch_so.data.stackClip, launch_so.data.stackLayer);
						}else if(launch_so.data.stackAction == "clearLayer"){
							clearLayer(launch_so.data.stackLayer);
						}else if(launch_so.data.stackAction == "applyColor"){
							trace("Next colors changed to " + launch_so.data.stackColor_name);
							flushColors();
						}else if(launch_so.data.stackAction == "applyText"){
							trace("Next Text changed to " + launch_so.data.stackText);
							flushText();
						}else if(launch_so.data.stackAction == "refreshBrowser"){
							trace("Action " + launch_so.data.stackAction);
							//first disable endless loop;)
							launch_so.setProperty ("stackAction", "loadClip");
							refreshBrowser();
						}else if(launch_so.data.stackAction == "fullscreenBrowser"){
							trace("Action " + launch_so.data.stackAction);
							//fullscreenBrowser();
							//stage.displayState = StageDisplayState.FULL_SCREEN;
						}
					}
				break;
			}
		}
	}
	
	private function refreshBrowser(e:Event = null):void
	{
		var refreshReq:URLRequest = new URLRequest(httpGo);
		navigateToURL(refreshReq, "_self");
	}
	
	private function fullscreenBrowser(e:Event = null):void
	{
		stage.displayState = StageDisplayState.FULL_SCREEN;
	}
	
	 private function flushColors():void {
		//var newColorObj:Object = new Object();
		commonObj.data.stackColor_name = launch_so.data.stackColor_name;
		commonObj.data.bgColor = launch_so.data.stackColor_bgColor;
		commonObj.data.shapefillColor = launch_so.data.stackColor_shapefillColor;
		commonObj.data.lightColor = launch_so.data.stackColor_lightColor;
		commonObj.data.strokeColor = launch_so.data.stackColor_strokeColor;
		commonObj.data.fillColor = launch_so.data.stackColor_fillColor;
		commonObj.data.txtColor = launch_so.data.stackColor_txtColor;
		//commonObj.data.colorObj = newColorObj;
		var flushStatus:String = null;
		try {
			flushStatus = commonObj.flush(10000);
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
	
	 private function flushText():void {
		commonObj.data.textStr = launch_so.data.stackText;
		var flushStatus:String = null;
		try {
			flushStatus = commonObj.flush(10000);
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
	
	private function clearLayer(layerID:int):void
	{
		trace("Clearing L" + layerID);
		for(var c:int = 0; c < this["L" + layerID].numChildren; c++){
			this["L" + layerID].removeChildAt(c);
		}
	}
	
	private function loadClip(urlPath:String, layerID:int):void
	{
		trace("Loading " + urlPath + " onto L" + layerID);
		var urlRequest:URLRequest = new URLRequest(urlPath);
		var swfLoader:Loader = new Loader();
		swfLoader.load(urlRequest);
		this["L" + layerID].addChild(swfLoader);
	}
}//END class
}//END package