package net.natpat.utils 
{
	import net.natpat.GV;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Tween 
	{
		
		public static var tween:TweenObject = null;
		
		public static function newTween(name:String, length:Number, mult:Number = 1, offset:Number = 0, ease:Function = null, callback:Function = null):void
		{
			if (ease == null) ease = Ease.none;
			var newTween = new TweenObject(name, length, mult, offset, callback, ease);
			newTween.next = tween;
			newTween.prev = null;
			if (newTween.next) newTween.next.prev = newTween;
			tween = newTween;
		}
		
		public static function getTween(name:String):Number
		{
			var t:TweenObject = getTweenObject(name);
			if (t == null) return 0;
			return t.ease((t.time / t.length)) * t.mult + t.offset;
		}
		
		public static function setRepeatable(name:String, repeatable:Boolean):void
		{
			var t:TweenObject = getTweenObject(name);
			if (t == null) return;
			t.repeatabe = repeatable;
		}
		
		private static function getTweenObject(name:String):TweenObject
		{
			var t:TweenObject = tween;
			while (t != null && t.name != name)
			{
				t = t.next;
			}
			if(t == null) trace("Tried to get the tween " + name + " which doesn't exist!");
			return t;
		}
		
		public static function resetTween(name:String):void
		{
			var t:TweenObject = getTweenObject(name);
			if (t == null)
			{
				trace("Trying to reset a new tween!");
				newTween(name, 1);
				return;
			}
			t.time = 0;
			t.done = false;
		}
		
		public static function deleteTween(name:String):void
		{
			var t:TweenObject = getTweenObject(name);
			if (t == null) return;
			if (t.prev) t.prev.next = t.next;
			if (t.next) t.next.prev = t.prev;
			if (tween == t) tween = t.next;
		}
		
		public static function update():void
		{
			var t:TweenObject = tween;
			var elapsed:Number = GV.elapsed;
			while (t != null)
			{
				t.time += elapsed;
				if (t.repeatable)
				{
					while (t.time > t.length)
					{
						t.time -= t.length;
						t.callback();
					}
				}
				
				if (t.time >= t.length)
				{
					t.time = t.length;
					if(!t.done) t.callback();
					t.done = true;
				}
				t = t.next;
			}
		}

	}

}

internal class TweenObject
{
	public var name:String;
	public var time:Number = 0;
	public var length:Number;
	public var callback:Function;
	public var mult:Number;
	public var offset:Number;
	public var ease:Function;
	public var next:TweenObject;
	public var prev:TweenObject;
	public var done:Boolean;
	public var repeatable:Boolean = false;
	
	public function TweenObject(name:String, length:Number, mult:Number = 1, offset:Number = 0, callback:Function = null, ease:Function = null)
	{
		this.name = name;
		this.length = length;
		this.callback = callback;
		this.ease = ease;
		this.mult = mult;
		this.offset = offset;
		done = false;
	}
}