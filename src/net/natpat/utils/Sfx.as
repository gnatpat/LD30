package net.natpat.utils 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import net.natpat.Assets;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Sfx 
	{
		
		private var sound:Sound;
		
		private var soundChannel:SoundChannel;
		
		private var soundTransform:SoundTransform;
		
		private var position:Number;
		
		private var loop:Boolean;
		
		/**
		 * Create a new sound object, 
		 * @param	soundFile
		 */
		public function Sfx(soundFile:Class, loop:Boolean = false) 
		{
			sound = new soundFile;
			soundChannel = new SoundChannel();
			position = 0;
			soundTransform = new SoundTransform();
		}
		
		public function play(boolloop:Boolean = false):void
		{
			loop = boolloop;
			soundChannel = sound.play(position, 0);
			soundChannel.soundTransform = soundTransform;
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		}
		
		public function pause():void
		{
			position = soundChannel.position;
			soundChannel.stop();
		}
		
		public function stop():void
		{
			soundChannel.stop();
			position = 0;
		}
		
		public function set volume(volume:Number):void
		{
			soundTransform.volume = volume;
		}
		
		private function soundComplete(e:Event):void
		{
			stop();
			if (loop)
			{
				play(true);
			}
		}
		
	}

}