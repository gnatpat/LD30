package net.natpat.gui
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import net.natpat.gui.IGuiElement;
	import net.natpat.GV;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import net.natpat.GC;
	import flash.text.TextFieldType;
	
	/**
	 * Quick and dirty rendering of the text to the screen
	 * 
	 * TO USE MAKE SURE THE EMBED STATEMENT BELOW LINKS TO THE CORRECT FONT
	 * @author Nathan Patel
	 */
	public class Text implements IGuiElement
	{
		[Embed(source = "../utils/GOTHICBI.TTF", embedAsCFF="false", fontFamily = 'default', mimeType='application/x-font')]
		private static const VISITOR_FONT:Class;
		
		/**
		 * The font to assign to new Text objects.
		 */
		public static var font:String = "default";
		
		/**
		 * The font GC.SIZE to assign to new Text objects. If using Visitor set to a multiple of 13!
		 */
		public static var SIZE:uint = 9;
		
		/**
		 * x location of the text
		 */
		public var x:Number;
		
		/**
		 * y location of the text
		 */
		public var y:Number;
		
		/**
		 * Colour of the text
		 */
		public var colour:uint;
		
		/**
		 * The place on the bitmap data to take the Thing's graphic from
		 */
		public var clipRectangle:Rectangle;
		
		private var xCentre:Boolean = false;
		private var yCentre:Boolean = false;
		
		/**
		 * A component with dynamic text.
		 * @param	x				x location of component
		 * @param	y				y location of component
		 * @param	_getTextString	Function that returns the string to display
		 * @param	... args		Arguments to pass to the function
		 */
		public function Text(x:int, y:int, text:String, size:int = 18, hasOutline:Boolean = false, colour:uint = 0xffffff)
		{
			this.x = x;
			this.y = y;
			
			originalCoords = new Point(x, y);
			
			if (x == -1)
			{
				xCentre = true;
			}
			if (y == -1)
			{
				yCentre = true;
			}
			
			this.scale = 1;
			this.colour = colour;
			
			this.scroll = scroll;
			
			//Gets the font and GC.SIZE from the static variables and puts them into local ones, so the font and GC.SIZE are "saved"
			_font = font;
			
			//Create the text format.
			_form = new TextFormat(_font, size, colour)
			//_form.align = TextFormatAlign.CENTER;
			
			//Set the TextField to use embedded fonts, so we can use Visitor
			_field.embedFonts = true;
			
			//Set the antiAlias type to Advanced, so we can set sharpness so the font isn't yucky and blurry
			_field.antiAliasType = AntiAliasType.ADVANCED;
			
			//Set the text in the text field.
			_field.text = _text = text;
			
			//Add the black outline
			var outline:GlowFilter = new GlowFilter();
			outline.blurX = outline.blurY = 1.6;
			outline.color = 0x000000;
			outline.quality = 1;
			outline.strength = 250;
			
			if (hasOutline)
			{
				var filterArray:Array = new Array();
				filterArray.push(outline);
				_field.filters = filterArray;
			}
			
			//Set the width and height for rendering
			_width = 4;
			_height = 4;
			
			//Create a new bitmap data for rendering the textField to
			unscaledBitmapData = new BitmapData(_width, _height, true, 0);
			bitmapData = new BitmapData(1, 1);
			
			clipRectangle = unscaledBitmapData.rect;
			//Update the text object
			updateGraphic();
		}
		
		public function set text(newText:String):void
		{
			
			_field.text = _text = newText;
			updateGraphic();
		}
		
		public function get text():String
		{
			
			return _field.text;
		}
		
		public function updateGraphic():void
		{
			//Set the textField's formatter to _form
			_field.setTextFormat(_form);
			
			_form.color = colour
			
			//For testing purposes, set _textWidth and height to how big the text field actually needs to be
			_textWidth = _field.textWidth + 6;
			_textHeight = _field.textHeight + 8;
			
			_width = _textWidth;
			_height = _textHeight;
			
			unscaledBitmapData = new BitmapData(_width, _height, true, 0);
			
			
			//Set the text field's width and height to width and height so edges of text doesn't get clipped off
			_field.width = _width;
			_field.height = _height;
			
			//Finally, draw the text field to bitmapData
			unscaledBitmapData.draw(_field);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);

			bitmapData = new BitmapData(unscaledBitmapData.width * scale, unscaledBitmapData.height * scale, true, 0x000000);
			bitmapData.draw(unscaledBitmapData, matrix, null, null, null, false);
			
			clipRectangle = bitmapData.rect;
			
			this.x = xCentre? (GC.SCREEN_WIDTH - bitmapData.width) / 2 : this.x;
			this.y = yCentre? (GC.SCREEN_HEIGHT - bitmapData.height) / 2 : this.y;
		}
		
		public function render():void
		{
			renderOnBuffer(GV.screen);
		}
		
		public function renderOnBuffer(buffer:BitmapData):void
		{
			if (bitmapData == null) return; 
			renderLocation.x = x;
			renderLocation.y = y;
			buffer.copyPixels(bitmapData, clipRectangle, renderLocation, null, null, true);
		
		}
		
		public function update():void
		{
			if (xCentre)
			{
				x = (GC.SCREEN_WIDTH - bitmapData.width) / 2;
			}
			if (yCentre)
			{
				y = (GC.SCREEN_HEIGHT - bitmapData.height) / 2;
			}
			
		}
		
		public function add():void
		{
			updateGraphic()
		}
		
		public function remove():void
		{
		}
		
		public function get width():int
		{
			return bitmapData.width;
		}
		
		public function get height():int
		{
			return bitmapData.height;
		}
		
		protected var _field:TextField = new TextField;
		protected var _width:uint;
		protected var _height:uint;
		protected var _textWidth:uint;
		protected var _textHeight:uint;
		protected var _form:TextFormat;
		protected var _text:String;
		protected var _font:String;
		protected var _SIZE:uint;
		protected var scroll:Boolean;
		protected var scale:int;
		private   var renderLocation:Point = new Point();
		private   var unscaledBitmapData:BitmapData;
		private   var bitmapData:BitmapData;
		private   var originalCoords:Point;
	}

}