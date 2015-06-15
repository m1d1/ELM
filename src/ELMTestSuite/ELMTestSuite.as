package  {
	/* ELM TestSuite 0.12 
	 *(for ELM v1.50+ only!!!)
	 *
	 * version: 0.12 May 20th 2011  
	 * version: 0.10 May 9th 2011  
	 * requires: ELM 1.50 alpha 3 or later
	 * author: M. Dinkelaker - ilabor[at]gmail[dot]com
	
	 * purpose:
	 * 		test functionality of ELM's features. (ELM feature testing | bug finding)
	 *
	 * rel.notes:
	 *		all tests are implemented in "command-pattern" style using iterators.	 
	 *		(ProtectedTest is an exception, which needs to run at last)
	 *
	 * to-do: 
	 *		- test bindings, ELM iterator (last modified objects)
	 *		- less chaotic tests
	 *		- prettier text
	 *		- ...
	 *	 
	 **/
	

	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	import util.elm.bindings.MouseBindings;
	import tests.TestController;
	import tests.ELMTestEvent;
	
	import flash.text.TextField;	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[SWF (width="500", height = "400", backgroundColor="0x323232", frameRate="30")]
			
	public class ELMTestSuite extends MovieClip {
		public const VERSION:String = "0.13";
		public const AMOUNT:int = 1000;
		const SLP_TIME:int = 50;
		var _container:Array;
		var _counter:int;
		var testController:TestController;
		var timer:Timer;
		public var iterator:ELMIterator;
		var time:Number;
		var tf:TextField;


		public function ELMTestSuite() {
			// constructor code
			tf = new TextField();
			tf.defaultTextFormat = new TextFormat("_sans", "10", 0xFFFFFF, true, null, null, null, "center"); 
			tf.setTextFormat(tf.defaultTextFormat);
			tf.x = tf.y = 5; tf.width = 490; tf.height = 390;
			addChild(tf);			
			
			
			tf.text = "ELM TestSuite "+VERSION+"\n";
			_container = new Array();
			init();
		}
		function init() {
			var i:int = AMOUNT;						
			while (--i > -1) {
				var spr:Sprite = new Sprite();
				spr.graphics.beginFill(0xFFFFFF);
				spr.graphics.drawRect(0, 0, 10, 10);
				spr.graphics.endFill();
				_container.push(spr);				
			}			
			iterator = new ELMIterator(_container);						
			testController = new TestController(this);						
			testComplete();
		}
		
		public function log(str:String):void {
			this.tf.appendText(str);
		}
		
		private function startTest() {			
			_counter++;			
			testController.current().addEventListener(ELMTestEvent.COMPLETED, testComplete);
			testController.current().addEventListener(ELMTestEvent.FAILED, testComplete);
			time = getTimer();
			testController.current().run();
		}
		
		function testComplete(e:*=null) {			
			if (e != null) {
				time = getTimer() -time;
				var str:String = (e.type == ELMTestEvent.COMPLETED) ? "OK" : "FAIL";
				log(str+"... ("+time+"ms)\n");
			}			
			if (testController.hasNext()) {
				testController.next();			
				sleep(SLP_TIME);
			} else log("\n- all tests finished! -");
		}
		
		private function sleep(sv:int):void {
			timer = new Timer(sv, 1);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();			
		}
		private function timerHandler(e:TimerEvent=null):void {			
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			timer = null;
			startTest();
		}

	}
	
}
