package net.natpat.particles 
{
	/**
	 * ...
	 * @author Nathan Patel
	 */
	internal class Particle 
	{
		
		internal var x:int;
		internal var y:int;
		internal var xVel:Number;
		internal var yVel:Number;
		
		internal var time:Number;
		internal var duration:Number;
		
		internal var gravity:Number;
		
		internal var next:Particle;
		internal var prev:Particle;
		
		public function Particle() 
		{
			
		}
		
	}

}