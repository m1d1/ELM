package tests {
	
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	import flash.display.MovieClip;
	
	public class RemoveAllTest extends AbstractTest {
		
		function RemoveAllTest(ref:MovieClip) {			
			super(ref);			
		}
				
		override public function run():void {
			_ref.log("RemoveAll... ");
			_ref.iterator.reset();
			
			addEvents(50, ["group0"]);
			addEvents(10, ["group1"]);
			addEvents(10, ["group1"]);
			addEvents(10, ["group0"]);
			addEvents(10, ["group2"]);
			addEvents(10, ["group3"]);
			addEvents(100, ["group3"]);
			addEvents(100, ["group4"]);
			addEvents(100, ["group99"]);
			addEvents(100, ["group101"]);
			addEvents(100, ["group2"]);
			
			dispatcherTest();
		}
		
		override public function test():void {
			ELM.removeAll();			
			end();
		}		
	}
}