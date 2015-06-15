package util.elm.loggers {
	/*		
    ___________________________________________________________________________________________________

    FLEX only - AS3 logging with Log4j / Chainsaw for ELM - part of ELM {EventListenerManager} rev. 1
    http://code.google.com/p/as3listenermanager/
	Copyright (c) 2010 Michael Dinkelaker
    ___________________________________________________________________________________________________      
	
	AS3 logging with Log4j / Chainsaw Logging (c) by David Chang
		http://nochump.com/blog/archives/24
		http://nochump.com/blog/wp-content/uploads/2007/04/nochump-logging-10-dist.zip
				
		Examples:
		http://nochump.com/blog/archives/24
	*/	
	import mx.logging.*;
    import nochump.logging.target.Log4jXMLSocketTarget;  //  you need to download this
	import util.elm.loggers.IELMLogger;	
	
	public class AS3Log4j implements IELMLogger {
		
		protected static const logger:ILogger = Log.getLogger("util.elm.loggers.AS3Log4j");
		
		public function init():void {
			Log.addTarget(new Log4jXMLSocketTarget());
		}
		
		public function info(msg:String):void {
			logger.info(msg);
		}
		
		public function warn(msg:String):void {
			logger.warn(msg);
		}
		
		public function error(msg:String):void {
			logger.error(msg);
		}
	}
	
}