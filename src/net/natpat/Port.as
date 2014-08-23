package net.natpat 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Port extends Waypoint 
	{
		
		public var name:String;
		
		public function Port(x:int, y:int, name:String) 
		{
			super(x, y);
			
		}
		
		override public function clicked():void 
		{
			if (GV.makingRoute)
			{
				connectPath();
				
				if (GV.currentRoute.length != 0)
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
		
		
		
		override public function render(buffer:BitmapData):void
		{
			buffer.fillRect(new Rectangle(x - 6, y - 6, 12, 12), greenb ? 0x00ff00 : (mouseOver == this ? 0x0000ff : (selected == this ? 0x990099 : 0xff0000)));
			greenb = false;
		}
	}

}