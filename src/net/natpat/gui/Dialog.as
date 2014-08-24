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
	public class Dialog implements IGuiElement 
	{
		
		public var background:BitmapData
		public var okay:Button;
		public var cancel:Button;
		public var text:Text;
		
		public var x:int;
		public var y:int;
		
		public var width:int;
		public var height:int;
		
		public var ok:Function;
		public var no:Function;
		
		public function Dialog(ok:Function, no:Function, text:String, size:int = 18) 
		{
			Input.mouseDown = false;
			background = Bitmap(new Assets.DIALOG).bitmapData;
			width = background.width;
			height = background.height;
			x = (GC.SCREEN_WIDTH - width) / 2;
			y = (GC.SCREEN_HEIGHT - height) / 2;
			this.text = new Text(0, y + 122, text, size, false, 0xffffff, true);
			this.text.x = (GC.SCREEN_WIDTH - this.text.width) / 2
			okay = new Button(new BitmapData(1, 1, true, 0), x + 190, y + 205, 90, 50, okclick);
			cancel = new Button(new BitmapData(1, 1, true, 0), x + 330, y + 210, 90, 50, noclick)
			this.ok = ok;
			this.no = no;
		}
		
		/* INTERFACE net.natpat.gui.IGuiElement */
		
		public function render():void 
		{
			GV.screen.copyPixels(background, background.rect, new Point(x, y));
			text.render();
		}
		
		public function update():void 
		{
			GV.onGUI = this;
			okay.update();
			cancel.update();
			text.update();
		}
		
		public function add():void 
		{
			
		}
		
		public function remove():void 
		{
			GV.onGUI = null;
		}
		
		public function okclick():void
		{
			ok();
			GuiManager.remove(this);
		}
		
		public function noclick():void
		{
			no();
			GuiManager.remove(this);
		}
	}

}