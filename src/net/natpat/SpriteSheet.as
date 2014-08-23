package net.natpat 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class SpriteSheet 
	{
		protected var width:int;
		protected var height:int;
		protected var offset:Point;
		
		protected var anims:Object;
		
		protected var anim:Animation;
		protected var frame:int;
		protected var fd:FrameData;
		protected var time:Number;
		
		protected var defaultAnim:Animation;
		
		protected var point:Point;
		protected var rect:Rectangle;
		
		protected var buffer:BitmapData;
		
		protected var bitmapData:BitmapData;
		
		public function SpriteSheet(source:*, width:int, height:int)
		{
			this.width = width;
			this.height = height; 
			offset = new Point(0, 0);
			setOffset(0, 0);
			
			anims = new Object();
			point = new Point();
			
			rect = new Rectangle();
			rect.width = width;
			rect.height = height;
			
			frame = 0;
			time = 0;
			
			buffer = GV.screen;
			
			bitmapData = GV.loadBitmapDataFromSource(source);
			
			addAnim("default", [[0, 0, 5]], true);
			setDefault("default");
			changeAnim("default");
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
			
			if (anim.frames.length == 0) return;
			
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
		
		
		public function render(x:int, y:int, zoom:Boolean = true, zoomRatio:Number = GC.SPRITE_ZOOM_RATIO):void
		{
			if (anim == null) return;
			
			if (anim.frames.length == 0) return;
			
			var m:Matrix = new Matrix();
			
			var renderbd:BitmapData;
			var r:Rectangle = new Rectangle();
			
			fd = anim.frames[frame];
			point.x = x;
			point.y = y;
			if (anim is GlowAnim)
			{
			
				
				point = point.add(GlowAnim(anim).offset);
				
				r.x = fd.x * GlowAnim(anim).newW;
				r.y = fd.y * GlowAnim(anim).newH;
				
				r.width = GlowAnim(anim).newW;
				r.height = GlowAnim(anim).newH;
			}
			else
			{
				r.x = fd.x * width  - width + offset.x;
				r.y = fd.y * height - height + offset.y;
				r.width = width;
				r.height = height;
			}
			
			/*if (zoom)
			{
				var scale:Number = 1 / GV.zoom;
				m.translate(-r.x - r.width / 2, -r.y - r.height / 2);
				m.scale(scale, scale);
				m.translate(r.x + r.width / 2, r.y + r.height / 2);
				m.translate(point.x, point.y);
				m.translate(-GV.camera.x, -GV.camera.y);
				r.x += point.x - GV.camera.x;
				r.y += point.y - GV.camera.y;
				buffer.draw(bitmapData, m, null, null, rect);
			}
			else*/
			{
				point.x -= GV.camera.x - (GC.SCREEN_WIDTH / 2 * GV.zoom);
				point.y -= GV.camera.y - (GC.SCREEN_HEIGHT / 2 * GV.zoom);
				point.x *= 1 /  GV.zoom;
				point.y *= 1 / GV.zoom;
				buffer.copyPixels(bitmapData, r, point, null, null, true);
			}
		}
		
		public function setWidth(width:int):void
		{
			this.width = width;
			rect.width = width;
		}
		
		public function setHeight(height:int):void
		{
			this.height = height;
			rect.height = height;
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
		
		protected function changeAnimByObject(newAnim:Animation):void
		{
			frame = 0;
			time = 0;
			anim = newAnim;
		}
		
		public function setOffset(x:int, y:int):void
		{
			if (x <= 0) x += width;
			if (y <= 0) y += height;
			offset.x = x;
			offset.y = y;
		}
		
		public function setDefault(name:String):void
		{
			defaultAnim = anims[name];
		}
		
		
		public function filterAnim(name:String, filter:BitmapFilter, extraSpaceMult:Number = 1.5):void
		{
			var oldAnim:Animation = anims[name];
			var strip:BitmapData = new BitmapData(width * extraSpaceMult * oldAnim.length, height * extraSpaceMult, true, 0);
			var newW:int = width * extraSpaceMult;
			var newH:int = height * extraSpaceMult;
			var glowOffset:Point = new Point((width - newW)/2, (height - newH)/2);
			
			var r:Rectangle = new Rectangle(0, 0, width, height);
			var p:Point = glowOffset.clone();
			p.x *= -1;
			p.y *= -1;
			
			
			for (var i:int = 0; i < oldAnim.length; i++)
			{
				trace(r.width);
				trace(r.height);
				r.x = oldAnim.frames[i].x * width - width + offset.x;
				r.y = oldAnim.frames[i].y * height - height + offset.y;
				strip.copyPixels(bitmapData, r, p);
				p.x += newW;
				
				oldAnim.frames[i].x = i;
				
				oldAnim.frames[i].y = 0;
			}
			
			strip.applyFilter(strip, strip.rect, GC.ZERO, filter);
			
			var glow:GlowAnim = new GlowAnim(strip, glowOffset, newW, newH);
			glow.frames = oldAnim.frames;
			glow.length = oldAnim.length;
			glow.name = oldAnim.name;
			glow.repeatable = oldAnim.repeatable;
			
			anims[name] = glow;
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

import flash.display.BitmapData;
import flash.geom.Point;

internal class GlowAnim extends Animation
{
	
	public var bd:BitmapData;
	public var offset:Point;
	public var newW:int;
	public var newH:int;
	
	public function GlowAnim(bd:BitmapData, offset:Point, newW:int, newH:int)
	{
		super(null, new Vector.<FrameData>(), true);
		this.bd = bd;
		this.offset = offset;
		this.newW = newW;
		this.newH = newH;
	}
}