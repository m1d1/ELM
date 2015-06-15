 package util.elm.bindings {
	/*
    ___________________________________________________________________________________________________

    EventMappings - part of ELM {EventListenerManager} rev. 2
    http://code.google.com/p/as3listenermanager/
    ___________________________________________________________________________________________________


    Copyright (c) 2010-2011 Michael Dinkelaker

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

 	  http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
	*/
	
	import util.elm.ELM;	
	import util.elm.iterator.ELMIterator;
	import flash.events.IEventDispatcher;
	
	
	/**
	 * Helper Class for MouseBindings and KeyboardBindings 	 	
	 */
	public class EventMappings {
		
		protected var mappings:Array;
		
		public function EventMappings() {
			mappings = [];
		}
		
		public function addItem(item:Boolean, event:String):void {
			if (item) mappings.push(event);
		}
		
		public function getIterator():ELMIterator {
			return new ELMIterator(mappings);
		}
						
		public static function bind(obj:IEventDispatcher, fct:Function, groups:Array, it:ELMIterator):void {
			while (it.hasNext()) {
				ELM.add2(obj, String(it.next()), fct, groups);
			}
			it = null;  //  free res.
		}		
	}	
}