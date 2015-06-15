package  templates{

	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.NativeSignal;
	
	import templates.TemplateBase;
	
	public class SignalsTemplate extends TemplateBase {				

		public var clicks:Array;
		var clicked:NativeSignal;
		
		public function SignalsTemplate() {
			//  not really a manager, but supports clicked.removeAll
			super(true);  
			clicks = [];
		}		
		//  addLlistener
		override public function addL(target:IEventDispatcher, event:String, fct:Function):void {			
			clicked = new NativeSignal(target, event);
			clicked.add(fct)
			clicks.push(clicked);
		}
		//  disableListener
		override public function disableL():void {
			clicked = null;
		}		
		//  enableListener
		override public function enableL():void {
			clicked = null;
		}		
		//  removeListener
		override public function removeL(target:IEventDispatcher, event:String, fct:Function):void {
			var i:int = clicks.length; 
			while (--i > -1) {
				NativeSignal(clicks.pop()).removeAll();				
				//NativeSignal(clicks[i]).removeAll();
				//clicks[i] = null;
			}
			clicks = [];
			
		}
		override public function getTitle():String {
			return "AS3-Signals (no Groups)";
		}

	}
}
