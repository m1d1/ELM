package util.elm.loggers {
	/*		
    ___________________________________________________________________________________________________

    ThunderBolt AS3 Logger for ELM - part of ELM {EventListenerManager} rev. 1
    http://code.google.com/p/as3listenermanager/
	Copyright (c) 2010 Michael Dinkelaker
    ___________________________________________________________________________________________________      
	
	ThunderBolt AS3 - Firefox/Firebug Logging (c) by Jens Krause
		http://code.google.com/p/flash-thunderbolt/
		http://github.com/sectore/ThunderBoltAS3
		http://github.com/sectore/ThunderBoltAS3Console
		
		Examples:
		http://code.google.com/p/flash-thunderbolt/wiki/ThunderBoltAS3	  
	*/
	
	import org.osflash.thunderbolt.Logger;	//  you need to download this
	import util.elm.loggers.IELMLogger;	
	
	public class ThunderBoltAS3	implements IELMLogger {
		
		public function init():void {			
			Logger.about();
			Logger.info(Logger.memorySnapshot());			
		}
		
		public function info(msg:String):void {
			Logger.info(msg);
		}
		
		public function warn(msg:String):void {
			Logger.warn(msg);
		}
		
		public function error(msg:String):void {
			Logger.error(msg);
		}
	}
	
}