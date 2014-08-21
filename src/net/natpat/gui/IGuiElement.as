package net.natpat.gui 
{
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public interface IGuiElement
	{
		function render():void;
		
		function update():void;
		
		function add():void;
		
		function remove():void;
		
	}
	
}