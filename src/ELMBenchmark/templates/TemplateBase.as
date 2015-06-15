package templates {
	
	import flash.events.IEventDispatcher;
	
	public class TemplateBase {
		
		public var isManager:Boolean = false;

		public function TemplateBase(b:Boolean) {
			isManager = b;
		}
		
		//  addLlistener
		public function addL(target:IEventDispatcher, event:String, fct:Function):void {
			throw new ArgumentError("addL needs override");
		}
		//  disableListener
		public function disableL():void {
			throw new ArgumentError("disableL needs override");
		}		
		//  enableListener
		public function enableL():void {
			throw new ArgumentError("enableL needs override");
		}
		//  removeListener
		public function removeL(target:IEventDispatcher, event:String, fct:Function):void {
			throw new ArgumentError("removeL needs override");
		}
		public function getTitle():String {
			throw new ArgumentError("unknown Title");
		}
	}	
}
