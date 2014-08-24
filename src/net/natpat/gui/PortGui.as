package net.natpat.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.natpat.Assets;
	import net.natpat.GV;
	import net.natpat.Input;
	import net.natpat.Port;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class PortGui implements IGuiElement 
	{
		
		public var x:int;
		public var y:int;
		
		public var width:int;
		public var height:int;
		
		public var back:BitmapData;
		
		public var slots:Vector.<PortSlotGui>;
		
		public var port:Port;
		
		public function PortGui(port:Port, x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			width = 300;
			height = 333;
			slots = new Vector.<PortSlotGui>(3);
			slots[0] = new PortSlotGui(this, x, y, 300, 333, port, 0);
			slots[1] = new PortSlotGui(this, x, y, 300, 333, port, 1);
			slots[2] = new PortSlotGui(this, x, y, 300, 333, port, 2);
			back = Bitmap(new Assets.POPUP).bitmapData;
		}
		
		/* INTERFACE net.natpat.gui.IGuiElement */
		
		public function render():void 
		{
			GV.screen.copyPixels(back, back.rect, new Point(x, y));
			slots[0].render();
			slots[1].render();
			slots[2].render();
		}
		
		public function update():void 
		{
			
			if (GV.pointInRect(Input.mouseX, Input.mouseY, x, y, width, height))
			{
				GV.onGUI = this;
			} else if (GV.onGUI == this) GV.onGUI = null;
			slots[0].update()
			slots[1].update()
			slots[2].update()
		}
		
		public function add():void 
		{
			
		}
		
		public function remove():void 
		{
			GV.onGUI = null;
		}
		
		public function close():void
		{
			GuiManager.remove(this);
			GV.onGUI = null;
		}
		
	}

}