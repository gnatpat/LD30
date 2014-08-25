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
		
		public function addOldPos(waypoint:Waypoint):void
		{
			waypoint.x *=0.43554
			waypoint.y *= 0.43554
			add(waypoint);
		}
		
		public function add(waypoint:Waypoint):void
		{
			waypoints.push(waypoint);
			waypoint.wm = this;
			waypoint.id = id;
			id++;
		}
		
		public function addAtlanticPoints():void
		{
			var x:int = 2000;
			var y:int = 870;
			var width:int = 900;
			var height:int = 1830;
			var attempts:int = 0;
			var points:Vector.<Waypoint> = new Vector.<Waypoint>();
			var wx:int;
			var wy:int;
			var tooclose:Boolean = false;
			var w:Waypoint;
			while (attempts < 10000)
			{
				wx = GV.random() * width * -1 + x;
				wy = GV.random() * height * -1 + y;
				for each(w in points)
				{
					if (GV.dist(wx, wy, w.x, w.y) < 100)
					{
						attempts++;
						tooclose = true;
						break;
					}
				}
				if (!tooclose)
				{
					points.push(new Waypoint(wx, wy));
					attempts = 0;
				}
				tooclose = false;
			}
			for each(w in points)
			{
				add(w);
			}
			trace(points.length);
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
			
			removeConnection(75, 179);
			removeConnection(30, 179);
			removeConnection(31, 179);
			removeConnection(32, 179);
			removeConnection(33, 179);
			removeConnection(33, 31);
			removeConnection(69, 183);
			removeConnection(70, 33);
			removeConnection(70, 183);
			removeConnection(218, 70);
			removeConnection(76, 180);
			removeConnection(77, 75);
			removeConnection(68, 222);
			removeConnection(81, 218);
			removeConnection(72, 218);
			removeConnection(74, 219);
			removeConnection(72, 69);
			removeConnection(72, 219);
			removeConnection(73, 219);
			removeConnection(68, 219);
			removeConnection(30, 180);
			removeConnection(81, 79);
			removeConnection(182, 30);
			removeConnection(4, 185);
			removeConnection(16, 208);
			removeConnection(18, 208);
			removeConnection(21, 208);
			removeConnection(22, 208);
			removeConnection(28, 208);
			removeConnection(21, 28);
			removeConnection(18, 14);
			removeConnection(22, 213);
			removeConnection(21, 213);
			removeConnection(211, 29);
			removeConnection(211, 27);
			removeConnection(27, 26);
			removeConnection(26, 29);
			removeConnection(10, 210);
			removeConnection(6, 209);
			removeConnection(41, 203);
			removeConnection(132, 188);
			removeConnection(125, 189);
			removeConnection(112, 189);
			removeConnection(189, 123);
			removeConnection(123, 110);
			removeConnection(201, 123);
			removeConnection(116, 201);
			removeConnection(201, 167);
			removeConnection(117, 201);
			removeConnection(126, 192);
			removeConnection(155, 196);
			removeConnection(196, 147);
			removeConnection(199, 150);
			removeConnection(154, 199);
			removeConnection(199, 164);
			removeConnection(222, 218);
			removeConnection(219, 218);
			removeConnection(221, 219);
			removeConnection(221, 220);
			removeConnection(219, 183);
			removeConnection(181, 179);
			removeConnection(184, 182);
			removeConnection(210, 209);
			removeConnection(215, 214);
			removeConnection(213, 214);
			removeConnection(213, 211);
			removeConnection(203, 202);
			removeConnection(64, 207);
			removeConnection(89, 195);
			removeConnection(200, 186);
			removeConnection(191, 190);
			removeConnection(196, 197);
			removeConnection(153, 151);
			removeConnection(31, 223);
			removeConnection(181, 223);
			removeConnection(30, 223);
			removeConnection(72, 70);
		}
		
		public function removeConnection(w1:int, w2:int):void
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