package tests {
	
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	import flash.display.MovieClip;
	
	public class CloneAddTest extends AbstractTest {
		
		function CloneAddTest(ref:MovieClip) {			
			super(ref);			
		}
				
		override public function run():void {
			_ref.log("CloneAdd... ");
			_ref.iterator.reset();
			
			addEvents(1, ["group0"]);
			ELM.add(_ref.iterator.current(), ELMTestEvent.TEST_EVENT1, eventHandler);
			ELM.add(_ref.iterator.current(), ELMTestEvent.TEST_EVENT2, eventHandler);
			ELM.add(_ref.iterator.current(), ELMTestEvent.TEST_EVENT3, eventHandler);
			var it:ELMIterator = ELM.getELMIterator();
			//  clone 9x
			ELM.cloneAdd(it.next().object, [_ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next(), _ref.iterator.next()]);
			_counter = 39; //  40 Events should be caught/handled from 10 EDispatchers
			dispatcherTest();
		}
		
		override public function test():void {
			ELM.removeAll();			
			end();
		}		
	}
}