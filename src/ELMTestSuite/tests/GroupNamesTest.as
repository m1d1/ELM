package tests {
	
	import flash.display.MovieClip;
	import util.elm.ELM;
	import util.elm.iterator.ELMIterator;
	
	public class GroupNamesTest extends AbstractTest {
		
		function GroupNamesTest(ref:MovieClip) {			
			super(ref);			
		}
				
		override public function run():void {
			_ref.log("GroupNames (add/remove)... ");
			_ref.iterator.reset();			
			addEvents(400, ["group1", "group2", "group3", "group4", "group5", "a", "b"]);
			
			//  let's try to add two extra groupnames
			var i:int = 400;
			_ref.iterator.reset();
			while (--i > -1) {
				if ( i < 200 ) ELM.addGroupNames(_ref.iterator.next(), ["MARV"]);
				else ELM.addGroupNames(_ref.iterator.next(), ["GOLDIE"]);
			}
			
			// disable MARV + disp.test == 200
			var c:int = _counter;
			ELM.disableGroup("MARV");
			dispatcherTest(true); //  silent test			
			if (_counter != 200) _ref.log("failed addGroupNames #1...");
			
			// disable GOLDIE + disp.test == 400 (nothing happend)
			_counter = c;
			ELM.disableGroup("GOLDIE");
			dispatcherTest(true); //  silent test			
			if (_counter != 400) _ref.log("failed addGroupNames #2...");
			
			//  remove all Groupnames but MARV + GOLDIE			
			var grps:Array = ["group1", "group2", "group3", "group4", "group5", "a", "b"];
			i = 400; _ref.iterator.reset();
			while (--i > -1) {				
				ELM.removeGroupNames(_ref.iterator.next(), grps);
			}
			
			// try to enable all "old removed groups 1-5 a+b"
			i = grps.length;
			while (--i > -1) ELM.enableGroup(grps[i]);
			// we (should) have still everything disabled, test it
			_counter = c;
			dispatcherTest(true);
			if (_counter != 400) _ref.log("failed removeGroupNames #3...");
			else _counter = c;
			
			//final test			
			ELM.enableGroup("GOLDIE");
			ELM.enableGroup("MARV");							
			dispatcherTest();
		}
		
		override public function test():void {
						  
			if (findGroup("MARV") == 200 && findGroup("GOLDIE") == 200) {
				ELM.removeGroup("GOLDIE");
				ELM.removeGroup("MARV");				
			}
			end();
		}
		
	}
}