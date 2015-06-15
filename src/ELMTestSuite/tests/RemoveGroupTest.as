package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class RemoveGroupTest extends AbstractTest {
		
		function RemoveGroupTest(ref:MovieClip) {			
			super(ref);			
		}
				
		override public function run():void {
			_ref.log("RemoveGroup... ");
			_ref.iterator.reset();
			// adding 200 to each group
			addEvents(100, ["group1", "group2", "group3", "group4", "group5", "a"]);
			addEvents(100, ["group1", "group2", "a"]);
			addEvents(100, ["group4", "group5", "b"]);
			addEvents(100, ["group3","b"]);
						
			dispatcherTest();
		}
		
		override public function test():void {
						  
			if (findGroup("group1") == 200 && findGroup("group2") == 200 &&
				findGroup("group3") == 200 && findGroup("group4") == 200 && 
				findGroup("group5") == 200 && findGroup("a") == 200 && findGroup("b") == 200) {
				
				ELM.removeGroup("a");
				ELM.removeGroup("b");				
				
			}
			end();
		}
		
	}
}