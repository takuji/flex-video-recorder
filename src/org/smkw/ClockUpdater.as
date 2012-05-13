package org.smkw
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class ClockUpdater
	{
		private var interval:int;
		private var timer:Timer;
		private var callback:Function;
		private var startTime:int;
		
		public function ClockUpdater(interval:int, callback:Function)
		{
			this.interval = interval;
			this.callback = callback;
			timer = null;
			startTime = 0;
		}
		
		public function start():void {
			if (timer == null) {
				timer = new Timer(interval, 0);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				var now:Date = new Date();
				startTime = now.getTime();
				timer.start();
			}
		}
		
		public function stop():void {
			if (timer != null) {
				timer.stop();
				timer = null;
			}
		}
		
		private function onTimer(event:TimerEvent):void {
			if (callback != null) {
				var now:Date = new Date();
				callback(now.getTime() - startTime);
			}
		}
	}
}