package util.elm {
	/*
    ___________________________________________________________________________________________________

    ELMObject - part of ELM {EventListenerManager} 1.50
    http://code.google.com/p/as3listenermanager/
    ___________________________________________________________________________________________________


    Copyright (c) 2009-2011 Michael Dinkelaker

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
	import flash.system.System;
	
	import util.elm.ELM;
	import util.elm.profiler.IELMProfilable;
	
	/**
	 * ELMObject Class internally used by ELM 	 	
	 */
	public class ELMObject {

		public var object:IEventDispatcher, groups:Object;
		protected var eventMappings:Array;
		
		//  ________________________________________________________________________________PUBLIC METHODS		
		public function ELMObject(obj:IEventDispatcher, evt:String, fct:Function, grp:String="", autoremove:Boolean=false, protection:Boolean=false):void {			
			object = obj; groups = {}; groups[grp] = true; eventMappings = [];
			addEventMapping(evt, fct, autoremove, protection);
		}
		public function addEventMapping(evt:String, fct:Function, autoremove:Boolean, protection:Boolean):void {
			eventMappings = _addEventMapping(eventMappings, object, evt, groups, fct, autoremove, _autoRemoveHandler, protection);
		}
		public function removeEventMapping(n:int):void {
			eventMappings = _modifyEventMapping(eventMappings, object, ELM.JOB_REMOVE, groups, n, _autoRemoveHandler);
		}
		public function enableEventMapping(n:int):void {
			eventMappings = _modifyEventMapping(eventMappings, object, ELM.JOB_ENABLE, groups, n, _autoRemoveHandler);
		}
		public function disableEventMapping(n:int):void {
			eventMappings = _modifyEventMapping(eventMappings, object, ELM.JOB_DISABLE, groups, n, _autoRemoveHandler);
		}
		public function showEventMappings(filter:String = ""):String {
			return _showEventMappings(eventMappings, object, groups, filter);
		}		
		public function findEventMapping(evt:String, fct:Function, auto_remove:Boolean=false):int {
			return _findEventMapping(eventMappings, evt, fct, auto_remove);
		}
		public function modifyGroupNames(sgrp:Array, add:Boolean=true):void {			
			var grp:String = "", i:int = sgrp.length;
			while (--i > -1) {
				grp = String(sgrp[i]);
				if (add && grp != "") groups[grp] = true;
				else if (!add && groups[grp] == true) delete groups[grp];
				else if (!add) ELM.logIt("can't remove groupname "+grp+" from "+object, ELM.LOG_WARNING);
			}
		}
		public function findGroup(sgrp:String):Boolean {
			if (groups[sgrp] is Boolean) return groups[sgrp];
			return false;
		}
		public function eventMappingsLength():int {
			return eventMappings.length;
		}
		public function getEventMappings():Array {
			return eventMappings;
		}
		//  ________________________________________________________________________________PRIVATE METHODS
		private static function _addEventMapping(eventMappings:Array, object:IEventDispatcher, evt:String, groups:Object, fct:Function, autoremove:Boolean, _autoRemoveHandler:Function, protection:Boolean):Array {			
			eventMappings.push(new ELMMO(evt, fct, autoremove, true, protection));
			fct = (autoremove) ? _autoRemoveHandler : fct;
			_addListener(object, evt, fct);
			if (ELM.profilerFunction != null) _checkProfiling(ELMMO(eventMappings[int(eventMappings.length-1)]), object, groups, ELM.JOB_ADD);
			return eventMappings;
		}
		private static function _showEventMappings(eventMappings:Array, object:IEventDispatcher, groups:Object, filter:String):String {
			var i:int = eventMappings.length, evListing:String = "";
			var mObj:ELMMO;
			while (--i > -1) {
				mObj = ELMMO(eventMappings[i]);
				if (filter == "" || (filter == ELM.AUTOREMOVE && mObj.auto_remove) || (filter == ELM.PROTECTED && mObj.protection) ) {
					evListing += "\n\t\tevent: '"+mObj.event+"', enabled: '"+mObj.enabled+"', auto_remove: '"+mObj.auto_remove+"', listener: '"+mObj.listener+"'";
				}
				
			}
			if (evListing != "") evListing = "\n\n\tobject: "+object+", "+"group/s: "+ELM.getGroupsString(groups) + evListing;
			return evListing;
		}
		private function _autoRemoveHandler(e:*):void {  // rev 144 ELM 1.22			
			eventMappings = _executeAutoRemove(eventMappings, object, e, groups, _autoRemoveHandler);
		}
		private static function _executeAutoRemove(eventMappings:Array, object:IEventDispatcher, e:*, groups:Object, _autoRemoveHandler:Function):Array {
			var fctVect:Array = [], i:int;
			while ( (i = _findEventMapping(eventMappings, e.type, null, true) ) > -1) {
				    fctVect.push(ELMMO(eventMappings[i]).listener);
					eventMappings = _modifyEventMapping(eventMappings, object, ELM.JOB_REMOVE, groups, i, _autoRemoveHandler)
			}
			if (eventMappings.length == 0 && (( i = ELM.findELMObject(object)) > -1) ) ELM.removeELMObject(i);
			while (fctVect.length > 0) (fctVect.pop() as Function)(e);
			return eventMappings;
		}
		private static function _findEventMapping(eventMappings:Array, evt:String, fct:Function = null, auto_remove:Boolean=false):int {
			var i:int = eventMappings.length, found:int = 0, toFind:int = 1, mObj:ELMMO;			
			if (evt != "") ++toFind; if (fct != null) ++toFind;			
			while (--i > -1 && toFind > 0) {
				mObj = ELMMO(eventMappings[i]);
				if (mObj.event == evt) ++found;
				if (mObj.listener == fct) ++found;
				if (mObj.auto_remove == auto_remove) ++found;
				if (found == toFind) break;
				else found = 0;
			}
			return i;
		}
		private static function _checkProfiling(mObj:ELMMO, object:IEventDispatcher, groups:Object, job:String):void {
			if (ELM.profilerFunction != null) {					
				if (ELM.profilerFunction(object, groups, job, mObj)) ELM.logIt(job + " " + object + ", " + "group/s: " 
					+ ELM.getGroupsString(groups) + ", event: '" + mObj.event + "', enabled: '" + mObj.enabled + "'" 
					+ "', AUTOREMOVE: '" + mObj.auto_remove + ", 'PROTECTED: '" + mObj.protection+ "'", ELM.LOG_PROFILING);				
			}
		}
		private static function _modifyEventMapping(eventMappings:Array, object:IEventDispatcher, job:String, groups:Object, n:int, _autoRemoveHandlerFct:Function = null):Array {
			var fct:Function = null, remAll:Boolean = (n == -1) ? true : false, mObj:ELMMO;
			n = (remAll) ? eventMappings.length : ++n;
						
			while (--n > -1) {
				mObj = ELMMO(eventMappings[n]);
				if (!mObj.protection) {	// 1.25 protection		
					
					_checkProfiling(mObj, object, groups, job);
					fct = (mObj.auto_remove) ? _autoRemoveHandlerFct : mObj.listener;
					
					switch (job) {
						case ELM.JOB_DISABLE:
							if (mObj.enabled && !mObj.auto_remove) { // 1.25 don't disable auto_removes
								mObj.enabled = false;
								_removeListener(object, mObj.event, fct);							
							}
							break;
						case ELM.JOB_ENABLE:
							if (!mObj.enabled) {
								_addListener(object, mObj.event, fct);
								mObj.enabled = true;
							}
							break;
						case ELM.JOB_REMOVE:
							if (mObj.enabled) {
								_removeListener(object, mObj.event, fct);
							}
							eventMappings.splice(n, 1);
							break;
					}
				}
				if (!remAll) break;
			}
			return eventMappings;
		}

		private static function _addListener(object:IEventDispatcher, evt:String, fct:Function):void {
			object.addEventListener(evt, fct, ELM.useCapture);
		}
		private static function _removeListener(object:IEventDispatcher, evt:String, fct:Function):void {
			object.removeEventListener(evt, fct);
		}
	}
}
internal class ELMMO {
	
	public var event:String,
			   listener:Function,			   			   
			   auto_remove:Boolean,
			   enabled:Boolean,
			   protection:Boolean;
	
	public function ELMMO(evt:String, lstnr:Function, ar:Boolean, en:Boolean, p:Boolean) {
		event = evt; listener = lstnr; auto_remove = ar; enabled = en; protection = p;		
	}
}