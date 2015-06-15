package tests {
	
	import util.elm.ELM;	
	import util.elm.iterator.ELMIterator;
	import flash.display.MovieClip;
	
	public class RemoveObjTest extends AbstractTest {
		
		function RemoveObjTest(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			_ref.log("RemoveObj... ");
			_ref.iterator.reset();
			addEvents(100, ["group1"]);
			dispatcherTest();
		}
		
		override public function test():void {
			//  removing all Sprites/Objects one by one, 
			//  identified by the Sprite instance
			var i:int = 100;		
			_ref.iterator.reset();			
			while (--i > -1) {
				ELM.removeObj(_ref.iterator.next());
			}
			trace("RemoveObj length: "+ELM.length());
			//  finally all Sprites should be removed now
			end();
		}		
	}
}