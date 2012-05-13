package org.smkw
{
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.charts.BubbleChart;
	import mx.core.UIComponent;
	
	import spark.components.Button;
	
	public class WebCameraView extends UIComponent
	{
		private var camera:Camera;
		private var video:Video;
		private var ns:NetStream;
		private var nc:NetConnection;
		
		public function WebCameraView(width:int, height:int)
		{
			setActualSize(width, height);
			camera = Camera.getCamera();
			if (camera != null) {
				camera.setMode(width, height, 30);
				video = new Video(camera.width, camera.height);
				video.attachCamera(camera);
				addChild(video);
				this.width = camera.width;
				this.height = camera.height;
				
				try {
					nc = new NetConnection();
					nc.connect("rtmp://localhost:5400/olfaDemo/");
					
					//ns = new NetStream(nc);
					//ns.attachCamera(camera);					
				} catch (e:Error) {
					trace(e.toString());
				}				
			} else {
				
			}
		}
		
		public function startRecording():void
		{
			if (camera != null) {
				
			}
		}
		
		public function stopRecording():void
		{
			if (camera != null) {
				
			}
		}
	}
}