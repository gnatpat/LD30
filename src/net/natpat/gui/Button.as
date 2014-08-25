package net.natpat.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.natpat.Assets;
	import net.natpat.GV;
	import net.natpat.Input;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Button implements IGuiElement 
	{
		/**
		 * Function executed when the mouse is released over the button
		 */
		public var releasedFunction:Function;
		
		/**
		 * Various rectangles, used for displaying various graphics
		 */
		private var normalRect:Rectangle, backRect:Rectangle, overRect:Rectangle, pressedRect:Rectangle, releasedRect:Rectangle;
		
		/**
		 * Whether or not the button has a background, or the dynamic 'button' part
		 */
		private var hasBack:Boolean = true;
		
		/**
		 * Whether or not the button has an icon, which is rendered over the back
		 */
		private var hasIcon:Boolean = false;
		
		private var hasText:Boolean = false;
		
		private var bitmapData:BitmapData;
		private var renderLocation:Point;
		private var text:Text;
		
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		
		private var clipRectangle:Rectangle;
		
		/**
		 * Constructor. Used to set the image, functions and position of the button.
		 * @param	x					X position of button
		 * @param	y					Y position of button
		 * @param	width				Width of the button
		 * @param	height				Height of the button
		 * @param	_releasedFunction	Function to be executed when mouse is released on button
		 * @param	backIndex			Index of the standard background
		 * @param	overIndex			Index of the image to be shown when the mouse is over the button
		 * @param	pressedIndex		Index of the image to be shown when the mouse is pressed on the button
		 * @param	releasedIndex		Index of the image to be shown when the mouse is released
		 * @param	imageIndex			Index of the icon for the button
		 * @param	asset				The name of the asset is Assets to use for this button
		 */
		 
		public function Button(source:*, x:int, y:int, width:int, height:int, releasedFunction:Function, backIndex:int = -1, overIndex:int = -1, pressedIndex:int = -1, releasedIndex:int = -1, imageIndex:int = -1, textOverlay:String = "", textSize:int = 1)
		{
			this.x = x;
			this.y = y;
			
			this.width = width;
			this.height = height;
			
			renderLocation = new Point(x, y);
			
			bitmapData = GV.loadBitmapDataFromSource(source);
			
			var bWidth:int = bitmapData.width;
			
			//If the button has an icon, create a clip rectangle for it
			if (imageIndex != -1)
			{
				hasIcon = true;
				normalRect = new Rectangle((imageIndex % (bWidth / width)) * width, (int(imageIndex / (bWidth / width))) * height, width, height);
			}
			
			//If the button doesn't have a back, don't create clip rectangles for them.
			if (backIndex == -1)
			{
				hasBack = false;
			}
			
			//Create clip rectangles for the rest of the back states.
			if (hasBack)
			{
				if (overIndex == -1)
				{
					overIndex = backIndex;
				}
				if (pressedIndex == -1)
				{
					pressedIndex = backIndex;
				}
				if (releasedIndex == -1)
				{
					releasedIndex = backIndex;
				}
				
				backRect = new Rectangle((backIndex % (bWidth / width)) * width, (int(backIndex / (bWidth / width))) * height, width, height);
				overRect = new Rectangle((overIndex % (bWidth / width)) * width, (int(overIndex / (bWidth / width))) * height, width, height);
				pressedRect = new Rectangle((pressedIndex % (bWidth / width)) * width, (int(pressedIndex / (bWidth / width))) * height, width, height);
				releasedRect = new Rectangle((releasedIndex % (bWidth / width)) * width, (int(releasedIndex / (bWidth / width))) * height, width, height);
				clipRectangle = backRect;
			}
			
			if (textOverlay != "")
			{
				text = new Text(x, y, textOverlay, textSize, false, 0x000000);
				hasText = true;
			}
			
			//Set released function
			this.releasedFunction = releasedFunction;
		}
		
		public function render():void 
		{
			//If the button has a back render it
			if (hasBack)
			{
				GV.screen.copyPixels(bitmapData, clipRectangle, renderLocation, null, null, true);
			}
			//If the button has an icon render that too over the top. Fun.
			if (hasIcon)
			{
				GV.screen.copyPixels(bitmapData, normalRect, renderLocation, null, null, true);
			}
			if (hasText)
			{
				text.render();
			}
		}
		
		public function update():void 
		{
			
			//Resets the clip rectangle
			clipRectangle = backRect;
			
			//If the mouse is over the button display funky graphics by changing the clip rectangle!
			if (GV.pointInRect(Input.mouseX, Input.mouseY, x, y, width, height))
			{
				GV.onGUI = this;
				if (Input.mouseDown)
				{
					clipRectangle = pressedRect;
				}
				else if (Input.mouseReleased)
				{
					clipRectangle = releasedRect;
					Input.mouseReleased = false;
					releasedFunction();
				}
				else
				{
					clipRectangle = overRect;
				}
			} else if (GV.onGUI == this) GV.onGUI = null;
			renderLocation.x = x;
			renderLocation.y = y;
			
			if (hasText)
			{
				text.x = x + ((width - text.width) / 2);
				text.y = y + ((height - text.height) / 2) + 4;
			}
		}
		
		public function add():void 
		{
			
		}
		
		public function remove():void 
		{
			
		}
		
	}

}