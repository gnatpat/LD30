package net.natpat 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class ShipManager 
	{
		
		public var ships:Vector.<Ship>
		
		public var buffer:BitmapData;
		
		public function ShipManager(buffer:BitmapData)  
		{
			ships = new Vector.<Ship>();
			this.buffer = buffer;
		}
		
		public function addShip(ship:Ship):void
		{
			ships.push(ship);
		}
		
		public function update():void
		{
			for each(var s:Ship in ships)
			{
				s.update();
			}
		}
		
		public function render():void
		{
			for each(var s:Ship in ships)
			{
				s.render(buffer);
			}
		}
		
	}

}