package util.elm.loggers {
	/*		
    ___________________________________________________________________________________________________

    Trace Logger for ELM - part of ELM {EventListenerManager} rev. 1
    http://code.google.com/p/as3listenermanager/
	Copyright (c) 2010 Michael Dinkelaker
    ___________________________________________________________________________________________________      
	
	This is the Default Logger
	
	*/		
	import util.elm.loggers.IELMLogger;	
	
	/**
	 * ELM's default Logger
	 * you can find some more preset Classes in this package/folder for Thunderbolt, Arthropod, etc.
	 * to replace the TraceLogger.
	 * 
	 * @see ELM.installLogger(l:IELMLogger); 	 	
	 */
	public class TraceLogger implements IELMLogger {
		
		public function init():void {			
		}
		
		public function info(msg:String):void {
			trace(msg);
		}
		
		public function warn(msg:String):void {
			trace(msg);
		}
		
		public function error(msg:String):void {
			trace(msg);
		}
	}
	
}