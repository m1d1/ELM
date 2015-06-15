package tests {
	
	/**
	 * AbstractTest Class
	 * @author md
	 */
	
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	//import test.ELMTestEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	 
	public class AbstractTest extends EventDispatcher {
		
		var _ref:MovieClip;
		var _silentDispatchTest:Boolean
		public var _counter:int;
		
		
		public function AbstractTest(ref:MovieClip):void {
			_ref = ref;
			_counter = 0;  //  count triggered			
		}
		/* ----------------------------------------------------------------------------------------------------------- */
		//  override
		public function run():void {			
			/* 
			1) run() - add events/groups via addEvents()
			2) run() could/should call dispatcherTest()
			3) if so and completed - test() will be called if all went fine
			4) test()  do the actual testing here
			5) finally call end() to end the test
			*/  
			throw new ArgumentError("abstract method run() needs override!");
		}
				
		public function test():void {
			throw new ArgumentError("abstract method test() needs override!");
		}
		
				
		//  assuming ELM is empty, end this test
		public function end() {
			var result:String = ELM.length() == 0 ? ELMTestEvent.COMPLETED : ELMTestEvent.FAILED;
			ELM.removeAll();
			dispatchEvent(new ELMTestEvent(result));
		}
				
		/* ----------------------------------------------------------------------------------------------------------- */
		public function eventHandler(e:*):void {
			if (--_counter == 0) {  //  reception is complete
				if (!_silentDispatchTest) {
					_ref.log("OK.. cleanup test... ");
					test();
				}
			}
		}
		
		public function addEvents(amount:int, groups:Array, evt:String = ELMTestEvent.TEST_EVENT, special:String=""):void {
			while (--amount > -1) {
				if (_ref.iterator.hasNext()) {
					ELM.add2(_ref.iterator.next(), evt, eventHandler, groups, special);
					_counter++;
				}
				else throw ArgumentError("Error: addEvents() - out of Sprites (max. "+_ref.AMOUNT+"), increase AMOUNT in const ELMTestSuite:AMOUNT");
			}
		}		
		
		//  looking for presence of a group name
		public function findGroup(grp:String):int {
			var result:int = 0;
			var it:ELMIterator = ELM.getELMIterator();
			it.reset();
			while (it.hasNext()) {
				it.next();
				if (it.current().findGroup(grp)) ++result;
			}
			return result;
		}
		
		//  Event dispatcher test
		public function dispatcherTest(silent:Boolean=false):void {
			_silentDispatchTest = silent; //  silent flag for enable/disable tests - see eventHandler()
			var i:int = (_ref.iterator.pos < 1001) ? _ref.iterator.pos : 1000;
			var pos:int = i;
			_ref.iterator.reset();
			if (!_silentDispatchTest) _ref.log("dispatcherTest...");
			
			while (--i > -1) {
					_ref.iterator.next().dispatchEvent(new ELMTestEvent(ELMTestEvent.TEST_EVENT));
					_ref.iterator.current().dispatchEvent(new ELMTestEvent(ELMTestEvent.TEST_EVENT0));
					_ref.iterator.current().dispatchEvent(new ELMTestEvent(ELMTestEvent.TEST_EVENT1));
					_ref.iterator.current().dispatchEvent(new ELMTestEvent(ELMTestEvent.TEST_EVENT2));
					_ref.iterator.current().dispatchEvent(new ELMTestEvent(ELMTestEvent.TEST_EVENT3));
			}
			if (_silentDispatchTest) _ref.iterator.pos = pos;			
		}
	}	
}