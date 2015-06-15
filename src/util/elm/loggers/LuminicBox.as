package util.elm.loggers {
	/*	
	___________________________________________________________________________________________________

    LuminicBox Logger for ELM - part of ELM {EventListenerManager} rev. 1
    http://code.google.com/p/as3listenermanager/
	Copyright (c) 2010 Michael Dinkelaker
    ___________________________________________________________________________________________________      
	
	LuminicBox - FlashInspector Logging (c) by Pablo Costantini
		http://code.google.com/p/luminicbox-log/ 
		(svn downloads only)
		
		
		Examples:
		http://code.google.com/p/luminicbox-log/source/browse/trunk/as3/trunk/tests/LogSample01.as	  
	*/
	
	import com.luminicbox.log.*;				//  you need to download this
	import util.elm.loggers.IELMLogger;	
	
	public class LuminicBox implements IELMLogger {
		
		private static var log:Logger = new Logger("ELM");
		
		public function init():void {
			log.addPublisher( new TracePublisher() );
			log.addPublisher( new ConsolePublisher() );  //  not working 
		}
		
		public function info(msg:String):void {
            log.info(msg);
		}
		
		public function warn(msg:String):void {
			log.warn(msg);
		}
		
		public function error(msg:String):void {
			log.error(msg);
		}
	}
	
}