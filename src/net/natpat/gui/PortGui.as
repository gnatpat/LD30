package net.natpat.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.natpat.Assets;
	import net.natpat.GC;
	import net.natpat.GV;
	import net.natpat.Input;
	import net.natpat.Port;
	import net.natpat.RedShip;
	import net.natpat.utils.Key;
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
		
		public var buyGoldButton:Button;
		public var buyRedButton:Button;
		public var goldCost:Text;
		public var redCost:Text;
		
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
			back = Bitmap(port.home ? new Assets.POPUPHOME : new Assets.POPUP).bitmapData;
			this.port = port;
			if (port.home)
			{
				buyGoldButton = new Button(new BitmapData(1, 1, true, 0), x + 270, y + 90, 80, 50, buyGold);
				buyRedButton = new Button(new BitmapData(1, 1, true, 0), x + 270, y + 200, 80, 50, buyRed);
				goldCost = new Text(x + 290, y + 90, "" + GV.goldShipCost, 32, false, 0);
				redCost = new Text(x + 290, y + 200, "" + GV.redShipCost, 32, false, 0);
			}
		}
		
		/* INTERFACE net.natpat.gui.IGuiElement */
		
		public function render():void 
		{
			GV.screen.copyPixels(back, back.rect, new Point(x, y));
			slots[0].render();
			slots[1].render();
			slots[2].render();
			if (port.home)
			{
				goldCost.render();
				redCost.render();
			}
		}
		
		public function update():void 
		{
			
			if (GV.pointInRect(Input.mouseX, Input.mouseY, x, y, width, height))
			{
				GV.onGUI = this;
			} else if (GV.onGUI == this) GV.onGUI = null;
			slots[0].update()
			slots[1].update()
			slots[2].update();
			if (port.home)
			{
				buyGoldButton.update();
				buyRedButton.update();
			}
		}
		
		public function setPos(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
			slots[0].setPos(x, y);
			slots[1].setPos(x, y);
			slots[2].setPos(x, y);
			if (port.home)
			{
				buyGoldButton.x = x + 270;
				buyGoldButton.y = y + 90;;
				buyRedButton.x = x + 270;
				buyRedButton.y = y + 200;
				goldCost.x = x + 290
				goldCost.y = y + 90
				redCost.x = x + 290;
				redCost.y = y + 200;
			}
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
		
		public function buyGold():void
		{
			port.startRoute(-1);
			close();
			GV.goldShip = true;
		}
		
		public function buyRed():void
		{
			if (GV.redShipNo < GC.MAX_RED_SHIPS)
			{
				port.startRoute( -1);
				GV.redShip = new RedShip(port, null, 50);
			}
			else
			{
				GuiManager.add(new DialogOk(null, "You can't have more than\n" + GC.MAX_RED_SHIPS + " privateers!", 18));
			}
			this.close();
		}
	}

}