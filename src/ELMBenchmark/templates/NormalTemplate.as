package  templates{

	import templates.TemplateBase;
	import flash.events.IEventDispatcher;
	import flash.system.System;
	
	public class NormalTemplate extends TemplateBase {				

		public function NormalTemplate() {
			super(false);
		}		
		//  addLlistener
		override public function addL(target:IEventDispatcher, event:String, fct:Function):void {
			target.addEventListener(event, fct);
		}
		//  disableListener
		override public function disableL():void {}		
		//  enableListener
		override public function enableL():void {}		
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {
			target.removeEventListener(event, fct);			
		}
		override public function getTitle():String {
			return "Flash -no manager-";
		}

	}
}
