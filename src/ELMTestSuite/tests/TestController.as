package tests{


	 /**
	 * ELM TestController
	 * @author md
	 */
	 
	import util.elm.ELM;
	import flash.display.MovieClip;
	import util.elm.iterator.ELMIterator;

	public class TestController extends ELMIterator {

		public var _tests:Array;

		public function TestController(ref:MovieClip):void {
			if (Number(ELM.VERSION) < 1.50) trace("ELMTestSuite works only for ELM 1.50 and later, you have "+ELM.VERSION);
			_tests = [];
			_tests.push(new InitTest(ref));
			if (Number(ELM.VERSION) >= 1.52) _tests.push(new CloneAddTest(ref));  //  cloneAdd introduced in 1.52
			_tests.push(new RemoveObjTest(ref));
			_tests.push(new RemoveGroupTest(ref));
			_tests.push(new RemoveListenerTest(ref));
			_tests.push(new RemoveEventTest(ref));
			_tests.push(new RemoveAllTest(ref));			
			_tests.push(new EnableDisableObjTest(ref));
			_tests.push(new EnableDisableGroupTest(ref));
			_tests.push(new AutoRemoveTest(ref));
			_tests.push(new GroupNamesTest(ref));			
			_tests.push(new ProtectionTest(ref)); //  ProtectionTest must be the last one!
			super(_tests);
		}
	}

}