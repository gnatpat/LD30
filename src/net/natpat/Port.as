package net.natpat 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import net.natpat.gui.Dialog;
	import net.natpat.gui.DialogOk;
	import net.natpat.gui.GuiManager;
	import net.natpat.gui.PortGui;
	import net.natpat.gui.Text;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Port extends Waypoint 
	{
		
		public var name:String;
		
		private var text:SpriteSheet;
		
		public var ships:Vector.<Ship>
		public var newShips:Vector.<Ship>
		
		public var portAdded:Boolean = false;
		
		public static var guiPort:Port;
		public var gui:PortGui;
		
		public var beenTo:Boolean;
		public var home:Boolean;
		
		public var homeColour:String = "red";
		public var foundColour:String = "yellow";
		public var unknownColour:String = "grey";
		
		
		public function Port(x:int, y:int, name:String) 
		{
			this.name = name;
			super(x, y);
			
			colour = unknownColour;
			ss.masterScale = 0.5;
			
			ss.filterAnim("greyover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("greysel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			ss.filterAnim("greyvis", new GlowFilter(0xcc00cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("greenover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("greensel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("orangeover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("orangesel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("redover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("redsel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			ss.filterAnim("redvis", new GlowFilter(0xcc00cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("blueover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("bluesel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("purpleover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("purplesel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("blackover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("blacksel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			
			ss.filterAnim("yellowover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("yellowsel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			ss.filterAnim("yellowvis", new GlowFilter(0xcc00cc, 1, 32, 32, 2), 1.3);
			
			
			var textObj:Text =  new Text(0, 0, name, 24, false);
			var buffer:BitmapData = new BitmapData(textObj.width, textObj.height, true, 0)
			buffer.colorTransform(buffer.rect, new ColorTransform(1, 1, 1, 1, 0, 0, 0, -100));
			textObj.renderOnBuffer(buffer);
			text = new SpriteSheet(buffer, textObj.width, textObj.height);
			
			ships = new Vector.<Ship>(3);
			newShips = new Vector.<Ship>(3);
			
			home = (name == "Bristol");
			beenTo = home;
			if (home)
			{
				homePort = this;
				colour = homeColour;
			}
		}
		
		override public function clicked():void 
		{
			if (GV.debuggingConnections)
			{
				super.clicked();
				return;
			}
			if (GV.makingRoute)
			{
				super.clicked();
			}
			else
			{
				if (!beenTo)
				{
					GuiManager.add(new DialogOk(nuthin, "You can't make a trade route from\n" + name + " yet! Send an explorer\nto this port first."));
				}
				else if (guiPort != this) 
				{
					Input.mouseDown = false;
					gui = new PortGui(this, GV.getScreenX(x) + 10, GV.getScreenY(y) - 170)
					GuiManager.add(gui);
					guiPort = this;
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (gui != null && guiPort != this)
			{
				GuiManager.remove(gui);
				gui = null;
			}
			if (guiPort == this && Input.mouseDown && GV.canClick)
			{
				GuiManager.remove(gui);
				gui = null;
				guiPort = null;
			}
		}
		
		
		override public function render(buffer:BitmapData):void
		{
			for each (var c:WaypointConnection in connections)
			{
				c.render();
			}
			text.render(buffer, x, y - 40 - 7 * (GV.zoom - 1), true, GC.SPRITE_ZOOM_RATIO * 2, true);
			if (visible)
			{
				ss.changeAnim(colour + "vis");
			}
			super.render(buffer);
			var m:Matrix = new Matrix;
			if (guiPort == this && gui != null)
			{
				gui.setPos(GV.getScreenX(x) + 10, GV.getScreenY(y) - 170);
			}
		}
		
		public function addShip(ship:Ship, index:int = 0):void
		{
			ships[index] = ship;
		}
		
		public function removeShip(ship:Ship):void
		{
			var i:int = ships.indexOf(ship);
			if(i != -1)
				ships[i] = null;
		}
		
		public function removeShipByIndex(index:int):void
		{
			ships[index] = null;
		}
		
		override public function startRoute(index:int):void 
		{
			super.startRoute(index);
			GV.routePort = this;
		}
		
		public function checkForReplace(ship:Ship):void
		{
			var i:int = ships.indexOf(ship);
			if (newShips[i] != null)
			{
				ships[i] = newShips[i];
				ship.sm.removeShip(ship, true);
				ship.sm.addShip(newShips[i], this, i);
			}
		}
		
		public function hasRoute():void
		{
			if (!beenTo)
			{
				beenTo = true;
				colour = foundColour;
			}
		}
		
		public function nuthin():void
		{
			
		}
	}

}