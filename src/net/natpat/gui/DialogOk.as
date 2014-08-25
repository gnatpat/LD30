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
	public class DialogOk implements IGuiElement 
	{
		
		public var background:BitmapData
		public var okay:Button;
		public var text:Text;
		
		public var x:int;
		public var y:int;
		
		public var width:int;
		public var height:int;
		
		public var ok:Function;
		
		public function DialogOk(ok:Function = null, text:String = "", size:int = 18) 
		{
			Input.mouseReleased = false;
			background = Bitmap(new Assets.DIALOGOK).bitmapData;
			width = background.width;
			height = background.height;
			x = (GC.SCREEN_WIDTH - width) / 2;
			y = (GC.SCREEN_HEIGHT - height) / 2;
			this.text = new Text(0, y + 122, text, size, false, 0, true);
			this.text.x = (GC.SCREEN_WIDTH - this.text.width) / 2
			okay = new Button(new BitmapData(1, 1, true, 0), x + 260, y + 205, 90, 50, okclick);
			this.ok = ok;
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
			if(ok != null) ok();
			GuiManager.remove(this);
		}
	}

}