package com.ya.object 
{
	import flash.automation.ActionGenerator;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.media.Video;
	/**
	 * ...
	 * @author Yusuf Afandi
	 */
	public class CustomCamera 
	{
		public static const CAMERA_CLOSE:String = "cam_close";
		public static const CAMERA_STANDBY:String = "cam_standby";
		public static const CAMERA_PAUSE:String = "cam_pause";
		
		private var cam:Camera;
		private var vid:Video;
		private var container:MovieClip;
		
		private var thisHeight:int;
		private var thisWidth:int;
		
		private var state:String = "";
		
		public function CustomCamera(_container:MovieClip,_width:int,_height:int,_fps:int) 
		{
			
			cam = Camera.getCamera();
			
			vid = new Video(_width,_height);
			cam.setMode(_width, _height,_fps);
			
			thisWidth = _width;
			thisHeight = _height;
			
			vid.attachCamera(cam);
			container = _container;
			container.addChild(vid);
		}
		
		public function SetCameraMode(_width:int,_height:int,_fps:int):void
		{
			thisWidth = _width;
			thisHeight = _height;
			cam.setMode(_width, _height, _fps);
		}
		
		public function SwitchCamera():void
		{
			var camNames:String = cam.name;
			
			//check camera number
			if (Camera.names.length == 1)
			{
				trace("kamu hanya punya satu kamera");
				return;
			}
			
			for (var i:int = 0; i < Camera.names.length; i++)
			{
				if (Camera.names[i] == camNames)
				{
					//this is last camera, 
					// get first camera
					if (i == Camera.names.length -1)
					{
						cam = Camera.getCamera("1");
					}else {
						//get next camera
						cam = Camera.getCamera("" + (1 + i));
					}
				}
				
			}
			
			vid.attachCamera(null);
			vid.attachCamera(cam);
		}
		
		public function CloseCamera():void
		{
			state = CAMERA_CLOSE;
			vid.attachCamera(null);
			
			container.removeChild(vid);
		}
		
		public function PauseCamera():void
		{
			state = CAMERA_PAUSE;
			vid.attachCamera(null);
			
			if (!container.contains(vid))
				container.addChild(vid);
			
		}
		
		public function ResumeCamera():void
		{
			state = CAMERA_STANDBY;
			vid.attachCamera(cam);
			
			if (!container.contains(vid))
				container.addChild(vid);
		}
		
		public function RotateCamera():void
		{
			container.removeChild(vid);
			vid.attachCamera(null);
			
			if (vid.rotation == 0)
			{
				
				cam.setMode(this.thisHeight, this.thisWidth, 60);
				vid = new Video(this.thisHeight, this.thisWidth);
				
				vid.rotation = 90;
				vid.y = 0;
				vid.x = vid.width;
			}else if (vid.rotation == 90)
			{
				cam.setMode(thisWidth, thisHeight, 60);
				vid = new Video(this.thisWidth, this.thisHeight);
				
				vid.rotation = 180;
				vid.y = vid.height;
				vid.x = vid.width;
			}else if (vid.rotation == 180)
			{
				cam.setMode(this.thisHeight, this.thisWidth, 60);
				vid = new Video(this.thisHeight, this.thisWidth);
				
				vid.rotation = -90;
				vid.x = 0;
				vid.y = vid.height;
			}else if (vid.rotation == -90)
			{
				cam.setMode(thisWidth, thisHeight, 60);
				vid = new Video(this.thisWidth, this.thisHeight);
				vid.rotation = 0;
				vid.x = 0;
				vid.y = 0;
			}
			
			vid.attachCamera(cam);
			container.addChild(vid);
		}
		
		
		public function GetBitmapData():BitmapData
		{
			var bmd:BitmapData = new BitmapData(container.width, container.height, false);
			bmd.draw(container);
			return bmd;
		}
		
		public function GetState():String
		{
			return state;
		}
	}

}