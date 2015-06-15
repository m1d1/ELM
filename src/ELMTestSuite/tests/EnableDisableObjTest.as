package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class EnableDisableObjTest extends AbstractTest {
		
		function EnableDisableObjTest (ref:MovieClip) {			
			super(ref);			
		}
				
		override public function run():void {
			_ref.log("EnableDisableObj... ");
			_ref.iterator.reset();						
			addEvents(200, ["group1", "group2", "group3", "b"]);			
			var c:int = _counter; var i:int = 200;
			
			_ref.iterator.reset();			
			while (--i > -1) {
				if (i % 2 == 0) ELM.disableObj(_ref.iterator.next());				
			}
			_ref.iterator.pos = 200;  // dirty iterator pos reset for dispatcherTest						
			dispatcherTest(true); //  silent test			
			if (_counter != 100) _ref.log("disable Failed #1...");
			_counter = c;
			
			// #2
			_counter = c; i = 200;
			_ref.iterator.reset();			
			while (--i > -1) {
				ELM.disableObj(_ref.iterator.next());
			}
			_ref.iterator.pos = 200;  // dirty iterator pos reset for dispatcherTest						
			dispatcherTest(true); //  silent test
			if (_counter != 200) _ref.log("disable Failed #2...");
			
			_counter = c; i = 200;
			_ref.iterator.reset();
			while (--i > -1) ELM.enableObj(_ref.iterator.next());
			_ref.iterator.pos = 200;  // dirty iterator pos reset for dispatcherTest
			dispatcherTest();
		}
		
		override public function test():void {
			var i:int = 200; _ref.iterator.reset();
			while (--i > -1) {
				trace(ELM.length());
				if (ELM.length() == 100) {
					trace(ELM.length());
				}
				ELM.removeObj(_ref.iterator.next());
			}
			end();
		}		
	}
}