package net.natpat.particles 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import net.natpat.GV;
	import net.natpat.GC;

	/**
	 * Particle emitter used for emitting and rendering particle sprites.
	 * Good rendering performance with large amounts of particles.
	 */
	public class Emitter
	{
		public var x:int = 0;
		public var y:int = 0;
		
		/**
		 * Constructor. Sets the source image to use for newly added particle types.
		 * @param	source			Source image.
		 * @param	frameWidth		Frame width.
		 * @param	frameHeight		Frame height.
		 */
		public function Emitter(source:*, frameWidth:uint = 0, frameHeight:uint = 0) 
		{
			setSource(GV.loadBitmapDataFromSource(source), frameWidth, frameHeight);
			frames = [0];
		}
		
		/**
		 * Changes the source image to use for newly added particle types.
		 * @param	source			Source image.
		 * @param	frameWidth		Frame width.
		 * @param	frameHeight		Frame height.
		 */
		public function setSource(source:BitmapData, frameWidth:uint = 0, frameHeight:uint = 0):void
		{
			this.source = source;
			width = source.width;
			height = source.height;
			frameWidth = frameWidth ? frameWidth : width;
			frameHeight = frameHeight ? frameHeight : height;
			frameCount = uint(width / frameWidth) * uint(height / frameHeight);
			frame = new Rectangle(0, 0, frameWidth, frameHeight);
		}
		
		public function startEmitting():void
		{
			timer = 0;
			timeToGetTo = 0;
			emitOnTimer = true;
		}
		
		public function stopEmitting():void
		{
			emitOnTimer = false;
		}
		
		public function update():void 
		{
			if (emitOnTimer)
			{
				timer += GV.elapsed;
				while (timer > timeToGetTo)
				{
					emit();
					timer -= timeToGetTo;
					timeToGetTo = time + timeRange * Math.random();
				}
			}
			
			
			// quit if there are no particles
			if (!particle) return;
			
			// particle info
			var e:Number = GV.elapsed,
				p:Particle = particle,
				n:Particle;
			
			// loop through the particles
			while (p)
			{
				// update time scale
				p.time += e;
				
				// remove on time-out
				if (p.time >= p.duration)
				{
					if (p.next) p.next.prev = p.prev;
					if (p.prev) p.prev.next = p.next;
					else particle = p.next;
					n = p.next;
					p.next = cache;
					p.prev = null;
					cache = p;
					p = n;
					_particleCount --;
					continue;
				}
				
				// get next particle
				p = p.next;
			}
		}
		
		/** @private Renders the particles. */
		public function render():void 
		{
			// quit if there are no particles
			if (!particle) return;
			
			// get rendering position
			point.x = x;
			point.y = y;
			
			// particle info
			var t:Number, td:Number,
				p:Particle = particle,
				rect:Rectangle;
			
			// loop through the particles
			while (p)
			{
				// get time scale
				t = p.time / p.duration;
				
				// get position
				td = (ease == null) ? t : ease(t);
				pp.x = p.x + p.xVel * td;
				pp.y = p.y + p.yVel * td + p.gravity * td * td;
				
				// get frame
				frame.x = frame.width * frames[uint(td * frameCount)];
				frame.y = uint(frame.x / width) * frame.height;
				frame.x %= width;
				
				// draw particle
				if (buffer)
				{
					// get alpha
					var alphaT:Number = (alphaEase == null) ? t : alphaEase(t);
					tint.alphaMultiplier = alpha + alphaRange * alphaT;
					
					// get color
					td = (colorEase == null) ? t : colorEase(t);
					tint.redMultiplier = red + redRange * td;
					tint.greenMultiplier = green + greenRange * td;
					tint.blueMultiplier  = blue + blueRange * td;
					
					//apply changes
					buffer.fillRect(bufferRect, 0);
					buffer.copyPixels(source, frame, GC.ZERO);
					buffer.colorTransform(bufferRect, tint);
					
					var sizeT:Number = (sizeEase == null) ? t : sizeEase(t);
					var scale:Number = size + sizeRange * sizeT;
					if (scale != 1)
					{
						GV.screen.copyPixels(scaleBitmapData(buffer, scale), sizeBufferRect, pp, null, null, true);
					}
					else
					{
						// draw particle
						GV.screen.copyPixels(buffer, bufferRect, pp, null, null, true);
					}
				}
				else GV.screen.copyPixels(source, frame, pp, null, null, true);
				
				// get next particle
				p = p.next;
			}
		}
		
		/**
		 * Defines the motion range for a particle type.
		 * @param	name			The particle type.
		 * @param	angle			Launch Direction.
		 * @param	distance		Distance to travel.
		 * @param	duration		Particle duration.
		 * @param	angleRange		Random amount to add to the particle's direction.
		 * @param	distanceRange	Random amount to add to the particle's distance.
		 * @param	durationRange	Random amount to add to the particle's duration.
		 * @param	ease			Optional easer function.
		 * @return	This ParticleType object.
		 */
		public function setMotion(angle:Number, distance:Number, duration:Number, angleRange:Number = 0, distanceRange:Number = 0, durationRange:Number = 0, ease:Function = null):Emitter
		{
			this.angle = angle * GV.RAD;
			this.distance = distance;
			this.duration = duration;
			this.angleRange = angleRange * GV.RAD;
			this.distanceRange = distanceRange;
			this.durationRange = durationRange;
			this.ease = ease;
			return this;
		}
		
		/**
		 * Sets the gravity range for a particle type.
		 * @param	name			The particle type.
		 * @param	gravity			Gravity amount to affect to the particle y velocity.
		 * @param	gravityRange	Random amount to add to the particle's gravity.
		 * @return	This ParticleType object.
		 */
		public function setGravity(gravity:Number = 0, gravityRange:Number = 0):Emitter
		{
			this.gravity = gravity;
			this.gravityRange = gravityRange;
			return this;
		}
		
		/**
		 * Sets the alpha range of the particle type.
		 * @param	name		The particle type.
		 * @param	start		The starting alpha.
		 * @param	finish		The finish alpha.
		 * @param	ease		Optional easer function.
		 * @return	This ParticleType object.
		 */
		public function setAlpha(start:Number = 1, finish:Number = 0, ease:Function = null):Emitter
		{
			start = start < 0 ? 0 : (start > 1 ? 1 : start);
			finish = finish < 0 ? 0 : (finish > 1 ? 1 : finish);
			alpha = start;
			alphaRange = finish - start;
			alphaEase = ease;
			createBuffer();
			return this;
		}
		
		/**
		 * Sets the color range of the particle type.
		 * @param	name		The particle type.
		 * @param	start		The starting color.
		 * @param	finish		The finish color.
		 * @param	ease		Optional easer function.
		 * @return	This ParticleType object.
		 */
		public function setColor(start:uint = 0xFFFFFF, finish:uint = 0, ease:Function = null):Emitter
		{
			start &= 0xFFFFFF;
			finish &= 0xFFFFFF;
			red = (start >> 16 & 0xFF) / 255;
			green = (start >> 8 & 0xFF) / 255;
			blue = (start & 0xFF) / 255;
			redRange = (finish >> 16 & 0xFF) / 255 - red;
			greenRange = (finish >> 8 & 0xFF) / 255 - green;
			blueRange = (finish & 0xFF) / 255 - blue;
			colorEase = ease;
			createBuffer();
			return this;
		}
		
		public function setSizeChange(start:Number = 1, finish:Number = 0, ease:Function = null):Emitter
		{
			start = start < 0 ? 0 : start;
			finish = finish < 0 ? 0 : finish;
			size = start;
			sizeRange = finish - start;
			sizeEase = ease;
			createBuffer();
			return this;
		}
		
		
		public function setEmitTime(time:Number, timeRange:Number):Emitter
		{
			this.time = time;
			this.timeRange = timeRange;
			return this;
		}
		
		/**
		 * Emits a particle.
		 * @param	name		Particle type to emit.
		 * @param	x			X point to emit from.
		 * @param	y			Y point to emit from.
		 * @return
		 */
		public function emit(x:Number = 0, y:Number = 0):Particle
		{
			var p:Particle;
			
			if (cache)
			{
				p = cache;
				cache = p.next;
			}
			else p = new Particle;
			p.next = particle;
			p.prev = null;
			if (p.next) p.next.prev = p;
			
			p.time = 0;
			p.duration = duration + durationRange * Math.random();
			var a:Number = angle + angleRange * Math.random(),
				d:Number = distance + distanceRange * Math.random();
			p.xVel = Math.cos(a) * d;
			p.yVel = Math.sin(a) * d;
			p.x = this.x + x;
			p.y = this.y + y;
			p.gravity = gravity + gravityRange * Math.random();
			_particleCount ++;
			return (particle = p);
		}
		
		
		/** @private Creates the buffer if it doesn't exist. */
		private function createBuffer():void
		{
			if (buffer) return;
			buffer = new BitmapData(frame.width, frame.height, true, 0);
			bufferRect = buffer.rect;
			sizeBuffer = new BitmapData(frame.width, frame.height, true, 0);
			sizeBufferRect = sizeBuffer.rect;
		}
		
		private function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData 
		{
            var width:int = bitmapData.width;
            var height:int = bitmapData.height;
            sizeBuffer.fillRect(sizeBufferRect, 0);
            var matrix:Matrix = new Matrix();
			matrix.translate( -width / 2, -height / 2);
            matrix.scale(scale, scale);
			matrix.translate(width / 2, height / 2);
            sizeBuffer.draw(bitmapData, matrix, null, null, null, true);
            return sizeBuffer;
        }
		
		/**
		 * Amount of currently existing particles.
		 */
		public function get particleCount():uint { return _particleCount; }
		
		// Particle information.
		/** @private */ private var particle:Particle;
		/** @private */ private var cache:Particle;
		/** @private */ private var _particleCount:uint;
		
		// Source information.
		/** @private */ private var source:BitmapData;
		/** @private */ private var width:uint;
		/** @private */ private var height:uint;
		/** @private */ private var frameWidth:uint;
		/** @private */ private var frameHeight:uint;
		/** @private */ private var frameCount:uint;
		/** @private */ private var frame:Rectangle;
		/** @private */ private var frames:Array;
		
		// Drawing information.
		/** @private */ private var pp:Point = new Point;
		/** @private */ private var point:Point = new Point;
		/** @private */ private var tint:ColorTransform = new ColorTransform;
		
		// Motion information.
		/** @private */ internal var angle:Number;
		/** @private */ internal var angleRange:Number;
		/** @private */ internal var distance:Number;
		/** @private */ internal var distanceRange:Number;
		/** @private */ internal var duration:Number;
		/** @private */ internal var durationRange:Number;
		/** @private */ internal var ease:Function;
		
		// Gravity information.
		/** @private */ internal var gravity:Number = 0;
		/** @private */ internal var gravityRange:Number = 0;
		
		// Alpha information.
		/** @private */ internal var alpha:Number = 1;
		/** @private */ internal var alphaRange:Number = 0;
		/** @private */ internal var alphaEase:Function;
		
		// Color information.
		/** @private */ internal var red:Number = 1;
		/** @private */ internal var redRange:Number = 0;
		/** @private */ internal var green:Number = 1;
		/** @private */ internal var greenRange:Number = 0;
		/** @private */ internal var blue:Number = 1;
		/** @private */ internal var blueRange:Number = 0;
		/** @private */ internal var colorEase:Function;
		
		// Size information.
		/** @private */ internal var size:Number = 1;
		/** @private */ internal var sizeRange:Number = 0;
		/** @private */ internal var sizeEase:Function;
		
		//Time information.
		/** @private */ internal var time:Number = 0;
		/** @private */ internal var timeRange:Number = 0;
		/** @private */ internal var timer:Number;
		/** @private */ internal var timeToGetTo:Number;
		/** @private */ internal var emitOnTimer:Boolean = false;
		
		// Buffer information.
		/** @private */ internal var sizeBuffer:BitmapData;
		/** @private */ internal var sizeBufferRect:Rectangle;
		// Buffer information.
		/** @private */ internal var buffer:BitmapData;
		/** @private */ internal var bufferRect:Rectangle;
	}
}
