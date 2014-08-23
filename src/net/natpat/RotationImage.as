package net.natpat 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class RotationImage 
	{
		
		private var bmp:Bitmap;
		private var bd:BitmapData;
		
		private var rotated:BitmapData;
		private var noOfFrames:int;
		
		public var width:int;
		public var height:int;
		
		public var angle:Number = 0;
		
		private var frame:int;
		private var rect:Rectangle;
		private var point:Point;
		
		public function RotationImage(source:Class, frames:int = 36, smooth:Boolean = false) 
		{
			bmp = (new source);
			bd = bmp.bitmapData;
			
			noOfFrames = frames;
			
			var oldW:int = bd.width;
			var oldH:int = bd.height;
			
			width = Math.ceil(oldW * 1.5);
			height = Math.ceil(oldH * 1.5);
			
			rotated = new BitmapData(frames * width, 400, true, 0);
			
			var m:Matrix = new Matrix();
			m.translate(-oldW/2, -oldH/2);
			for (var i:int = 0; i < frames; i++)
			{
				m.translate(int(width / 2) + width * i, int(height / 2));
				rotated.draw(bd, m, null, null, null, smooth);
				m.translate( int(-(width / 2)) - (width * i), int(-(height / 2)));
				
				m.rotate(2 * Math.PI / frames);
			}
			
			rect = new Rectangle(0, 0, width, height);
			point = new Point();
		}
		
		public function render(x:int, y:int):void
		{
			angle %= 360;
			if (angle < 0) angle += 360;
			frame = uint(noOfFrames * (angle / 360));
			
			rect.x = frame * width;
			point.x = x;
			point.y = y;
			
			GV.screen.copyPixels(rotated, rect, point, null, null, true);
		}
		
	}

}