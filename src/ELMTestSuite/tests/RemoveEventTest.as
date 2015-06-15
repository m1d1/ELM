package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class RemoveEventTest extends AbstractTest {
		
		function RemoveEventTest(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			_ref.log("RemoveEvent... ");
			_ref.iterator.reset();
			// adding 200 to each group
			addEvents(10, ["group1", "group2", "group3", "group4", "group5", "a"], ELMTestEvent.TEST_EVENT0);
			addEvents(10, ["group1", "group2", "a"], ELMTestEvent.TEST_EVENT1);
			addEvents(40, ["group4", "group5", "b"], ELMTestEvent.TEST_EVENT2);
			addEvents(20, ["group3","b"], ELMTestEvent.TEST_EVENT3);
			addEvents(10, ["group","b", "a"], ELMTestEvent.TEST_EVENT);
			
			
			addEvents(20, ["group1", "group2", "group3", "group4", "group5", "a"], ELMTestEvent.TEST_EVENT0);
			addEvents(20, ["group1", "group2", "a"], ELMTestEvent.TEST_EVENT2);
			addEvents(120, ["group4", "group5", "b"], ELMTestEvent.TEST_EVENT2);
			addEvents(20, ["group3","b"], ELMTestEvent.TEST_EVENT1);
			addEvents(20, ["group","b", "a"], ELMTestEvent.TEST_EVENT1);
			
			
			
			addEvents(30, ["group1", "group2", "group3", "group4", "group5", "a"], ELMTestEvent.TEST_EVENT0);
			addEvents(40, ["group1", "group2", "a"], ELMTestEvent.TEST_EVENT2);
			addEvents(40, ["group4", "group5", "b"], ELMTestEvent.TEST_EVENT);
			addEvents(40, ["group3","b"], ELMTestEvent.TEST_EVENT3);
			addEvents(40, ["group","b", "a"], ELMTestEvent.TEST_EVENT1);
			
			
			
			addEvents(100, ["group1", "group2", "group3", "group4", "group5", "a"], ELMTestEvent.TEST_EVENT);
			addEvents(12, ["group1", "group2", "a"], ELMTestEvent.TEST_EVENT1);
			addEvents(60, ["group4", "group5", "b"], ELMTestEvent.TEST_EVENT2);
			addEvents(112, ["group3","b"], ELMTestEvent.TEST_EVENT3);
			addEvents(11, ["group","b", "a"], ELMTestEvent.TEST_EVENT0);
			
			
			
			addEvents(16, ["group1", "group2", "group3", "group4", "group5", "a"], ELMTestEvent.TEST_EVENT);
			addEvents(20, ["group1", "group2", "a"], ELMTestEvent.TEST_EVENT0);
			addEvents(11, ["group4", "group5", "b"], ELMTestEvent.TEST_EVENT3);
			addEvents(20, ["group3","b"], ELMTestEvent.TEST_EVENT2);
			addEvents(23, ["group","b", "a"], ELMTestEvent.TEST_EVENT1);
			
			
			
			addEvents(50, ["group","b", "a"], ELMTestEvent.TEST_EVENT);
			addEvents(30, ["group1", "group2", "group3", "group4", "group5", "a"], ELMTestEvent.TEST_EVENT0);			
			addEvents(20, ["group4", "group5", "b"], ELMTestEvent.TEST_EVENT2);
			addEvents(10, ["group3","b"], ELMTestEvent.TEST_EVENT3);
			addEvents(25, ["group1", "group2", "a"], ELMTestEvent.TEST_EVENT1);
			
			dispatcherTest();
		}
		
		override public function test():void {			
			ELM.removeEvent(ELMTestEvent.TEST_EVENT3);
			ELM.removeEvent(ELMTestEvent.TEST_EVENT0);
			ELM.removeEvent(ELMTestEvent.TEST_EVENT);
			ELM.removeEvent(ELMTestEvent.TEST_EVENT1);
			ELM.removeEvent(ELMTestEvent.TEST_EVENT2);
			end();			
		}
		
	}
}