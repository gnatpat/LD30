package net.natpat 
{
	import flash.display.BitmapData;
	import net.natpat.utils.Sfx;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class RedShip extends Ship 
	{
		
		public var w:Waypoint;
		
		public var circle:Array = [[-3, 0], [0, -3], [3, 0], [0, 3]];
		
		public var circleint:int = 0;
		
		public var hasSm:Boolean = false;
		
		public var pirateSS:SpriteSheet;
		public var pirates:Boolean = false;
		
		
		
		public function RedShip(w:Waypoint, route:Route, cost:int=50) 
		{
			super(route, cost);
			canKillPirates = true;
			scales = false;
			this.w = w;
			ss = new SpriteSheet(Assets.RED_SHIP, 354, 316, 0.01);
			addAnims();
			//ss.addAnim("wobble", [[0, 2, wobbleTime], [1, 2, wobbleTime], [2, 2, wobbleTime], [3, 2, wobbleTime], [4, 2, wobbleTime], [5, 2, wobbleTime], [6, 2, wobbleTime], [7, 2, wobbleTime], [8, 2, wobbleTime]], true);
			ss.addAnim("explode", [[0, 0, 0.1], [1, 0, 0.1], [2, 0, 0.1, doneExplode], [3, 0, 0.1], [4, 0, 0.1], [5, 0, 0.1], [6, 0, 5]], true);
			ss.changeAnim("wobble");
			pirateSS = new SpriteSheet(Assets.PIRATES, 128, 144, 0.5);
			pirateSS.addAnim("fire", [[0, 0, 0.2], [1, 0, 0.4], [2, 0, 0.2], [3, 0, 0.2], [4, 0, 0.2], [5, 0, 0.4], [6, 0, 0.2], [7, 0, 0.2], [8, 0, 0.2, explode], [8, 0, 5]], true);
			pirateSS.addAnim("explode", [[0, 1, 0.2], [1, 1, 0.2], [2, 1, 0.2], [3, 1, 0.2, remove]], true);
			pirateSS.changeAnim("default");
		}
		
		override public function gotToDest():void 
		{
			if (route.connections.length >= 1)
			{
				super.gotToDest();
				if (waypoint == 1)
				{
					route.connections.shift();
				}
				if (next == -1)
				{
					w = route.connections[0].to;
					route.connections.shift();
					gotToDest();
				}
			}
			else
			{
				next = 1;
				w.redShip = this;
				var oldx:int = w.x
				var oldy:int = w.y
				circleint++;
				circleint = circleint % 4;
				xDest = w.x
				yDest = w.y
				getDirDir(oldx, oldy);
				
			}
			waypoint = 0;
			shoreLeave = 0;
			
		}
		
		
		override public function pirate():void 
		{
			trace("PRIATES");
			if (next == 1)
			{
				cc.from.clearPirate();
			}
			else
			{
				cc.to.clearPirate();
			}
			move = false;
			if (!pirates)
			{
				pirateSS.changeAnim("fire");
				pirates = true;
			}
		}
		
		public function started():void
		{
			//gotToDest();
			next = -1;
			waypoint = 0;
		}
		
		public function explode():void
		{
			ss.changeAnim("explode");
			Sfx.sfxs["explodeParrot"].play();
		}                                                                                                         
		
		public function doneExplode():void
		{
			pirateSS.changeAnim("explode");
		}
		
		override public function update():void 
		{
			super.update();
			pirateSS.update();
		}
		
		override public function get cc():WaypointConnection 
		{
			if (route == null || waypoint == -1) { x = GV.routePort.x; y = GV.routePort.y; return null }
			return super.cc;
		}
		
		override public function remove():void 
		{
			super.remove();
			GV.redShipNo--;
			GV.noOfPirates--;
		}
		
		override public function render(lineBuffer:BitmapData, buffer:BitmapData):void 
		{
			super.render(lineBuffer, buffer);
			if (pirates)
			{
				pirateSS.render(buffer, x, y - 30, true, GC.SPRITE_ZOOM_RATIO * 1.5, true);
			}
		}
	}

}