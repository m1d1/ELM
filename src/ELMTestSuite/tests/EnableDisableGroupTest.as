package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class EnableDisableGroupTest extends AbstractTest {
		
		function EnableDisableGroupTest (ref:MovieClip) {			
			super(ref);			
		}
				
		override public function run():void {
			_ref.log("EnableDisableGroupTest... ");
			_ref.iterator.reset();
			// adding 200 to each group
			addEvents(100, ["group1", "group2", "group3", "group4", "group5", "a"]);
			addEvents(100, ["group1", "group2", "a"]);
			addEvents(100, ["group4", "group5", "b"]);
			addEvents(100, ["group3","b"]);
			
			// workaround to do several "silent" dispatcherTests()
			// usually dispatcherTest() is only called once in the end per test...
			var c:int = _counter;
			ELM.disableGroup("a");
			dispatcherTest(true); //  silent test
			if (_counter != 200) _ref.log("disable Failed #1...");
			
			_counter = c;
			ELM.disableGroup("b");
			dispatcherTest(true); //  silent test
			if (_counter != 400) _ref.log("disable Failed #2...");
			
			_counter = c;
			ELM.enableGroup("a");
			dispatcherTest(true); //  silent test
			if (_counter != 200) _ref.log("enable Failed #1...");
			
			_counter = c;
			ELM.disableGroup("a");
			ELM.enableGroup("b");
			dispatcherTest(true); //  silent test
			if (_counter != 200) _ref.log("enable Failed #1...");
			
			_counter = c;
			ELM.disableAll();
			ELM.enableAll();
						
			dispatcherTest();
		}
		
		override public function test():void {
						  
			if (findGroup("group1") == 200 && findGroup("group2") == 200 &&
				findGroup("group3") == 200 && findGroup("group4") == 200 && 
				findGroup("group5") == 200 && findGroup("a") == 200 && findGroup("b") == 200) {
				
				ELM.removeGroup("a");
				ELM.removeGroup("b");				
				
			}
			end();
		}
		
	}
}