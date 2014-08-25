package net.natpat {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.natpat.gui.Button;
	import net.natpat.gui.Dialog;
	import net.natpat.gui.DialogOk;
	import net.natpat.GoldShip;
	import net.natpat.gui.GoldMinus;
	import net.natpat.gui.Help;
	import net.natpat.gui.InputBox;
	import net.natpat.gui.PortGui;
	import net.natpat.gui.Upgrades;
	import net.natpat.particles.Emitter;
	import net.natpat.utils.Sfx;
	
	import net.natpat.gui.Text;
	import net.natpat.gui.GuiManager
	import net.natpat.utils.Ease;
	import net.natpat.utils.Key;
	
	import net.natpat.utils.WaypointConnection;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GameManager 
	{
		
		/**
		 * Bitmap and bitmap data to be drawn to the screen.
		 */
		public var bitmap:Bitmap;
		public static var renderer:BitmapData;
		
		public var map:Map;
		public var mapBD:BitmapData;
		public var scaleBD:BitmapData;
		public var objBD:BitmapData;
		
		public var wm:WaypointManager;
		
		public var pathGraphic:Shape;
		public var mouseLine:Shape;
		
		public var oldLength:int = 0;
		
		public var curvePoint:Point;
		
		public var sm:ShipManager;
		
		public var gold:Text;
		
		public var routeStarted:Boolean = false;
		
		public var costText:Text;
		public var distanceText:Text;
		
		public var dialogUp:Boolean = false;
		
		public var lineColour:uint = 0x34a1e0;
		
		public var UIImage:BitmapData;
		public var upgrades:Upgrades;
		
		public var clickAndDrag:BitmapData = Bitmap(new Assets.CAD).bitmapData
		public var cady:int;
		public var cadx:int;
		
		public var helpButton:Button;
		
		public var gad:BitmapData;
		
		public var musics:Vector.<Sfx>
		
		public var currentMusic:int = 3;
		
		public function GameManager(stageWidth:int, stageHeight:int) 
		{
			
			GC.SCREEN_WIDTH = stageWidth;
			GC.SCREEN_HEIGHT = stageHeight;
			
			renderer = new BitmapData(stageWidth, stageHeight, false, 0x000000);
			
			bitmap = new Bitmap(renderer);
			
			map = new Map();
			
			mapBD = new BitmapData(GC.SCREEN_WIDTH * GC.MAX_ZOOM, GC.SCREEN_HEIGHT * GC.MAX_ZOOM, true, 0);
			scaleBD = new BitmapData(GC.SCREEN_WIDTH * GC.MAX_ZOOM, GC.SCREEN_HEIGHT * GC.MAX_ZOOM, true, 0);
			objBD = new BitmapData(GC.SCREEN_WIDTH, GC.SCREEN_HEIGHT, true, 0);
			
			GV.screen = renderer;
			
			wm = new WaypointManager(objBD);
			
			{
				wm.addOldPos(new Waypoint(7490, 2090));
				wm.addOldPos(new Waypoint(7700, 1872));
				wm.addOldPos(new Waypoint(7446, 2312));
				wm.addOldPos(new Waypoint(7369, 2469));
				wm.addOldPos(new Waypoint(7494, 2597));
				wm.addOldPos(new Waypoint(7498, 2742));
				wm.addOldPos(new Waypoint(7626, 2770));
				wm.addOldPos(new Waypoint(7367, 2845));
				wm.addOldPos(new Waypoint(7289, 3006));
				wm.addOldPos(new Waypoint(7909, 2788));
				wm.addOldPos(new Waypoint(8086, 2891));
				wm.addOldPos(new Waypoint(8150, 2749));
				wm.addOldPos(new Waypoint(8307, 2521));
				wm.addOldPos(new Waypoint(8440, 2440));
				wm.addOldPos(new Waypoint(8435, 2714));
				wm.addOldPos(new Waypoint(8208, 2882));
				wm.addOldPos(new Waypoint(8451, 2845));
				wm.addOldPos(new Waypoint(8477, 3088));
				wm.addOldPos(new Waypoint(8673, 2943));
				wm.addOldPos(new Waypoint(8751, 3097));
				wm.addOldPos(new Waypoint(8953, 3058));
				wm.addOldPos(new Waypoint(8960, 2867));
				wm.addOldPos(new Waypoint(9018, 2648));
				wm.addOldPos(new Waypoint(9137, 3032));
				wm.addOldPos(new Waypoint(9209, 3099));
				wm.addOldPos(new Waypoint(9282, 2993));
				wm.addOldPos(new Waypoint(9393, 3106));
				wm.addOldPos(new Waypoint(9464, 2759));
				wm.addOldPos(new Waypoint(8914, 2487));
				wm.addOldPos(new Waypoint(9409, 2931));
				wm.addOldPos(new Waypoint(7884, 1906));
				wm.addOldPos(new Waypoint(8130, 1821));
				wm.addOldPos(new Waypoint(8277, 1763));
				wm.addOldPos(new Waypoint(8332, 1586));
				wm.addOldPos(new Waypoint(7095, 3151));
				wm.addOldPos(new Waypoint(7014, 3315));
				wm.addOldPos(new Waypoint(7014, 3447));
				wm.addOldPos(new Waypoint(6913, 3606));
				wm.addOldPos(new Waypoint(6908, 3707));
				wm.addOldPos(new Waypoint(6920, 3851));
				wm.addOldPos(new Waypoint(6853, 4018));
				wm.addOldPos(new Waypoint(6913, 4184));
				wm.addOldPos(new Waypoint(6987, 4322));
				wm.addOldPos(new Waypoint(7066, 4484));
				wm.addOldPos(new Waypoint(7343, 4609));
				wm.addOldPos(new Waypoint(7614, 4604));
				wm.addOldPos(new Waypoint(7872, 4524));
				wm.addOldPos(new Waypoint(6809, 3442));
				wm.addOldPos(new Waypoint(6997, 3978));
				wm.addOldPos(new Waypoint(6777, 4310));
				wm.addOldPos(new Waypoint(6855, 4482));
				wm.addOldPos(new Waypoint(7133, 4723));
				wm.addOldPos(new Waypoint(7545, 4800));
				wm.addOldPos(new Waypoint(7846, 4784));
				wm.addOldPos(new Waypoint(8056, 4933));
				wm.addOldPos(new Waypoint(7894, 5127));
				wm.addOldPos(new Waypoint(7906, 5210));
				wm.addOldPos(new Waypoint(8053, 5471));
				wm.addOldPos(new Waypoint(7979, 5649));
				wm.addOldPos(new Waypoint(8181, 5642));
				wm.addOldPos(new Waypoint(8281, 5860));
				wm.addOldPos(new Waypoint(8111, 5967));
				wm.addOldPos(new Waypoint(8271, 6260));
				wm.addOldPos(new Waypoint(7192, 2573));
				wm.addOldPos(new Waypoint(8302, 6100));
				wm.addOldPos(new Waypoint(8438, 6401));
				wm.addOldPos(new Waypoint(7185, 2876));
				wm.addOldPos(new Waypoint(7725, 4967));
				wm.addOldPos(new Waypoint(8399, 1388));
				wm.addOldPos(new Waypoint(8552, 1513));
				wm.addOldPos(new Waypoint(8706, 1674));
				wm.addOldPos(new Waypoint(8875, 1674));
				wm.addOldPos(new Waypoint(8906, 1538));
				wm.addOldPos(new Waypoint(9031, 1580));
				wm.addOldPos(new Waypoint(9020, 1424));
				wm.addOldPos(new Waypoint(7800, 1453));
				wm.addOldPos(new Waypoint(7669, 1264));
				wm.addOldPos(new Waypoint(7722, 1103));
				wm.addOldPos(new Waypoint(7852, 940));
				wm.addOldPos(new Waypoint(7991, 992));
				wm.addOldPos(new Waypoint(8246, 964));
				wm.addOldPos(new Waypoint(8274, 1225));
				wm.addOldPos(new Waypoint(8407, 915));
				wm.addOldPos(new Waypoint(7414, 1203));
				wm.addOldPos(new Waypoint(7283, 1055));
				wm.addOldPos(new Waypoint(6997, 1103));
				wm.addOldPos(new Waypoint(7036, 1420));
				wm.addOldPos(new Waypoint(6840, 1251));
				wm.addOldPos(new Waypoint(6553, 1307));
				wm.addOldPos(new Waypoint(6328, 1494));
				wm.addOldPos(new Waypoint(6028, 1451));
				wm.addOldPos(new Waypoint(6705, 1439));
				wm.addOldPos(new Waypoint(7149, 1250));
				wm.addOldPos(new Waypoint(7317, 1486));
				wm.addOldPos(new Waypoint(7295, 1847));
				wm.addOldPos(new Waypoint(5670, 1309));
				wm.addOldPos(new Waypoint(5423, 1473));
				wm.addOldPos(new Waypoint(5057, 1423));
				wm.addOldPos(new Waypoint(4810, 1226));
				wm.addOldPos(new Waypoint(4760, 1537));
				wm.addOldPos(new Waypoint(4375, 1437));
				wm.addOldPos(new Waypoint(4035, 1350));
				wm.addOldPos(new Waypoint(3780, 1789));
				wm.addOldPos(new Waypoint(4137, 1538));
				wm.addOldPos(new Waypoint(4537, 1688));
				wm.addOldPos(new Waypoint(3435, 1937));
				wm.addOldPos(new Waypoint(4159, 1769));
				wm.addOldPos(new Waypoint(3376, 2126));
				wm.addOldPos(new Waypoint(3670, 2156));
				wm.addOldPos(new Waypoint(3048, 2619));
				wm.addOldPos(new Waypoint(2875, 2707));
				wm.addOldPos(new Waypoint(2547, 2602));
				wm.addOldPos(new Waypoint(2450, 2997));
				wm.addOldPos(new Waypoint(2227, 3136));
				wm.addOldPos(new Waypoint(3305, 2444));
				wm.addOldPos(new Waypoint(3299, 2807));
				wm.addOldPos(new Waypoint(3024, 3148));
				wm.addOldPos(new Waypoint(3387, 3131));
				wm.addOldPos(new Waypoint(3530, 3390));
				wm.addOldPos(new Waypoint(3580, 3038));
				wm.addOldPos(new Waypoint(3772, 3357));
				wm.addOldPos(new Waypoint(3613, 2812));
				wm.addOldPos(new Waypoint(4135, 3456));
				wm.addOldPos(new Waypoint(2709, 3031));
				wm.addOldPos(new Waypoint(3632, 2430));
				wm.addOldPos(new Waypoint(2383, 2789));
				wm.addOldPos(new Waypoint(4219, 3771));
				wm.addOldPos(new Waypoint(4396, 4040));
				wm.addOldPos(new Waypoint(4235, 4300));
				wm.addOldPos(new Waypoint(4048, 4564));
				wm.addOldPos(new Waypoint(3981, 4958));
				wm.addOldPos(new Waypoint(3711, 5093));
				wm.addOldPos(new Waypoint(3149, 2269));
				wm.addOldPos(new Waypoint(3521, 2612));
				wm.addOldPos(new Waypoint(3850, 1984));
				wm.addOldPos(new Waypoint(4435, 1215));
				wm.addOldPos(new Waypoint(4348, 1906));
				wm.addOldPos(new Waypoint(3908, 3153));
				wm.addOldPos(new Waypoint(3202, 3385));
				wm.addOldPos(new Waypoint(4454, 3825));
				wm.addOldPos(new Waypoint(3864, 4784));
				wm.addOldPos(new Waypoint(3864, 5234));
				wm.addOldPos(new Waypoint(3989, 4412));
				wm.addOldPos(new Waypoint(4239, 4501));
				wm.addOldPos(new Waypoint(3409, 5077));
				wm.addOldPos(new Waypoint(3502, 5278));
				wm.addOldPos(new Waypoint(3152, 5572));
				wm.addOldPos(new Waypoint(3164, 5805));
				wm.addOldPos(new Waypoint(3067, 5938));
				wm.addOldPos(new Waypoint(3196, 6119));
				wm.addOldPos(new Waypoint(3401, 6268));
				wm.addOldPos(new Waypoint(3635, 6260));
				wm.addOldPos(new Waypoint(3792, 6071));
				wm.addOldPos(new Waypoint(3619, 5874));
				wm.addOldPos(new Waypoint(3333, 5833));
				wm.addOldPos(new Waypoint(2963, 5757));
				wm.addOldPos(new Waypoint(3655, 5523));
				wm.addOldPos(new Waypoint(4070, 4771));
				wm.addOldPos(new Waypoint(2432, 2456));
				wm.addOldPos(new Waypoint(3257, 5352));
				wm.addOldPos(new Waypoint(3404, 5603));
				wm.addOldPos(new Waypoint(3776, 5740));
				wm.addOldPos(new Waypoint(3902, 5412));
				wm.addOldPos(new Waypoint(3207, 6386));
				wm.addOldPos(new Waypoint(3503, 6451));
				wm.addOldPos(new Waypoint(3891, 6238));
				wm.addOldPos(new Waypoint(3875, 5795));
				wm.addOldPos(new Waypoint(3232, 3220));
				wm.addOldPos(new Waypoint(4102, 2105));
				wm.addOldPos(new Waypoint(3850, 2340));
				wm.addOldPos(new Waypoint(3932, 2691));
				wm.addOldPos(new Waypoint(3817, 2909));
				wm.addOldPos(new Waypoint(5092, 1582));
				wm.addOldPos(new Waypoint(5716, 1587));
				wm.addOldPos(new Waypoint(3586, 3207));
				wm.addOldPos(new Waypoint(3917, 3451));
				wm.addOldPos(new Waypoint(4100, 3207));
				wm.addOldPos(new Waypoint(4075, 3639));
				wm.addOldPos(new Waypoint(4324, 3619));
				
				
				wm.addOldPos(new Port(7965, 1650, "Bristol"));
				wm.addOldPos(new Port(7724, 1594, "Dublin"));
				wm.addOldPos(new Port(8069, 1934, "Calais"));
				wm.addOldPos(new Port(7784, 2234, "Bayonne"));
				wm.addOldPos(new Port(8405, 1749, "Rotterdam"));
				wm.addOldPos(new Port(7603, 2300, "Santander"));
				wm.addOldPos(new Port(7733, 2697, "Gibraltar")); 
				wm.addOldPos(new Port(3762, 1525, "Quebec City"));
				wm.addOldPos(new Port(2673, 2301, "Carabelle"));
				wm.addOldPos(new Port(3214, 1985, "Richmond"));
				wm.addOldPos(new Port(2690, 2788, "Havana"));
				wm.addOldPos(new Port(2367, 3319, "Cartagena"));
				wm.addOldPos(new Port(2751, 3292, "Caracas"));
				wm.addOldPos(new Port(3862, 3677, "Fortaleza"));
				wm.addOldPos(new Port(4004, 4177, "Salvador"));
				wm.addOldPos(new Port(3559, 4921, "Rio de Janeiro"));
				wm.addOldPos(new Port(6118, 1234, "Reykjavik"));
				wm.addOldPos(new Port(3069, 5421, "Buenos Aires"));
				wm.addOldPos(new Port(3218, 5166, "Porto Allegre"));
				wm.addOldPos(new Port(2958, 6065, "Rio Gallegos"));
				wm.addOldPos(new Port(3600, 6064, "Stanley"));
				wm.addOldPos(new Port(3461, 1737, "Boston"));
				wm.addOldPos(new Port(3067, 2938, "San Juan"));
				wm.addOldPos(new Port(7042, 4129, "Dakar"));
				wm.addOldPos(new Port(7177, 4360, "Freetown"));
				wm.addOldPos(new Port(8023, 4399, "Lagos"));
				wm.addOldPos(new Port(8141, 5218, "Port Gentil"));
				wm.addOldPos(new Port(8380, 5717, "Luanda"));
				wm.addOldPos(new Port(8502, 6273, "Cape Town"));
				wm.addOldPos(new Port(8625, 2664, "Naples"));
				wm.addOldPos(new Port(7914, 2929, "Algiers"));
				wm.addOldPos(new Port(8280, 3029, "Tunis"));
				wm.addOldPos(new Port(9615, 3125, "Beirut"));
				wm.addOldPos(new Port(9017, 3231, "Alexandria"));
				wm.addOldPos(new Port(9357, 2842, "Athens"));
				wm.addOldPos(new Port(9422, 2587, "Thessaloniki"));
				wm.addOldPos(new Port(9071, 2428, "Split"));
				wm.addOldPos(new Port(7475, 2980, "Casablanca"));
				wm.addOldPos(new Port(8194, 2419, "Barcelona"));
				wm.addOldPos(new Port(8611, 1326, "Oslo"));
				wm.addOldPos(new Port(8739, 1576, "Gothenburg"));
				wm.addOldPos(new Port(9288, 1555, "Saint Petersburg"));
				wm.addOldPos(new Port(9067, 1707, "Tallinn"));
				wm.addOldPos(new Port(8489, 1104, "Bergen"));
				wm.addOldPos(new Waypoint(7800, 1710));
				wm.addOldPos(new Waypoint(7153, 1624));
				wm.addOldPos(new Waypoint(7469, 1916));
			}

			
			wm.addAtlanticPoints();
			
			{
				wm.add(new Waypoint(2963, 962));
				wm.add(new Waypoint(3104, 1006));
				wm.add(new Waypoint(2980, 1409));
				wm.add(new Waypoint(2901, 1359));
				wm.add(new Waypoint(3033, 1305));
				wm.add(new Waypoint(2888, 1228));
				wm.add(new Waypoint(3025, 1155));
				wm.add(new Waypoint(2947, 1055));
				wm.add(new Waypoint(3024, 1076));
				wm.add(new Waypoint(3185, 912));
				wm.add(new Waypoint(3064, 938));
				wm.add(new Waypoint(3068, 859));
				wm.add(new Waypoint(3058, 777));
				wm.add(new Waypoint(2972, 883));
				wm.add(new Waypoint(2899, 820));
				wm.add(new Waypoint(2944, 732));
				wm.add(new Waypoint(2836, 705));
				wm.add(new Waypoint(2814, 818));
				wm.add(new Waypoint(2715, 756));
				wm.add(new Waypoint(2584, 778));
				wm.add(new Waypoint(2470, 810));
				wm.add(new Waypoint(2365, 766));
				wm.add(new Waypoint(2267, 826));
				wm.add(new Waypoint(2106, 785));
				wm.add(new Waypoint(1936, 921));
				wm.add(new Waypoint(1915, 1028));
				wm.add(new Waypoint(1775, 1009));
				wm.add(new Waypoint(2435, 1325));
				wm.add(new Waypoint(2405, 1477));
				wm.add(new Waypoint(1793, 1101));
				wm.add(new Waypoint(1915, 1202));
				wm.add(new Waypoint(1763, 1273));
				wm.add(new Waypoint(1878, 1326));
				wm.add(new Waypoint(1945, 1418));
				wm.add(new Waypoint(1890, 1478));
				wm.add(new Waypoint(1991, 1540));
				wm.add(new Waypoint(1923, 2076));
				wm.add(new Waypoint(1817, 2216));
				wm.add(new Waypoint(1907, 2341));
				wm.add(new Waypoint(1777, 2422));
				wm.add(new Waypoint(1896, 2500));
				wm.add(new Waypoint(1798, 2614));
				wm.add(new Waypoint(1885, 2673));
				wm.add(new Waypoint(1850, 2779));
				wm.add(new Waypoint(2223, 2744));
				wm.add(new Waypoint(2915, 2097));
				wm.add(new Waypoint(3075, 2187));
				wm.add(new Waypoint(3237, 2231));
				wm.add(new Waypoint(3006, 2309));
				wm.add(new Waypoint(3159, 2431));
				wm.add(new Waypoint(3356, 2415));
				wm.add(new Waypoint(3140, 2603));
				wm.add(new Waypoint(2947, 2593));
				wm.add(new Waypoint(3065, 2690));
				wm.add(new Waypoint(3003, 2425));
				wm.add(new Waypoint(3244, 2326));
				wm.add(new Waypoint(3370, 2534));
				wm.add(new Waypoint(3249, 2619));
				wm.add(new Waypoint(3035, 2524));
				wm.add(new Waypoint(3449, 2690));
				wm.add(new Waypoint(3322, 2750));
				wm.add(new Waypoint(3499, 2789));
				
			}
			
			wm.connectWaypoints();
			
			sm = new ShipManager(scaleBD, objBD);
			
			pathGraphic = new Shape();
			pathGraphic.graphics.lineStyle(1, 0, 1);
			
			mouseLine = new Shape();
			mouseLine.graphics.lineStyle(1, 0, 1);
			
			GV.camera.x = 3500;
			GV.camera.y = 800;
			
			GV.zoom = 2.3;
			
			gold = new Text(GC.SCREEN_WIDTH- 150, GC.SCREEN_HEIGHT - 50, "0", 25, false, 0);
			GuiManager.add(gold);
			gold.y = GC.SCREEN_HEIGHT - gold.height;
			
			costText = new Text(-100, -100, "0", 14);
			GuiManager.add(costText);
			distanceText = new Text(-100, -100, "0", 14);
			GuiManager.add(distanceText);
			
			
			UIImage = Bitmap(new Assets.UI).bitmapData;
			upgrades = new Upgrades();
			GuiManager.add(new Upgrades);
			
			cady = clickAndDrag.height * -1;
			cadx = (GC.SCREEN_WIDTH - clickAndDrag.width) / 2
			
			helpButton = new Button(Bitmap(new Assets.HELPBUTTON).bitmapData, GC.SCREEN_WIDTH - 60, 10, 50, 50, helpUp, 0 );
			GuiManager.add(helpButton);
			
			GuiManager.add(new Help);
			
			gad = Bitmap(new Assets.ROUTE_DATA).bitmapData;
			
			musics = new Vector.<Sfx>(4);
			
			musics[0] = new Sfx(Assets.MUSIC1, false, playSoundtrack);
			musics[1] = new Sfx(Assets.MUSIC2, false, playSoundtrack);
			musics[2] = new Sfx(Assets.MUSIC3, false, playSoundtrack);
			musics[3] = new Sfx(Assets.MUSIC4, false, playSoundtrack);
			
			musics[currentMusic].play();
			
			Sfx.addSfxs();
		}
		
		public function helpUp():void
		{
			GuiManager.add(new Help);
		}
		
		public function render():void
		{
			renderer.lock();
			
			//Render the background
			renderer.fillRect(new Rectangle(0, 0, renderer.width, renderer.height), 0x68c8ff);
			scaleBD.fillRect(scaleBD.rect, 0);
			objBD.fillRect(objBD.rect, 0);
			
			map.render(mapBD);
			
			m = new Matrix();
			m.translate( -GV.camera.x + (GC.SCREEN_WIDTH * GV.zoom / 2), - GV.camera.y + (GC.SCREEN_HEIGHT * GV.zoom / 2));
			scaleBD.draw(pathGraphic, m);
			scaleBD.draw(mouseLine, m);
			
			if (GV.debuggingConnections)
			{
				WaypointConnection.s.graphics.clear();
				WaypointConnection.s.graphics.lineStyle(1, 0, 0.2);
			}
			
			wm.render();
			
			sm.render();
			
			m = new Matrix();
			m.translate( -GV.camera.x + (GC.SCREEN_WIDTH * GV.zoom / 2), - GV.camera.y + (GC.SCREEN_HEIGHT * GV.zoom / 2));
			
			if(GV.debuggingConnections)
			{
				scaleBD.draw(WaypointConnection.s, m);
			}
			
			var m:Matrix = new Matrix();
			m.scale(1 / GV.zoom, 1 / GV.zoom);
			renderer.draw(mapBD, m);
			renderer.draw(scaleBD, m);
			renderer.draw(objBD);
			
			if (GV.makingRoute && Input.mouseDown)
			{
				renderer.copyPixels(gad, gad.rect, new Point(Input.mouseX - 45, Input.mouseY - 95)); 
			}
			
			renderer.copyPixels(UIImage, UIImage.rect, new Point(0, GC.SCREEN_HEIGHT - UIImage.height));
			
			renderer.copyPixels(clickAndDrag, clickAndDrag.rect, new Point(cadx, cady));
			
			GuiManager.render();
			
			renderer.unlock();
		}
		
		public function update():void
		{
			
			GuiManager.update();
			
			wm.update();
			
			if (GV.makingRoute)
			{
				
				cady += 150 * GV.elapsed;
				cady = Math.min(0, cady);
				
				if (oldLength < GV.currentRoute.length)
				{
					GV.routeDistance+= GV.currentRoute[oldLength].distance;
					drawLine(GV.currentRoute[oldLength]);
					oldLength = GV.currentRoute.length;
				}
				else if (oldLength > GV.currentRoute.length)
				{
					pathGraphic.graphics.clear();
					GV.routeDistance = 0;
					for each(var wc:WaypointConnection in GV.currentRoute)
					{
						GV.routeDistance += wc.distance;
						drawLine(wc);
					}
					oldLength = GV.currentRoute.length;
				}
				
				mouseLine.graphics.clear();
				if (Input.mouseDown)
				{
					mouseLine.graphics.lineStyle(15, lineColour, 0.6);
					mouseLine.graphics.moveTo(Waypoint.selected.x, Waypoint.selected.y);
					mouseLine.graphics.lineTo(GV.mouseX, GV.mouseY);
					var length:int = Math.sqrt((Waypoint.selected.x - GV.mouseX) * (Waypoint.selected.x - GV.mouseX)
					                         + (Waypoint.selected.y - GV.mouseY) * (Waypoint.selected.y - GV.mouseY));
					var cost:int = GV.routeCost + length  / GC.DIST_TO_COST_RATIO * ((GV.redShip == null) ? 1 : 0);
					if (cost > GV.gold)
					{
						costText.colour = 0xff0000;
					}
					else
					{
						costText.colour = 0;
					}
					var totalLength:int = GV.routeDistance + length;
					if (totalLength > GV.maxDistance)
					{
						distanceText.colour = 0xff0000;
					}
					else
					{
						distanceText.colour = 0;
					}
					costText.text = "" + cost;
					distanceText.text = "" + totalLength;
					costText.x = Input.mouseX - 3;
					costText.y = Input.mouseY - 77;
					distanceText.x = Input.mouseX - 3;
					distanceText.y = Input.mouseY - 62;
				}
				if (Input.mouseReleased)
				{
					//if (routeStarted)
					{
						if (GV.redShip == null)
						{
							GV.makingRoute = false;
							if (!(Waypoint.selected is Port))
							{
								clearRoute();
							}
						}
						else
						{
							GV.makingRoute = false;
						}
					}
					routeStarted = !routeStarted;
				}
			}
			else
			{
				cady -= 150 * GV.elapsed;
				cady = Math.max( -clickAndDrag.height, cady);
				if (GV.currentRoute.length != 0 && !dialogUp)
				{
					oldLength = oldLength - 1;
					
					dialogUp = true;
					
					if (GV.routeCost <= GV.gold && GV.routeDistance <= GV.maxDistance)
					{
						if (GV.routeForReplace)
						{
							GuiManager.add(new Dialog(addReplaceShip, clearRoute, "Are you sure you want to change the ship's\ndestination from " +
 																				  GV.routePort.ships[GV.routeIndex].route.to.name + " to " + Port(GV.currentRoute[oldLength].to).name 
																				  + " when it next returns?\n" +
																				  "It will cost " + GV.routeCost + " gold.", 16));
						}
						else if (GV.goldShip)
						{
							GuiManager.add(new Dialog(addShip, clearRoute , "Send a ship to discover the port of\n" + Port(GV.currentRoute[oldLength].to).name + "?" +
																	" It will cost " + GV.routeCost + " gold.", 16));
						}
						else if (GV.redShip != null)
						{
							if (GV.redShipAdded)
							{
								addRedShip();
								if (Waypoint.selected is Port)
								{
									GuiManager.add(new DialogOk(null, "Privateers can't go\ninto ports!", 18));
								}
							}
							else
							{
								if (Waypoint.selected is Port)
								{
									GV.currentRoute.pop();
								}
								GuiManager.add(new Dialog(addRedShip, clearRoute , "Send out a privateer into the ocean?\n" +
																		" It will cost " + GV.routeCost + " gold.", 16));
							}
						}
						else
						{
							GuiManager.add(new Dialog(addShip, clearRoute , "Set up a trade route between\n" + GV.routePort.name + " and " + Port(GV.currentRoute[oldLength].to).name + "?\n" +
																	"It will cost " + GV.routeCost + " gold.", 16));
						}
					}
					else
					{
						var tooFar:Boolean = GV.routeDistance > GV.maxDistance;
						var error:String = (tooFar? "It's too far away!" : "You don't have the gold!")
						if (GV.goldShip)
						{
							GuiManager.add(new DialogOk(clearRoute , "You can't send an explorer to " + Port(GV.currentRoute[oldLength].to).name +
																			"!\n" + error, 16));
						}
						else if (GV.redShip != null)
						{
							GuiManager.add(new DialogOk(clearRoute , "You can't send out a privateer!" +
																			"\n" + error, 16));
						}
						else
						{
							GuiManager.add(new DialogOk(clearRoute , "You can't make a trade route from\n" + GV.routePort.name + " to " + Port(GV.currentRoute[oldLength].to).name +
																			"!\n" + error, 16));
						}
					}
					
				}
				
				mouseLine.graphics.clear();
				routeStarted = false;
			}
			
			sm.update();
			
			if (Input.keyDown(Key.LEFT) || Input.mouseX < GC.SCROLL_BORDER)
			{
				GV.camera.x -= GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.RIGHT) || Input.mouseX > GC.SCREEN_WIDTH - GC.SCROLL_BORDER)
			{
				GV.camera.x += GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.UP) || Input.mouseY < GC.SCROLL_BORDER)
			{
				GV.camera.y -= GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.DOWN) || Input.mouseY > GC.SCREEN_HEIGHT - GC.SCROLL_BORDER)
			{
				GV.camera.y += GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.Q))
			{
				GV.zoomOut();
			}
			
			if (Input.keyDown(Key.A))
			{
				GV.zoomIn();
			}
			
			GV.camera.x = Math.max(GC.SCREEN_WIDTH * GV.zoom / 2, Math.min(7000 - GC.SCREEN_WIDTH * GV.zoom / 2, GV.camera.x));
			GV.camera.y = Math.max(GC.SCREEN_HEIGHT * GV.zoom / 2, Math.min(3130 - GC.SCREEN_HEIGHT * GV.zoom / 2, GV.camera.y));
			
			gold.text = "" + GV.gold;
			
			gold.x = GC.SCREEN_WIDTH - gold.width - 10;
			
			//trace(GV.mouseX, GV.mouseY);
			
			Input.update();
		}
		
		public function addShip():void
		{
			GV.spendGold(GV.routeCost, GV.mouseX, GV.mouseY);
			var s:Ship = GV.goldShip ? new GoldShip(new Route(GV.currentRoute, pathGraphic, GV.routeDistance), GV.goldShipCost) :  new Ship(new Route(GV.currentRoute, pathGraphic, GV.routeDistance));
			sm.addShip(s, GV.routePort, GV.routeIndex);
			clearRoute();
		}
		
		public function addReplaceShip():void
		{
			GV.spendGold(GV.routeCost, Input.mouseX, Input.mouseY);
			var s:Ship = new Ship(new Route(GV.currentRoute, pathGraphic, GV.routeDistance));
			GV.routePort.newShips[GV.routeIndex] = s;
			clearRoute();
		}
		
		public function drawLine(wc:WaypointConnection):void
		{
			pathGraphic.graphics.lineStyle(15, lineColour, 0.5);
			pathGraphic.graphics.moveTo(wc.from.x, wc.from.y);
			pathGraphic.graphics.lineTo(wc.to.x, wc.to.y);
		}
		
		public function clearRoute():void
		{
			GV.routeForReplace = false;
			dialogUp = false;
			pathGraphic = new Shape();
			GV.currentRoute = new Vector.<WaypointConnection>();
			Waypoint.selected = null;
			
			costText.x = -100;
			costText.y = -100;
			distanceText.x = -100;
			distanceText.y = -100;
			
			GV.goldShip = false;
			GV.redShip = null;
			GV.routeDistance = 0;
			
		}
		
		public function addRedShip():void
		{
			if (GV.currentRoute.length != 0)
			{
				GV.spendGold(GV.routeCost, GV.mouseX, GV.mouseY);
				GV.redShip.route = new Route(GV.currentRoute, new Shape(), GV.routeDistance);
				if (GV.redShip.sm == null)
				{
					sm.addShip(GV.redShip, null, -1);
					GV.redShip.sm = sm;
					GV.redShipNo++;
				}
				GV.redShip.started();
			}
			GV.redShip = null;
			clearRoute();
		}
	
		public function playSoundtrack():void
		{
			var next:int;
			do {
				next = GV.rand(4);
			} while (next == currentMusic);
			musics[next].play();
			currentMusic = next;
		}
	}

}