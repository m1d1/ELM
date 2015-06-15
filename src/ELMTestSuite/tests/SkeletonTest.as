package tests {
	
	public class Test extends AbstractTest {
		
		function Test(ref:MovieClip) {			
			super(ref);
			
		}
				
		override public function run():void {
			
			_ref.log("\n?test... ");
			_ref.iterator.reset();
			addEvents(100, "group1");
			dispatcherTest();
		}
		
		override public function test():void {
			
			if (findGroup("group1") == 100) {
				
			}
			end();
		}
		
	}