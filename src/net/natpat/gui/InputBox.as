package net.natpat.gui 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.natpat.GV;
	import net.natpat.GC;
	import flash.text.AntiAliasType;
	import net.natpat.Input;
	import net.natpat.gui.IGuiElement;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class InputBox implements IGuiElement
	{
		
		public var inputField:TextField;
		
		private var textForm:TextFormat;
		
		public var defaultText:String;
		
		private var xCentre:Boolean = false;
		private var yCentre:Boolean = false;
		
		public function InputBox(x:int, y:int, defaultText:String = "", width:int = 200, height:int = 30, scale:int = 3) 
		{
			inputField = new TextField();
			
			textForm = new TextFormat("default", 9*scale, 0x000000);
			inputField.defaultTextFormat = textForm;
			
			inputField.x = x == -1? (GC.SCREEN_WIDTH - width) / 2 : x;
			inputField.y = y == -1? (GC.SCREEN_HEIGHT - height) / 2 : y;
			
			if (x == -1)
			{
				xCentre = true;
			}
			if (y == -1)
			{
				yCentre = true;
			}
			
			inputField.width = width;
			inputField.height = height;
			
			inputField.border = true;
			inputField.type = "input";
			inputField.text = defaultText;
			inputField.background = true;
			//inputField.tabEnabled = false;
			
			inputField.embedFonts = true;
			inputField.antiAliasType = AntiAliasType.ADVANCED;
			inputField.sharpness = 400;
			
			this.defaultText = defaultText;
		}
		
		public function get x():int
		{
			return inputField.x;
		}
		
		public function get y():int
		{
			return inputField.y;
		}
		
		public function set x(_x:int):void
		{
			inputField.x = _x;
		}
		
		public function set y(_y:int):void
		{
			inputField.y = _y;
		}
		
		public function get text():String
		{
			return inputField.text;
		}
		
		public function render():void 
		{
			
		}
		
		public function update():void 
		{
			if (inputField.text == "" && GV.stage.focus != inputField)
			{
				inputField.text = defaultText;
			}
			if (inputField.text == defaultText)
			{
				inputField.textColor = 0x999999
				if (GV.stage.focus == inputField) {
					inputField.text = "";
					inputField.textColor = 0x000000;
				}
			} 
			else
			{
				inputField.textColor = 0x000000;
			}
			
			if (xCentre)
			{
				inputField.x = (GC.SCREEN_WIDTH - inputField.width) / 2;
			}
			if (yCentre)
			{
				inputField.y = (GC.SCREEN_HEIGHT - inputField.height) / 2;
			}
			
		}
		
		public function add():void 
		{
			GV.stage.addChild(inputField);
		}
		
		public function remove():void 
		{
			GV.stage.removeChild(inputField);
		}
	}

}