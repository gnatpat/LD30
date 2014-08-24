package net.natpat 
{
	import flash.display.BitmapData;
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
		
		public var greenb:Boolean = false;
		
		public var wm:WaypointManager;
		
		public var ableToConnect:Boolean = false;
		
		public var ss:SpriteSheet;
		
		public var hasPirate:Boolean = false;
		
		public var id:int = 0;
		
		public function Waypoint(x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			
			connections = new Vector.<WaypointConnection>();
			
			ss = new SpriteSheet(Assets.PORTS, 95, 95, 0.2);
			ss.addAnim("red", [[0, 0, 0.1]], true);
			ss.addAnim("redover", [[0, 0, 0.1]], true);
			ss.addAnim("redsel", [[0, 0, 0.1]], true);
			ss.filterAnim("redover", new GlowFilter(0xcccc00, 1, 32, 32, 2 ), 1.3);
			ss.filterAnim("redsel", new GlowFilter(0x0000cc, 1, 32, 32, 2), 1.3);
			
			ss.changeAnim("red");
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
			
			if (mouseOver == this)
			{
				ss.changeAnim("redover");
			}
			else if (selected == this)
			{
				ss.changeAnim("redsel");
			}
			else 
			{
				ss.changeAnim("red");
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
		
		public function green():void
		{
			greenb = true;
		}
		
		public function render(buffer:BitmapData):void
		{
			ss.render(buffer, x, y);
			greenb = false;
			for each (var c:WaypointConnection in connections)
			{
				c.render();
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