package net.natpat.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.natpat.Assets;
	import net.natpat.GC;
	import net.natpat.GV;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GoldMinus implements IGuiElement 
	{
		
		public var x:int;
		public var y:int;
		
		public var text:Text;
		
		public var width:int;
		
		public var buffer:BitmapData;
		
		public var time:Number
		
		public function GoldMinus(x:int, y:int, amount:int ) 
		{
			this.x = x;
			this.y = y;
			buffer = new BitmapData(100, 40, true, 0);
			text = new Text(30, 0, "-" + amount, 16, false, 0xcc7777);
			text.renderOnBuffer(buffer);
			var m:Matrix = new Matrix();
			m.scale(3 / 20, 3 / 20);
			buffer.draw(Bitmap(new Assets.GOLD).bitmapData, m);
			width = 40 + text.width;
			time = 0;
			buffer.applyFilter(buffer, buffer.rect,  GC.ZERO, new DropShadowFilter(4, 45, 0, 0.44, 0, 0, 4));
		}
		
		/* INTERFACE net.natpat.gui.IGuiElement */
		
		public function render():void 
		{
			GV.screen.copyPixels(buffer, buffer.rect, new Point(GV.getScreenX(x) - width / 2, GV.getScreenY(y - 5) - buffer.height), null, null, true);
		}
		
		public function update():void 
		{
			y -= 10 * GV.elapsed;
			buffer.colorTransform(buffer.rect, new ColorTransform(1, 1, 1, 1, 0, 0, 0, -GV.elapsed * 255));
			time += GV.elapsed;
			if (time > 1)
			{
				GuiManager.remove(this);
			}
		}
		
		public function add():void 
		{
			
		}
		
		public function remove():void 
		{
			
		}
		
	}

}