package util.elm.loggers {
	/*	
	___________________________________________________________________________________________________

    Parsley Logger for ELM - part of ELM {EventListenerManager} rev. 1
    http://code.google.com/p/as3listenermanager/
	Copyright (c) 2010 Michael Dinkelaker
    ___________________________________________________________________________________________________      
	
	Parsley - (c) by Jens Halm
		http://www.spicefactory.org/parsley/		
		
		Examples:
		http://www.spicefactory.org/parsley/docs/2.1/manual/spicelib-logging.php#config_programmatic
		
		Note:
		This remains untested, since I don't actually use Parsley.
		I'd be happy to replace this Class with your working solution
		and give you the credit for it.
		Feel free to mail me: ilabor [at] gmail [dot] com
		-mike
	*/
	
	import org.spicefactory.parsley.flash.logging.*;	//  you need to download this
	import util.elm.loggers.IELMLogger;	
	
	public class ParsleyLogger implements IELMLogger {
		
		private static const log:Logger = LogContext.getLogger(MyClass);
		private static var factory:FlashLogFactory = new DefaultLogFactory();
		
		public function init():void {
			
			factory.setRootLogLevel(LogLevel.INFO);
			factory.addLogLevel("util.elm.loggers.", LogLevel.INFO);			
			LogContext.factory = factory;
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