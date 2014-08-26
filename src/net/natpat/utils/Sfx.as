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
		
		public var callback:Function;
		
		public static var sfxs:Object;
		
		
		/**
		 * Create a new sound object, 
		 * @param	soundFile
		 */
		public function Sfx(soundFile:Class, loop:Boolean = false, callback:Function = null, volume:Number = 0.7) 
		{
			sound = new soundFile;
			soundChannel = new SoundChannel();
			position = 0;
			soundTransform = new SoundTransform();
			soundTransform.volume = volume;
			this.callback = callback;
		}
		
		public static function addSfxs():void
		{
			sfxs = new Object();
			sfxs["alert"] = new Sfx(Assets.SFX_ALERT); 
			sfxs["explodeParrot"] = new Sfx(Assets.SFX_EXPLODE_PARROT);
			sfxs["discover"] = new Sfx(Assets.SFX_DISCOVER);
			sfxs["error"] = new Sfx(Assets.SFX_ERROR);
			sfxs["exploded"] = new Sfx(Assets.SFX_EXPLODE);
			sfxs["moneyIn"] = new Sfx(Assets.SFX_MONEY_IN);
			sfxs["moneyOut"] = new Sfx(Assets.SFX_MONEY_OUT);
			sfxs["sail"] = new Sfx(Assets.SFX_SAIL);
			sfxs["seagull"] = new Sfx(Assets.SFX_SEAGULL);
			sfxs["sink"] = new Sfx(Assets.SFX_SINK, false, null, 1);
			sfxs["creak"] = new Sfx(Assets.SFX_CREAK);
			sfxs["wind"] = new Sfx(Assets.SFX_WIND, false, null, 0.4);
			sfxs["yarr1"] = new Sfx(Assets.SFX_YARR1);
			sfxs["yarr2"] = new Sfx(Assets.SFX_YARR2);
		}
		
		public function play(boolloop:Boolean = false):void
		{
			loop = boolloop;
			soundChannel = sound.play(position, 0);
			//soundChannel.soundTransform = soundTransform;
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
			if(callback != null) callback();
			stop();
			if (loop)
			{
				play(true);
			}
		}
		
	}

}