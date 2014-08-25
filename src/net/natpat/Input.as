package net.natpat 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import net.natpat.utils.Key;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Input
	{
		
		public static var mousePressed:Boolean = false;
		public static var mouseReleased:Boolean = false;
		public static var mouseDown:Boolean = false;
		
		public function Input() 
		{
			
		}
		
		public static function setupListeners():void
		{
			//Adds keyboard listeners
			GV.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedEvent);
			GV.stage.addEventListener(KeyboardEvent.KEY_UP,   keyReleasedEvent);
			GV.stage.addEventListener(MouseEvent.MOUSE_DOWN,  mousePressedEvent);
			GV.stage.addEventListener(MouseEvent.MOUSE_UP,    mouseReleasedEvent);
			GV.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEvent);
		}
		
		private static function keyPressedEvent(e:KeyboardEvent):void
		{
			var keyCode:int = e.keyCode;
			
			if (keyCode < 0 || keyCode > 255) return;
			
			keysDown[keyCode] = true;
			keysPressed[noOfKeysPressed] = keyCode;
			noOfKeysPressed++;
		}
		
		private static function keyReleasedEvent(e:KeyboardEvent):void
		{
			var keyCode:int = e.keyCode;
			
			if (keyCode < 0 || keyCode > 255) return;
			
			keysDown[keyCode] = false;
			keysReleased[noOfKeysReleased] = keyCode;
			noOfKeysReleased++;
		}
		
		public static function keyDown(keyCode:int):Boolean
		{
			if (keyCode < 0 || keyCode > 255) return false;
			return keysDown[keyCode];
		}
		
		public static function keyPressed(keyCode:int):Boolean
		{
			if (keyCode < 0 || keyCode > 255) return false;
			for (i = 0; i < noOfKeysPressed; i++)
			{
				if (keysPressed[i] == keyCode)
				{
					return true;
				}
			}
			return false;
		}
		
		public static function keyReleased(keyCode:int):Boolean
		{
			if (keyCode < 0 || keyCode > 255) return false;
			for (i = 0; i < noOfKeysReleased; i++)
			{
				if (keysReleased[i] == keyCode)
				{
					return true;
				}
			}
			return false;
		}
		
		private static function mousePressedEvent(e:MouseEvent):void
		{
			mousePressed = true;
			mouseDown = true;
		}
		
		private static function mouseReleasedEvent(e:MouseEvent):void
		{
			mouseReleased = true;
			mouseDown = false;
		}
		
		public static function mouseWheelEvent(e:MouseEvent):void
		{
			if (e.delta < 0)
			{
				GV.zoomOut();
			}
			else if (e.delta > 0)
			{
				GV.zoomIn();
			}
		}
		
		public static function get mouseX():int
		{
			return GV.stage.mouseX;
		}
		
		public static function get mouseY():int
		{
			return GV.stage.mouseY;
		}
		
		
		public static function update():void
		{
			if (mousePressed) {
				mousePressed = false;
			}
			if (mouseReleased) {
				mouseReleased = false;
			}
			while (noOfKeysPressed > 0)
			{
				noOfKeysPressed--;
				keysPressed[noOfKeysPressed] = 0;
			}
			while (noOfKeysReleased > 0)
			{
				noOfKeysReleased--;
				keysPressed[noOfKeysReleased] = 0;
			}
		}
		
		private static var keysDown:Vector.<Boolean> = new Vector.<Boolean>(256);
		private static var keysPressed:Vector.<int> = new Vector.<int>(64);
		private static var keysReleased:Vector.<int> = new Vector.<int>(64);
		private static var noOfKeysPressed:int = 0;
		private static var noOfKeysReleased:int = 0;
		private static var i:int;
	}

}