package util.elm.loggers {
	/*	
	___________________________________________________________________________________________________

    Arthropod Logger for ELM - part of ELM {EventListenerManager} rev. 1
    http://code.google.com/p/as3listenermanager/
	Copyright (c) 2010 Michael Dinkelaker
    ___________________________________________________________________________________________________      
	
	Arthropod - Console Logging (c) by Carl Calderon
		http://arthropod.stopp.se/
		
		Examples:
		http://arthropod.stopp.se/index2.php/?page_id=4
	  
	*/
	
	import com.carlcalderon.arthropod.Debug;	//  you need to download this
	import util.elm.loggers.IELMLogger;	
	
	public class Arthropod implements IELMLogger {
		
		public function init():void {
			//  Debug.password("your_password");			
			Debug.clear();
			Debug.memory();
		}
		
		public function info(msg:String):void {
			Debug.log(msg);
		}
		
		public function warn(msg:String):void {
			Debug.warning(msg);
		}
		
		public function error(msg:String):void {
			Debug.error(msg);
		}
	}
	
}