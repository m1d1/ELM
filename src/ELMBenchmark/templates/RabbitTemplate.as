package templates{

	import rabbit.managers.events.*;	
	import templates.TemplateBase;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
		
	public class RabbitTemplate extends TemplateBase {
		
		function RabbitTemplate() {
			super(true);
		}
				
		private var eManager:EventsManager = EventsManager.getInstance();			
						
		//  addLlistener
		override public function addL(target:IEventDispatcher, ev:String, fct:Function):void {			   			
      		eManager.add(EventDispatcher(target), ev, fct, ["testGroup", "other_group_name"]);
		}
		//  disableListener
		override public function disableL():void {
			eManager.suspendAllFromGroup("testGroup");
		}		
		//  enableListener
		override public function enableL():void {
			eManager.resumeAllFromGroup("testGroup");
		}
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {
			eManager.removeAllFromGroup("testGroup"); 		
		}
		override public function getTitle():String {
			return "eManager 1.0";
		}
	}	
}