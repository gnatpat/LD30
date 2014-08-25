package net.natpat 
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
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
		
		public var visible:Boolean = false;
		
		public var wm:WaypointManager;
		
		public var ableToConnect:Boolean = false;
		
		public var ss:SpriteSheet;
		
		public var hasPirate:Boolean = false;
		
		public var id:int = 0;
		
		public var colour:String;
		
		public var redShip:RedShip = null;
		
		public var onRoute:Boolean = false;
		
		public static var homePort:Port;
		
		public function Waypoint(x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			
			connections = new Vector.<WaypointConnection>();
			
			ss = new SpriteSheet(Assets.PORTS, 95, 95, 0.2);
			ss.addAnim("red", [[0, 0, 0.1]], true);
			ss.addAnim("redover", [[0, 0, 0.1]], true);
			ss.addAnim("redsel", [[0, 0, 0.1]], true);
			ss.addAnim("redvis", [[0, 0, 0.1]], true);
			ss.addAnim("blue", [[1, 0, 0.1]], true);
			ss.addAnim("blueover", [[1, 0, 0.1]], true);
			ss.addAnim("bluesel", [[1, 0, 0.1]], true);
			ss.addAnim("green", [[2, 0, 0.1]], true);
			ss.addAnim("greenover", [[2, 0, 0.1]], true);
			ss.addAnim("greensel", [[2, 0, 0.1]], true);
			ss.addAnim("grey", [[3, 0, 0.1]], true);
			ss.addAnim("greyover", [[3, 0, 0.1]], true);
			ss.addAnim("greysel", [[3, 0, 0.1]], true);
			ss.addAnim("greyvis", [[3, 0, 0.1]], true);
			ss.addAnim("orange", [[4, 0, 0.1]], true);
			ss.addAnim("orangeover", [[4, 0, 0.1]], true);
			ss.addAnim("orangesel", [[4, 0, 0.1]], true);
			ss.addAnim("purple", [[5, 0, 0.1]], true);
			ss.addAnim("purpleover", [[5, 0, 0.1]], true);
			ss.addAnim("purplesel", [[5, 0, 0.1]], true);
			ss.addAnim("black", [[6, 0, 0.1]], true);
			ss.addAnim("blackover", [[6, 0, 0.1]], true);
			ss.addAnim("blacksel", [[6, 0, 0.1]], true);
			ss.addAnim("yellow", [[7, 0, 0.1]], true);
			ss.addAnim("yellowover", [[7, 0, 0.1]], true);
			ss.addAnim("yellowsel", [[7, 0, 0.1]], true);
			ss.addAnim("yellowvis", [[7, 0, 0.1]], true);
			ss.addAnim("sea", [[9, 0, 0.1]], true);
			ss.addAnim("seaover", [[8, 0, 0.1]], true);
			ss.addAnim("seasel", [[8, 0, 0.1]], true);
			ss.addAnim("seavis", [[8, 0, 0.1]], true);
			ss.filterAnim("seaover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("seasel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
														  
			colour = "sea";
			
			ss.changeAnim(colour);
		}
		
		public function update():void
		{
			if (GV.debuggingConnections)
			{
				if (GV.w == this) selected = this;
				else if (selected == this) selected = null;
			}
			if (GV.pointInRect(GV.mouseX, GV.mouseY, x-ss.getWidth()/2, y - ss.getHeight()/2, ss.getWidth(), ss.getHeight()))
			{
				mouseOver = this;
				showNeighbours();
				
				if (Input.mouseDown && GV.canClick)
				{
					clicked();
				}
			} 
			else if (mouseOver == this)
			{
				mouseOver = null;
			}
			
			var chance:Number =  Math.random();
			if (!(this is Port) && GV.dist(x, y, homePort.x, homePort.y) < GC.MAX_CONNECTION_LENGTH && chance < GC.PIRATE_CHANCE)
			{
				this.hasPirate = true;
				//trace("Pirate at " + x + ", " + y);
			}
			
			if (selected == this)
			{
				showNeighbours();
			}
			
			
			
			if (mouseOver == this)
			{
				ss.changeAnim(colour + "over");
			}
			else if (selected == this)
			{
				ss.changeAnim(colour + "sel");
			}
			else 
			{
				ss.changeAnim(colour);
			}
			ss.update();
		}
		
		public function showNeighbours():void
		{
			for each(var c:WaypointConnection in connections)
			{
				c.to.makeVisible();
			}
		}
		
		public function clicked():void
		{
			if (GV.debuggingConnections) 
			{
				Input.mouseDown = false;
				if (GV.w == this)
				{
					GV.w = null;
					return;
				}
				
				if (GV.w == null)
				{
					GV.w = this;
					return;
				}
				
				if (isConnectedTo(GV.w) == null) 
				{
					return;
				}
				
				trace("removeConnection(" + id + ", " + GV.w.id + ");");
				wm.removeConnection(id, GV.w.id);
				GV.w = null;
				return;
			}
			
			if (selected != null && GV.makingRoute) connectPath();
			
			else if	(redShip != null)
			{
				GV.redShip = redShip;
				startRoute(-1);
			}
		}
		
		public function startRoute(index:int):void
		{
			GV.makingRoute = true;
			selected = this;
			//GV.routePort = this;
			GV.routeIndex = index;
		}
		
		public function connectPath():void
		{
			if (selected == this) return;
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
		
		public function removeConnectionTo(w:Waypoint):void
		{
			
			for (var i:int = 0; i < connections.length; i++)
			{
				if (connections[i].to == w)
				{
					connections.splice(i, 1);
					return;
				}
			}
		}
		
		public function makeVisible():void
		{
			visible = true;
		}
		
		public function render(buffer:BitmapData):void
		{
			if (selected == this)
			{
				ss.changeAnim(colour + "sel");
			}
			else if (mouseOver == this)
			{
				ss.changeAnim(colour + "over");
			}
			else  if (visible)
			{
				ss.changeAnim(colour + "vis");
			}
			else
			{
				ss.changeAnim(colour);
			}
			visible = false;
			ss.render(buffer, x, y);
			if (GV.debuggingConnections)
			{
				for each (var c:WaypointConnection in connections)
				{
					c.render();
				}
			}
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