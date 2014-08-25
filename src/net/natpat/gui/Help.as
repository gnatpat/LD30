package net.natpat.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.natpat.Assets;
	import net.natpat.GC;
	import net.natpat.GV;
	import net.natpat.Input;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Help implements IGuiElement 
	{
		
		public var bd:BitmapData;
		
		public function Help() 
		{
			bd = Bitmap(new Assets.HELP).bitmapData;
		}
		
		/* INTERFACE net.natpat.gui.IGuiElement */
		
		public function render():void 
		{
			GV.screen.copyPixels(bd, bd.rect, new Point(0, -40));;
		}
		
		public function update():void 
		{
			if (Input.mouseReleased)
			{
				Input.mouseReleased = false;
				GuiManager.remove(this);
			}
		}
		
		public function add():void 
		{
			GV.onGUI = this;
		}
		
		public function remove():void 
		{
			GV.onGUI = null;
		}
		
	}

}