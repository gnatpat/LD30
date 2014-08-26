package net.natpat.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.natpat.Assets;
	import net.natpat.GC;
	import net.natpat.GV;
	import net.natpat.Input;
	import net.natpat.Ship;
	import net.natpat.utils.Ease;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Upgrades implements IGuiElement 
	{
		
		public var up:Boolean;
		
		public var y:int;
		public var yBottom:int = GC.SCREEN_HEIGHT - 95;
		
		public var time:Number = 0;
		public var timeToOpen:Number = 1;
		
		public var open:Button;
		public var upgrade1:Button;
		public var upgrade2:Button;
		public var upgrade3:Button;
		public var upgrade4:Button;
		
		public var cost1Text:Text;
		public var cost2Text:Text;
		public var cost3Text:Text;
		public var cost4Text:Text;
		
		public var cost1:int = 200;
		public var cost2:int = 200;
		public var cost3:int = 200;
		public var cost4:int = 200;
		public var level1:int = 0;
		public var level2:int = 0;
		public var level3:int = 0;
		public var level4:int = 0;
		
		public var costOffsetX:int = 120;
		public var costOffsetY:int = 80;
		
		public var background:BitmapData;
		
		public function Upgrades() 
		{
			up = false;
			y = GC.SCREEN_HEIGHT;
			
			upgrade1 = new Button(new BitmapData(1, 1, true, 0), 135, 192, 260, 170, buyUpgrade1);
			upgrade2 = new Button(new BitmapData(1, 1, true, 0), 428, 182, 260, 170, buyUpgrade2);
			upgrade3 = new Button(new BitmapData(1, 1, true, 0), 141, 402, 260, 170, buyUpgrade3);
			upgrade4 = new Button(new BitmapData(1, 1, true, 0), 427, 403, 260, 170, buyUpgrade4);
			
			cost1Text = new Text(upgrade1.x + costOffsetX, 0, "" + cost1, 30, false, 0);
			cost2Text = new Text(upgrade2.x + costOffsetX, 0, "" + cost2, 30, false, 0);
			cost3Text = new Text(upgrade3.x + costOffsetX, 0, "" + cost3, 30, false, 0);
			cost4Text = new Text(upgrade4.x + costOffsetX, 0, "" + cost4, 30, false, 0);
			
			open = new Button(new BitmapData(1, 1, true, 0), 235, 10, 310, 90, changeState);
			
			background = Bitmap(new Assets.SHIPYARD).bitmapData;
			
		}
		
		/* INTERFACE net.natpat.gui.IGuiElement */
		
		public function render():void 
		{
			GV.screen.copyPixels(background, background.rect, new Point(0, y));
			cost1Text.render();
			cost2Text.render();
			cost3Text.render();
			cost4Text.render();
		}
		
		public function update():void 
		{
			open.update();
			if (up)
			{
				time += GV.elapsed;
				time = Math.min(time, timeToOpen);
				y = yBottom * (1 - Ease.bounceOut(time / timeToOpen));
				GV.onGUI = this; 
				upgrade1.update();
				upgrade2.update();
				upgrade3.update();
				upgrade4.update();
				cost1Text.update();
				cost2Text.update();
				cost3Text.update();
				cost4Text.update();
			}
			else
			{
				time += GV.elapsed;
				time = Math.min(time, timeToOpen);
				y = (yBottom) * (Ease.bounceOut(time / timeToOpen));
				if (time == timeToOpen / 0.6 && GV.onGUI == this)
				{
					GV.onGUI = null;
				}
			}
			upgrade1.y = y + 205;
			upgrade2.y = y + 205;
			upgrade3.y = y + 418;
			upgrade4.y = y + 418;
			cost1Text.y = upgrade1.y + costOffsetY;
			cost2Text.y = upgrade2.y + costOffsetY;
			cost3Text.y = upgrade3.y + costOffsetY;
			cost4Text.y = upgrade4.y + costOffsetY;
			open.y = y + 10;
		}
		
		public function add():void 
		{
			
		}
		
		public function remove():void 
		{
			
		}
		
		public function buyUpgrade1():void
		{
			trace("1");
			if (GV.gold >= cost1)
			{
				GV.spendGold(cost1, Input.mouseX, Input.mouseY);
				
				//DO UPGRADE 1 HERE
				GV.maxDistance+= 400;
				//UPDATE COST 1 HERE
				cost1 *= 1.5;
				
				level1++;
				cost1Text.text = "" + cost1;
			}
		}
		
		public function buyUpgrade2():void
		{
			if (GV.gold >= cost2)
			{
				GV.spendGold(cost2, Input.mouseX, Input.mouseY);
				
				//DO UPGRADE 2 HERE
				//UPDATE COST 2 HERE
				Ship.speed += 60;
				cost2 *= 1.5;
				
				level2++
				cost2Text.text = "" + cost2;
				if (level2 == 6)
				{
					cost2 = int.MAX_VALUE;
					cost2Text.text = "Full"
				}
			}
			
		}
		
		public function buyUpgrade3():void
		{
			if (GV.gold >= cost3)
			{
				GV.spendGold(cost3, Input.mouseX, Input.mouseY);
				
				//DO UPGRADE 3 HERE
				//UPDATE COST 3 HERE
				GV.goldMult*=2;
				cost3 *= 1.5;
				level3++
				cost3Text.text = "" + cost3;
				if (level3 == 6)
				{
					cost3 = int.MAX_VALUE;
					cost3Text.text = "Full"
				}
			}
			
		}
		
		public function buyUpgrade4():void
		{
			if (GV.gold >= cost4)
			{
				GV.spendGold(cost4, Input.mouseX, Input.mouseY);
				
				//DO UPGRADE 4 HERE
				//UPDATE COST 4 HERE
				GC.distToCostRatio *= 1.25;
				cost4 *= 1.5;
				level4++;
				cost4Text.text = "" + cost4;
				if (level4 == 6)
				{
					cost4 = int.MAX_VALUE;
					cost4Text.text = "Full"
				}
				
			}
			
		}
		
		public function changeState():void
		{
			time = 0;
			up = !up;
		}
		
	}

}