package net.natpat 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
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
		
		public function Port(x:int, y:int, name:String) 
		{
			this.name = name;
			super(x, y);
			ss = new SpriteSheet(Assets.PORTS, 95, 95, 0.5);
			ss.addAnim("red", [[0, 0, 0.1]], true);
			ss.addAnim("redover", [[0, 0, 0.1]], true);
			ss.addAnim("redsel", [[0, 0, 0.1]], true);
			ss.addAnim("blue", [[1, 0, 0.1]], true);
			ss.addAnim("green", [[2, 0, 0.1]], true);
			ss.addAnim("grey", [[3, 0, 0.1]], true);
			ss.addAnim("orange", [[4, 0, 0.1]], true);
			ss.addAnim("purple", [[5, 0, 0.1]], true);
			ss.addAnim("black", [[6, 0, 0.1]], true);
			ss.addAnim("yellow", [[7, 0, 0.1]], true);
			
			ss.changeAnim("red");
			
			ss.filterAnim("redover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("redsel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			var textObj:Text =  new Text(0, 0, name, 3, false);
			var buffer:BitmapData = new BitmapData(textObj.width, textObj.height, true, 0)
			textObj.renderOnBuffer(buffer);
			text = new SpriteSheet(buffer, textObj.width, textObj.height);
			
			ships = new Vector.<Ship>(3);
		}
		
		override public function clicked():void 
		{
			if (GV.makingRoute)
			{
				connectPath();
				
				if (GV.currentRoute.length != 0 && selected == this)
				{
					selected = null;
					GV.makingRoute = false;
					Input.mouseDown = false;
				}
			}
			else
			{
				Input.mouseDown = false;
				GuiManager.add(new PortGui(this, GV.getScreenX(x + 10), GV.getScreenY(y - 150)));
				trace(GV.getScreenX(x + 10), GV.getScreenY(y - 150));
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (mouseOver == this)
			{
				ss.changeAnim("redover");
			}
			else if (selected == this)
			{
				ss.changeAnim("redsel");
			}
			else 
			{
				ss.changeAnim("red");
			}
		}
		
		
		override public function render(buffer:BitmapData):void
		{
			text.render(buffer, x, y - 33 - 10 * (GV.zoom - 1), true, GC.SPRITE_ZOOM_RATIO * 2, true);
			ss.render(buffer, x, y);
			var m:Matrix = new Matrix;
		}
		
		public function addShip(ship:Ship, index:int = 0):void
		{
			ships[index] = ship;
		}
		
		public function removeShip(ship:Ship):void
		{
			ships[ships.indexOf(ship)] = null;
		}
		
		public function removeShipByIndex(index:int):void
		{
			ships[index] = null;
		}
		
		public function startRoute(index:int):void
		{
			GV.makingRoute = true;
			selected = this;
			GV.routePort = this;
			GV.routeIndex = index;
		}
	}

}