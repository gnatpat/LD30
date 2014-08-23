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
		
		public function Route(connections:Vector.<WaypointConnection>, graphic:Shape) 
		{
			this.connections = connections;
			this.lineGraphic = graphic;
		}
		
	}

}