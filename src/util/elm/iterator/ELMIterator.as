package util.elm.iterator  {
	/*
	___________________________________________________________________________________________________

	ELMArrayIterator - part of the EventListenerManager rev. 2
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

	import flash.events.IEventDispatcher;
	import util.elm.iterator.IArrayIterator;
	
	/**
	 * Basic Iterator for ELM and bindings.EventMappings 	 	
	 
	 * @example
	      
	   iterator.reset();
	   while (iterator.hasNext()) {
		   iterator.next();
	   }
	   
	   THIS DOESN'T WORK:
	   for (iterator.reset(); iterator.hasNext(); iterator.next()) {} // (would double process element 0)
	 */
	public class ELMIterator implements IArrayIterator {

		private var elements:Array;
		public var pos:Number;
		public var cur:Number;

		function ELMIterator(arr:Array) {
			elements=arr;
			reset();
		}
		public function next():* {
			pos++;
			cur = (pos-1);
			return elements[cur];
		}
		public function current():* {
			return elements[cur];
		}
		public function hasNext():Boolean {
			if (pos>elements.length||elements[pos]==null) {
				return false;
			} else {
				return true;
			}
		}
		public function reset():void {
			pos=0;
			cur=0;
		}
	}
}