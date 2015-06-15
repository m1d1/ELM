package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class InitTest extends AbstractTest {
		
		function InitTest(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			_ref.log("InitTest... ");
			//  we do nothing just a 
			ELM.init();
			end();
			
		}
		
		override public function test():void {}
	}
}