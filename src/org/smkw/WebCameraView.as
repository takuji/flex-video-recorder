package org.smkw
{
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	import spark.components.Button;
	
	public class WebCameraView extends UIComponent
	{
		private var camera:Camera;
		private var mic:Microphone;
		private var video:Video;
		private var ns:NetStream;
		private var nc:NetConnection;
		private var videoName:String = "video";
		
		/**
		 *	bandwidth: Bytes per second
		 * 	quality: 1 - 100
		 *  bandwidthを指定する際はqualityを0、qualityを指定する際はbandwidthを0とする。 
		 */
		public function WebCameraView(width:int, height:int, bandwidth:int, quality:int)
		{
			setActualSize(width, height);

			camera = Camera.getCamera();
			if (camera != null) {
				camera.setMode(width, height, 30);
				camera.setQuality(bandwidth, quality);
				video = new Video(width, height);
				video.attachCamera(camera);
				addChild(video);
			}
			
			mic = Microphone.getMicrophone();
			if (mic != null) {
				mic.rate = 44;				
			}

			nc = new NetConnection();
			nc.objectEncoding = ObjectEncoding.AMF0;
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.connect("rtmp://localhost/recorder");
		}
		
		private function onNetStatus(event:NetStatusEvent):void {
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					trace("Connection Sccess");
					Alert.show("Connected!", "onNetStatus", Alert.OK);
					break;
				case "NetConnection.Connect.Closed":
					Alert.show("Closed", "onNetStatus", Alert.OK);
					trace("Connection Closed");
					break;
				case "NetConnection.Connect.Faild":
					Alert.show("Cnnect Failed", "onNetStatus", Alert.OK);
					trace("Connection Failed");
					break;
				case "NetConnection.Connect.Rejected":
					Alert.show("Connect Rejected", "onNetStatus", Alert.OK);
					trace("Connection Rejected");
					break;
				default:
					trace("evt.info.code");
			}
		}
		
		public function startRecording():void
		{
			if (nc != null && nc.connected) {
				ns = new NetStream(nc);
				if (camera != null) {
					ns.attachCamera(camera);				
				}
				if (mic != null) {
					ns.attachAudio(mic);
				}
				ns.publish(videoName, "record"); 				
			}
		}
		
		private function sendVideoAndSound():void {  
			ns = new NetStream(nc);

			/* support H.264 codec */
			/* */
			//var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			// h264Settings.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_5_1);
			
			// h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_2_1);
			// ns.videoStreamSettings = h264Settings;
			/* */
			
			// mic.setLoopBack(true);
			if (camera != null) {
				ns.attachCamera(camera);				
			}
			if (mic != null) {
				ns.attachAudio(mic);
			}
			
			// ExternalInterface.call('alert', String(connectionChannel) == "demo1");
			
			ns.publish("test", "record"); 
		}
		
		
		public function stopRecording():void
		{
			if (ns != null) {
				ns.close();
				ns.attachCamera(null);
				ns.attachAudio(null);
				ns = null;
			}
		}
		
		public function setVideoName(recordId:String):void
		{
			videoName = recordId;
		}
	}
}