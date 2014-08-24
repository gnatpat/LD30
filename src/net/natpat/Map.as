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
	public class Map 
	{
		
		public var zooms:Vector.<Vector.<BitmapData>>
		public var quads:Vector.<BitmapData>;
		
		public function Map() 
		{
			quads = new Vector.<BitmapData>(4);
			quads[0] = Bitmap(new Assets.MAP00).bitmapData;
			quads[1] = Bitmap(new Assets.MAP01).bitmapData;
			quads[2] = Bitmap(new Assets.MAP10).bitmapData;
			quads[3] = Bitmap(new Assets.MAP11).bitmapData;
		}
		
		public function render(buffer:BitmapData):void
		{
			var r:Rectangle = new Rectangle();
			var p:Point = new Point();
			var swidth:int = GC.SCREEN_WIDTH * GV.zoom;
			//NSFW
			var sheight:int = GC.SCREEN_HEIGHT * GV.zoom;
			
			var x:int;
			var y:int;
			
			var cx:int = GV.camera.x - swidth / 2;
			var cy:int = GV.camera.y - sheight / 2;
			for (var i:int = 0; i < 4; i++)
			{
				x = i % 2;
				y = int(i / 2);
				
				if (GV.intersects(cx, cy, swidth, sheight,
								  x * quads[i].width, y * quads[i].height, quads[i].width,  quads[i].height))
				{
					if (x == 0)
					{
						r.x = cx;
						r.width = Math.min(swidth, quads[i].width - r.x);
						p.x = 0;
					}
					else
					{
						r.x = Math.max(0, cx - quads[i].width);
						r.width = Math.min(swidth, swidth - (quads[i].width - cx) + swidth / 2)
						p.x = Math.max(0, quads[0].width - cx);
					}
					
					if (y == 0)
					{
						r.y = cy;
						r.height = Math.min(sheight, quads[i].height - r.y);
						p.y = 0;
					}
					else
					{
						r.y = Math.max(0, cy - quads[i].height);
						r.height  = Math.min(sheight, sheight - (quads[i].height - cy) + sheight / 2)
						p.y = Math.max(0, quads[0].height - cy);
					}
					buffer.copyPixels(quads[i], r, p);
				}
			}
		}
		
		
	}

}