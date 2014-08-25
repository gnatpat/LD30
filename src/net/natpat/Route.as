package net.natpat 
{
	import flash.display.Shape;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Route 
	{
		
		public var connections:Vector.<WaypointConnection>
		public var time:int;
		public var _gold:int;
		
		public var lineGraphic:Shape;
		
		public var from:Port;
		public var to:Port;
		
		public var distance:int;
		
		public function Route(connections:Vector.<WaypointConnection>, graphic:Shape, distance:int) 
		{
			this.connections = connections;
			this.lineGraphic = graphic;
			this.distance = distance;
			
			
			if (connections[0].from is Port)
				from = Port(connections[0].from);
			else from = null
			var tow:Waypoint = connections[connections.length - 1].to;
			if (tow is Port)
			{
				to = Port(tow);
			}
			else
			{
				to = null;
			}
			if (to != null && from != null)
				_gold = 5 + 0.01 * GV.dist(to.x, to.y, from.x, from.y);
			
		}
		
		
		public function get gold():int
		{
			return _gold * to.levelMult;
		}
		
		
		
	}

}