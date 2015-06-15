package tests {
	
	import util.elm.ELM;	
	import util.elm.iterator.ELMIterator;
	import flash.display.MovieClip;
	
	public class ProtectionTest extends AbstractTest {
		
		function ProtectionTest(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			_ref.log("\nProtectionTest needs to FAIL!... ");
			_ref.iterator.reset();
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT2, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT3, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT1, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT3, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT1, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT0, ELM.PROTECTED);			
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT, ELM.PROTECTED);
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT2, ELM.PROTECTED);			
			addEvents(100, ["group1"], ELMTestEvent.TEST_EVENT0, ELM.PROTECTED);			
						
			dispatcherTest();
		}
		
		override public function test():void {
			//  try to remove ...in either way - it shouldn't work!!
			ELM.removeEvent("ELMTestEvent.TEST_EVENT");
			ELM.removeEvent("ELMTestEvent.TEST_EVENT0");
			ELM.removeEvent("ELMTestEvent.TEST_EVENT1");
			ELM.removeEvent("ELMTestEvent.TEST_EVENT2");
			ELM.removeEvent("ELMTestEvent.TEST_EVENT3");
			ELM.removeGroup("group1");			
			ELM.removeAll();
			end();  //  dispatcherTest() should fail! --> ELM.PROTECTED ;)
			
		}		
	}
}