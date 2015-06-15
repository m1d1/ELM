package  templates{

	import templates.TemplateBase;
	import flash.events.IEventDispatcher;
	import flash.system.System;
	
	public class InitTemplate extends TemplateBase {				

		public function InitTemplate() {
			super(false);
		}		
		//  addLlistener
		override public function addL(target:IEventDispatcher, event:String, fct:Function):void {}
		//  disableListener
		override public function disableL():void {}		
		//  enableListener
		override public function enableL():void {}		
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {}
		override public function getTitle():String {
			return "InitDummy";
		}

	}
}
