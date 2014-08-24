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
		public var lineBuffer:BitmapData;
		
		public function ShipManager(lineBuffer:BitmapData, buffer:BitmapData)  
		{
			ships = new Vector.<Ship>();
			this.buffer = buffer;
			this.lineBuffer = lineBuffer;
		}
		
		public function addShip(ship:Ship, port:Port, index:int):void
		{
			ships.push(ship);
			ship.sm = this;
			port.addShip(ship, index);
		}
		
		public function removeShip(ship:Ship):void
		{
			ships.splice(ships.indexOf(ship), 1);
			ship.homePort.removeShip(ship);
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
				s.render(lineBuffer, buffer);
			}
		}
		
	}

}