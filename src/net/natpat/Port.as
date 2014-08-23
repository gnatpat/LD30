package net.natpat 
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Port extends Waypoint 
	{
		
		public var name:String;
		
		public var ss:SpriteSheet;
		
		public function Port(x:int, y:int, name:String) 
		{
			super(x, y);
			ss = new SpriteSheet(Assets.PORTS, 95, 95);
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
			
			//ss.filterAnim("redover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			//ss.filterAnim("redsel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
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
				GV.makingRoute = true;
				selected = this;
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
			ss.update();
		}
		
		
		override public function render(buffer:BitmapData):void
		{
			ss.render(x - 95 / 2, y - 95 / 2);
		}
	}

}