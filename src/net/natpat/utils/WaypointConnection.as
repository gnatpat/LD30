package net.natpat.utils 
{
	import net.natpat.Waypoint;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class WaypointConnection 
	{
		
		public var distance:Number;
		public var from:Waypoint;
		public var to:Waypoint;
		
		public function WaypointConnection(distance:Number, from:Waypoint, to:Waypoint) 
		{
			this.distance = distance;
			this.from = from;
			this.to = to;
		}
		
	}

}