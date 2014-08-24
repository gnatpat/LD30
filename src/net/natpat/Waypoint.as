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
		
		public var ss:SpriteSheet;
		
		public var hasPirate:Boolean = false;
		
		public function Waypoint(x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			
			connections = new Vector.<WaypointConnection>();
			
			ss = new SpriteSheet(Assets.PORTS, 95, 95, 0.2);
			ss.addAnim("red", [[0, 0, 0.1]], true);
			
			ss.changeAnim("red");
		}
		
		public function update():void
		{
			if (GV.pointInRect(GV.mouseX, GV.mouseY, x-ss.getWidth()/2, y - ss.getHeight()/2, ss.getWidth(), ss.getHeight()))
			{
				mouseOver = this;
				greenNeighbours();
				
				if (Input.mouseDown && GV.canClick)
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
			
			ss.update();
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
			ss.render(buffer, x, y);
			greenb = false;
		}
		
		public function clearPirate():void
		{
			hasPirate = false;
		}
		
		public function pirateKill():void
		{
			
		}
	}

}