package  templates{

	import util.elm.ELM;
	import templates.TemplateBase;
	import flash.events.IEventDispatcher;
	
	public class ELMTemplate extends TemplateBase {				

		public function ELMTemplate() {
			super(true);			
		}		
		//  addLlistener
		override public function addL(target:IEventDispatcher, event:String, fct:Function):void {
			ELM.add(target, event, fct, "testGroup");
		}
		//  disableListener
		override public function disableL():void {
			ELM.disableGroup("testGroup");
		}		
		//  enableListener
		override public function enableL():void {
			ELM.enableGroup("testGroup");
		}
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {			
			ELM.removeGroup("testGroup");
		}				
		override public function getTitle():String {
			return "ELM "+ELM.VERSION;
		}
	}	
}