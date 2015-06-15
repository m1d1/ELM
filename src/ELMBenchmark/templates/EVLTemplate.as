package  templates{

	//  http://code.google.com/p/as3eventlistenermanager/
	import ch.pixelraum.managers.*;
	import templates.TemplateBase;
	import flash.events.IEventDispatcher;	
		
	public class EVLTemplate extends TemplateBase {

		public function EVLTemplate () {
			//EventListenerManager.setDebugger(this);
			super(true);			
		}
		
				
		//  addLlistener
		override public function addL(target:IEventDispatcher, event:String, fct:Function):void {
			EventListenerManager.add(target, event, fct, "testGroup", true );						
		}
		//  disableListener
		override public function disableL():void {
			EventListenerManager.disable( null, "", null, "testGroup", true);
		}		
		//  enableListener
		override public function enableL():void {
			EventListenerManager.enable( null, "", null, "testGroup", true);
		}
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {						
			EventListenerManager.remove( null, "", null, "testGroup", true);
		}
		override public function getTitle():String {
			return "EventListenerManger 3.0"
		}
		
		
	}	
}
