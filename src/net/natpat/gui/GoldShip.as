package net.natpat.gui 
{
	import net.natpat.Route;
	import net.natpat.Ship;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GoldShip extends Ship 
	{
		
		public function GoldShip(route:Route, cost:int=50) 
		{
			super(route, cost);
			
		}
		
		
		override public function gotToDest():void 
		{
			if ((waypoint == route.connections.length - 1 && next == 1))
			{
				route.to.hasRoute();
				this.remove();
				return;
			}
			super.gotToDest();
			
		}
	}

}