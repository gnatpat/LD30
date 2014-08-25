package net.natpat {
	import net.natpat.Route;
	import net.natpat.Ship;
	import net.natpat.utils.Sfx;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GoldShip extends Ship 
	{
		
		public function GoldShip(route:Route, cost:int=50) 
		{
			super(route, cost);
			ss = new SpriteSheet(Assets.YELLOW_SHIP, 354, 316, 0.01);
			addAnims();
			
		}
		
		
		override public function gotToDest():void 
		{
			if ((waypoint == route.connections.length - 1 && next == 1))
			{
				route.to.hasRoute();
				Sfx.sfxs["discover"].play();
				this.remove();
				return;
			}
			super.gotToDest();
			
		}
	}

}