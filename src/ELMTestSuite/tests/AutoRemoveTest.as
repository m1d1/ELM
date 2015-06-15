package tests {
	
	import util.elm.ELM;	
	import util.elm.iterator.ELMIterator;
	import flash.display.MovieClip;
	
	public class AutoRemoveTest extends AbstractTest {
		
		function AutoRemoveTest(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			_ref.log("AutoRemove... ");
			_ref.iterator.reset();
			addEvents(10, ["group1"], ELMTestEvent.TEST_EVENT2, ELM.AUTOREMOVE);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT3, ELM.AUTOREMOVE);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT1, ELM.AUTOREMOVE);
			addEvents(10, ["group1"], ELMTestEvent.TEST_EVENT3, ELM.AUTOREMOVE);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT, ELM.AUTOREMOVE);
			addEvents(10, ["group1"], ELMTestEvent.TEST_EVENT1, ELM.AUTOREMOVE);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT0, ELM.AUTOREMOVE);			
			addEvents(10, ["group1"], ELMTestEvent.TEST_EVENT, ELM.AUTOREMOVE);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT2, ELM.AUTOREMOVE);			
			addEvents(10, ["group1"], ELMTestEvent.TEST_EVENT0, ELM.AUTOREMOVE);			
						
			dispatcherTest();
		}
		
		override public function test():void {
						
			//  dispatcherTest() should have removed all events
			end();
		}		
	}
}