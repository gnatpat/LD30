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
		public var gold:int;
		
		public var lineGraphic:Shape;
		
		public var from:Port;
		public var to:Port;
		
		public function Route(connections:Vector.<WaypointConnection>, graphic:Shape) 
		{
			this.connections = connections;
			this.lineGraphic = graphic;
			gold = 10;
			from = Port(connections[0].from);
			var i:int = 0;
			while (!(connections[i].to is Port))
			{
				i++;
			}
			to = Port(connections[i].to);
		}
		
	}

}