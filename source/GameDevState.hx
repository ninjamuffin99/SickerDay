package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;

/**
 * ...
 * @author ninjaMuffin
 */
class GameDevState extends FlxState 
{
	private var _progress:Float = 0;
	private var _progressBar:FlxBar;
	private var _delayCheck:Bool = false;
	
	private var _NGRadio:FlxSound;
	
	override public function create():Void 
	{
		createRadio();
		
		_progressBar = new FlxBar(10, 10, LEFT_TO_RIGHT, 100, 25, this, "_progress", 0, 100, true);
		add(_progressBar);
		
		super.create();
	}
	
	private function createRadio():Void
	{
		_NGRadio = new FlxSound();
		
		_NGRadio.play();
		
		_NGRadio.loadStream("http://radio-stream01.ungrounded.net/easylistening", false, false);
		_NGRadio.play();
		_NGRadio.volume = 0;
		_NGRadio.fadeIn(10, 0, 0.25);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		FlxG.watch.addQuick("Progress:", _progress);
		
		if (FlxG.keys.justPressed.ANY)
		{
			_progress += 0.05;
			FlxG.sound.play("assets/sounds/keyClickOn" + FlxG.random.int(1, 4) + ".mp3");
		}
		if (FlxG.keys.justReleased.ANY)
		{
			FlxG.sound.play("assets/sounds/keyClickRelease" + FlxG.random.int(1, 4) + ".mp3");
		}
		
		if (FlxG.keys.justPressed.ONE)
		{
			_progress = 89;
			_delayCheck = false;
		}
		
		if (_progress >= 90 && !_delayCheck)
		{
			if (FlxG.random.bool(15))
			{
				var rndDelay:Float = FlxG.random.float(10, 40);
				_progress -= rndDelay;
				FlxG.log.add("DELAYED" + rndDelay);
			}
			else
			{
				FlxG.log.add("not delayed");
			}
			_delayCheck = true;
		}
		
	}
	
	
}