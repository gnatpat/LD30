package net.natpat 
{
	import flash.display.BitmapData;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class WaypointManager 
	{
		
		public var waypoints:Vector.<Waypoint>;
		
		public var buffer:BitmapData
		
		public var id:int;
		
		public function WaypointManager(buffer:BitmapData) 
		{
			waypoints = new Vector.<Waypoint>();
			this.buffer = buffer;
			id = 0;
		}
		
		public function add(waypoint:Waypoint):void
		{
			waypoints.push(waypoint);
			waypoint.wm = this;
			waypoint.id = id;
			id++;
		}
		
		public function connectWaypoints():void
		{
			var xDist:int = 0;
			var yDist:int = 0;
			var dist:Number;
			for (var i:int = 0; i < waypoints.length - 1; i++)
			{
				for (var j:int = i + 1; j < waypoints.length; j++)
				{
					xDist = waypoints[i].x - waypoints[j].x;
					yDist = waypoints[i].y - waypoints[j].y;
					dist = Math.sqrt(xDist * xDist + yDist * yDist);
					if (dist < GC.MAX_CONNECTION_LENGTH)
					{
						waypoints[i].connections.push(new WaypointConnection(dist, waypoints[i], waypoints[j]));
						waypoints[j].connections.push(new WaypointConnection(dist, waypoints[j], waypoints[i]));
					}
				}
			}
			removeConnection(72, 122);
			removeConnection(72, 69);
			removeConnection(74, 123);
			removeConnection(72, 123);
			removeConnection(73, 123);
			removeConnection(31, 83);
			removeConnection(32, 83);
			removeConnection(33, 31);
			removeConnection(30, 83);
			removeConnection(86, 30);
			removeConnection(70, 87);
			removeConnection(69, 87);
			removeConnection(33, 70);
			removeConnection(81, 122);
			removeConnection(122, 70);
			removeConnection(68, 123);
			removeConnection(6, 113);
			removeConnection(18, 112);
			removeConnection(16, 112);
			removeConnection(112, 21);
			removeConnection(22, 112);
			removeConnection(28, 112);
			removeConnection(28, 21);
			removeConnection(117, 27);
			removeConnection(29, 115);
			removeConnection(27, 115);
			removeConnection(22, 117);
			removeConnection(27, 26);
			removeConnection(33, 83);
			removeConnection(75, 83);
			removeConnection(81, 79);
			removeConnection(68, 126);
		}
		
		public function removeConnection(w1:int, w2:int)
		{
			waypoints[w1].removeConnectionTo(waypoints[w2]);
			waypoints[w2].removeConnectionTo(waypoints[w1]);
		}
		
		public function render():void
		{
			for each(var w:Waypoint in waypoints)
			{
				w.render(buffer);
			}
		}
		
		public function update():void
		{
			for each(var w:Waypoint in waypoints)
			{
				w.update();
			}
		}
		
	}

}