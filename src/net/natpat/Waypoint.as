package net.natpat 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Waypoint 
	{
		
		public static var mouseOver:Waypoint = null;
		public static var selected:Waypoint = null;
		
		public var x:int;
		public var y:int;
		
		public var connections:Vector.<WaypointConnection>
		
		public var greenb:Boolean = false;
		
		public var wm:WaypointManager;
		
		public var ableToConnect:Boolean = false;
		
		public function Waypoint(x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			
			connections = new Vector.<WaypointConnection>();
		}
		
		public function update():void
		{
			if (GV.pointInRect(Input.mouseX, Input.mouseY, x - 4, y - 4, 8, 8))
			{
				mouseOver = this;
				greenNeighbours();
				
				if (Input.mouseDown)
				{
					clicked();
				}
			} 
			else if (mouseOver == this)
			{
				mouseOver = null;
			}
			
			if (selected == this && !greenb)
			{
				greenNeighbours();
			}
		}
		
		public function greenNeighbours():void
		{
			for each(var c:WaypointConnection in connections)
			{
				c.to.green();
			}
		}
		
		public function clicked():void
		{
			if (selected != null && GV.makingRoute) connectPath();
		}
		
		public function connectPath():void
		{
			for (var i:int = 0; i < GV.currentRoute.length; i++)
			{
				if (GV.currentRoute[i].from == this)
				{
					GV.currentRoute.splice(i, GV.currentRoute.length - i);
					selected = this;
					return;
				}
			}
				
			var wc:WaypointConnection = selected.isConnectedTo(this);
			if (wc == null) return;
			
			selected = this;
			
			GV.currentRoute.push(wc);
		}
		
		public function isConnectedTo(w:Waypoint):WaypointConnection
		{
			for each(var wc:WaypointConnection in connections)
			{
				if (wc.to == w)
					return wc;
			}
			return null;
		}
		
		public function green():void
		{
			greenb = true;
		}
		
		public function render(buffer:BitmapData):void
		{
			buffer.fillRect(new Rectangle(x - 4, y - 4, 8, 8), greenb ? 0x00ff00 : (mouseOver == this ? 0x0000ff : (selected == this ? 0x990099 : 0xff0000)));
			greenb = false;
		}
	}

}