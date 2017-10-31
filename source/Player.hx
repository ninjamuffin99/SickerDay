package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite
{
	public var speed:Float = 60;
	private var interacting:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/SCWal_V3.png", true, 19, 38);
		animation.add("walk", [2, 3, 4, 5, 0, 1], 15, true);
		animation.add("idle", [1]);
		drag.x = drag.y = 1600;
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		movement();
		super.update(elapsed);
	}
	
	private function movement():Void
	{
		var _left:Bool = false;
		var _right:Bool = false;
		
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		
		if (_left && _right)
			_left = _right = false;
			
		if (_left)
		{
			velocity.x = -speed;
			facing = FlxObject.LEFT;
		}
		if (_right)
		{
			velocity.x = speed;
			facing = FlxObject.RIGHT;
		}
		if (velocity.x == 0)
		{
			animation.play("idle");
			
		}
		
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			switch (facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT :
					animation.play("walk");
			}
		}
	}
	
	
	/**
	 * 
	 * @param	object
	 * Which object it needs to be overlapping.
	 * @param	_objAnimOnly
	 * If only the object will be animated (If false then sets the player to invisible)
	 * @param	_animationON
	 * What animation to play when interacting
	 * @param	_animationOFF
	 * what animation to play when not interacting
	 * @param	sound
	 * @param	collision
	 * if player collides with object
	 * @param	objectOffset
	 * @param	Callback
	 * @param	CallbackFunc
	 * @param	callbackOnly
	 * Will not only trigger something if called back and not run code for real interactions
	 */
	
	public function interact(object:FlxSprite, _objAnimOnly:Bool,  _animationON:String = "", _animationOFF:String = "", sound:String = null, collision:Bool = false, objectOffset:Float = 0, Callback:Bool = false, CallbackFunc:Void->Void = null, callbackOnly:Bool = false):Void
	{
		if (collision)
		{
			object.immovable = true;
			FlxG.collide(this, object);
		}
		
		var _btnInteract:Bool = false;
		_btnInteract = FlxG.keys.anyJustPressed([SPACE, W, E, I, O, UP]);
		
		var _btnUninteract:Bool = false;
		_btnUninteract = FlxG.keys.anyPressed([LEFT, A, J, RIGHT, D, L]);
		
		
		if (FlxG.overlap(this, object))
		{
			
			if (_btnInteract && !interacting)
			{
				
				object.animation.play(_animationON);
				FlxG.sound.play(sound);
				
				if (Callback)
				{
					FlxG.log.add("Interaction Callback");
					CallbackFunc();
				}
				
				//change this so it calls a special function or something like sitdown if needed
				if (!_objAnimOnly)
				{
					visible = false;
					interacting = true;
				}
				//FlxG.sound.playMusic("assets/music/track1.mp3");
			}
			
			if (_btnUninteract && interacting)
			{
				object.animation.play(_animationOFF);
				interacting = false;
				visible = true;
			}
			
			if (interacting && !_objAnimOnly)
			{
				this.x = object.x + objectOffset;
			}
		}
		
	}
}