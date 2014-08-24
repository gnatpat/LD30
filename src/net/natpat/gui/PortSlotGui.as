package net.natpat.gui 
{
	import flash.accessibility.ISearchableText;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.natpat.Assets;
	import net.natpat.GC;
	import net.natpat.GV;
	import net.natpat.Port;
	import net.natpat.SpriteSheet;
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
		public var cost:Text;
		public var back:Button;
		public var dest:Text;
		
		public var rerouteButton:Button;
		
		public var hasRoute:Boolean;
		
		public var port:Port;
		
		public var index:int;
		
		public var parent:PortGui;
		
		public var image:BitmapData;
		
		public static var overs:Array = [Bitmap(new Assets.BUTTONS1).bitmapData,
										 Bitmap(new Assets.BUTTONS2).bitmapData,
										 Bitmap(new Assets.BUTTONS3).bitmapData]
		public function PortSlotGui(parent:PortGui, x:int, y:int, width:int, height:int, port:Port, index:int) 
		{
			this.parent = parent;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			hasRoute = (port.ships[index] != null)
			
			x += 4 * index;
			
			buyButton = new Button(new BitmapData(1, 1, true, 0), x+90, y + 60 + index * 80, 135, 55, buy, 0); 
			cost = new Text(x + 125, y + 63 + index * 80, "" + GV.shipCost, 32, false, 0);
			image = new BitmapData(width, height, true, 0);
			image.copyPixels(overs[index], new Rectangle(hasRoute ? 0 : width, 0, width, height), GC.ZERO, null, null, true);
			
			if (hasRoute)
			{
				var size:int = 29;
				do {
					dest = new Text(x, y + 61 + index * 80, port.ships[index].route.to.name, size, false, 0);
					size--;
				} while (dest.width > 110);
				
				dest.x = x + 90 + (135 - dest.width) / 2;
				dest.y -= (size - 28) * 0.75;
			}
			
			rerouteButton = new Button(new BitmapData(width - 20, height - 20, true, 0xffff0000), 10, height - 10, width - 20, 20, reroute, 0, -1, -1, -1, -1, "Reroute", 16);
			
			this.port = port;
			this.index = index;
		}
		
		
		public function render():void 
		{
			if (!hasRoute)
			{
				GV.screen.copyPixels(image, image.rect, new Point(x, y));
				buyButton.render();
				cost.render();
			}
			else
			{
				GV.screen.copyPixels(image, image.rect, new Point(x, y));
				dest.render();
			}
		}
		
		public function update():void 
		{
			if (!hasRoute)
			{
				buyButton.update();
				cost.update();
			}
			else
			{
				dest.update();
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