package net.natpat.gui 
{
	import flash.accessibility.ISearchableText;
	import flash.display.BitmapData;
	import net.natpat.GV;
	import net.natpat.Port;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class PortSlotGui implements IGuiElement 
	{
		
		public var x:int = 0;
		public var y:int = 0;
		
		public var width:int;
		public var height:int
		
		public var buyButton:Button;
		public var back:Button;
		public var dest:Text;
		public var gold:Text;
		
		public var rerouteButton:Button;
		
		public var hasRoute:Boolean;
		
		public var port:Port;
		
		public var index:int;
		
		public var parent:PortGui;
		
		public function PortSlotGui(parent:PortGui, x:int, y:int, width:int, height:int, port:Port, index:int) 
		{
			this.parent = parent;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			hasRoute = (port.ships[index] != null)
			
			buyButton = new Button(new BitmapData(width, height, true, 0xffcccccc), x, y, width, height, buy, 0, -1, -1, -1, -1, "Buy a ship\n" + GV.shipCost + " gold", 18); 
			
			if (hasRoute)
			{
				back = new Button(new BitmapData(width, height, true, 0xffcccccc), x, y, width, height, nuthin, 0, -1, -1, -1, -1); 
				dest = new Text(x, y, port.ships[index].route.to.name, 24, false, 0);
				dest.x = x + (width - dest.width) / 2;
				gold = new Text(x, y + 30, port.ships[index].route.gold + " gold", 18, false, 0);
				gold.x = x + (width - gold.width) / 2;
			}
			
			rerouteButton = new Button(new BitmapData(width - 20, height - 20, true, 0xffff0000), 10, height - 10, width - 20, 20, reroute, 0, -1, -1, -1, -1, "Reroute", 16);
			
			this.port = port;
			this.index = index;
		}
		
		
		public function render():void 
		{
			if (!hasRoute)
			{
				buyButton.render();
			}
			else
			{
				back.render();
				dest.render();
				gold.render();
			}
		}
		
		public function update():void 
		{
			if (!hasRoute)
			{
				buyButton.update();
			}
			else
			{
				back.update();
				dest.update();
				gold.update();
			}
		}
		
		public function add():void 
		{
			
		}
		
		public function remove():void 
		{
			
		}
		
		public function nuthin():void
		{
			
		}
		
		public function buy():void
		{
			port.startRoute(index);
			parent.close();
		}
		
		public function reroute():void
		{
			
		}
	}

}