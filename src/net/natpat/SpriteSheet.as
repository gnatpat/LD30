package net.natpat 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class SpriteSheet 
	{
		private var width:int;
		private var height:int;
		private var offset:Point;
		
		private var anims:Object;
		
		private var anim:Animation;
		private var frame:int;
		private var fd:FrameData;
		private var time:Number;
		
		private var defaultAnim:Animation;
		
		private var point:Point;
		private var rect:Rectangle;
		
		private var buffer:BitmapData;
		
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
		
		public function SpriteSheet(bitmap:Bitmap, width:int, height:int)
		{
			this.width = width;
			this.height = height; 
			offset = new Point;
			
			anims = new Object();
			point = new Point();
			
			rect = new Rectangle();
			rect.width = width;
			rect.height = height;
			
			frame = 0;
			time = 0;
			
			buffer = GV.screen;
			
			this.bitmap = bitmap;
			bitmapData = bitmap.bitmapData;
		}
		
		/**
		 * Create a new animation.
		 * @param	name	Name of new animation
		 * @param	frames	A 2D array - each frame is a array of length 3 or containing x, y, frame length
		 * 					and an optional callback when the frame ENDS. The callback should return a string, which
		 * 					is the next animation to play. If null, the animation will keep playing.
		 */
		public function addAnim(name:String, frames:Array, repeatable:Boolean = true ):void
		{
			var frameVec:Vector.<FrameData> = new Vector.<FrameData>(frames.length, true);
			
			for (var i:int = 0; i < frames.length; i++)
			{
				var fd:FrameData = new FrameData(frames[i][0], frames[i][1], frames[i][2]);
				if (frames[i].length == 4)
				{
					fd.setCallback(frames[i][3]);
				}
				
				frameVec[i] = fd;
			}
			
			var newAnim:Animation = new Animation(name, frameVec, repeatable); 
			anims[name] = newAnim;
		}
		
		public function update():void
		{
			if (anim == null) return;
			
			fd = anim.frames[frame];
			
			time += GV.elapsed;
			if (time > fd.time)
			{
				time -= fd.time
				frame++;
				
				if (frame >= anim.length)
				{
					if (anim.repeatable) frame = 0;
					else 				 changeToDefault();
				}
				
				//This should be at the bottom, as fd does not change and changeAnim will muck things up.
				if (fd.callback != null)
				{
					var newAnim:String = fd.callback();
					if (newAnim != null) changeAnim(newAnim);
				}
			}
		}
		
		public function render(x:int, y:int):void
		{
			if (anim == null) return;
			
			fd = anim.frames[frame];
			
			point.x = x;
			point.y = y;
			
			rect.x = fd.x * width  + offset.x;
			rect.y = fd.y * height + offset.y;
			
			buffer.copyPixels(bitmapData, rect, point, null, null, true);
		}
		
		public function changeAnim(name:String):void
		{
			var newAnim:Animation = anims[name];
			if (newAnim == null) throw new Error("Animation with name " + name + " does not exist!");
			changeAnimByObject(newAnim);
		}
		
		public function changeToDefault():void
		{
			changeAnimByObject(defaultAnim);
		}
		
		private function changeAnimByObject(newAnim:Animation):void
		{
			frame = 0;
			time = 0;
			anim = newAnim;
		}
		
		public function setOffset(x:int, y:int):void
		{
			offset.x = x;
			offset.y = y;
		}
		
		public function setDefault(name:String):void
		{
			defaultAnim = anims[name];
		}
		
	}

}

	
internal class FrameData
{
	public var x:int;
	public var y:int;
	public var time:Number;
	public var callback:Function;
	
	public function FrameData(x:int, y:int, time:Number)
	{
		this.x = x;
		this.y = y;
		this.time = time;
		callback = null;
	}
	
	public function setCallback(callback:Function):void
	{
		this.callback = callback;
	}
}

internal class Animation
{
	public var frames:Vector.<FrameData>;
	public var repeatable:Boolean;
	public var name:String;
	public var length:int;
	
	public function Animation(name:String, frames:Vector.<FrameData>, repeatable:Boolean)
	{
		this.name = name;
		this.frames = frames;
		this.repeatable = repeatable;
		length = frames.length;
	}
}