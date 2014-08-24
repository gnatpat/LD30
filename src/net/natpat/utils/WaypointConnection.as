package net.natpat.utils 
{
	import flash.display.Shader;
	import flash.display.Shape;
	import net.natpat.GV;
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
		
		public static var s:Shape = new Shape;
		
		public function WaypointConnection(distance:Number, from:Waypoint, to:Waypoint) 
		{
			this.distance = distance;
			this.from = from;
			this.to = to;
		}
		
		public function render():void
		{
			s.graphics.moveTo(from.x, from.y);
			s.graphics.lineTo(to.x, to.y);
		}
		
	}

}