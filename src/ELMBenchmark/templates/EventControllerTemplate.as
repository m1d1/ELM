package  templates{

	import templates.TemplateBase;
	import flash.events.IEventDispatcher;
	import _as.fla.events.LEC;  
	
	public class EventControllerTemplate extends TemplateBase {
		var lec:LEC;

		public function EventControllerTemplate() {
			super(false);
			 lec = new LEC();
		}		
		//  addLlistener
		override public function addL(target:IEventDispatcher, event:String, fct:Function):void {
			lec.add(target, event, fct, "lecGroup");
		}
		//  disableListener
		override public function disableL():void {}		
		//  enableListener
		override public function enableL():void {}		
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {
			lec.remove("lecGroup");
		}
		override public function getTitle():String {
			return "EventController 1.R3.05";
		}

	}
}
