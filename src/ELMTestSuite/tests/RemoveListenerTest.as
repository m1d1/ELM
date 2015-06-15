package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class RemoveListenerTest extends AbstractTest {
		
		function RemoveListenerTest(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			_ref.log("RemoveListener... ");
			_ref.iterator.reset();
			// adding 200 to each group
			addEvents(100, ["group1", "group2", "group3", "group4", "group5", "a"]);
			addEvents(100, ["group1", "group2", "a"]);
			addEvents(100, ["group4", "group5", "b"]);
			addEvents(100, ["group3","b"]);
						
			dispatcherTest();
		}
		
		override public function test():void {
			
			//  verify if we actually have 200 of each group
			ELM.removeListener(eventHandler);
			end();			
		}		
	}
}