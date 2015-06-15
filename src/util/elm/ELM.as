package util.elm {
	/*
    ___________________________________________________________________________________________________

    ELM {EventListenerManager} 1.51
    http://code.google.com/p/as3listenermanager/
    ___________________________________________________________________________________________________

	
    Copyright (c) 2008-2011 Michael Dinkelaker, E-Mail: ilabor[at]gmail[dot]com

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
	import util.elm.ELMObject;
	import util.elm.iterator.ELMIterator;
	import util.elm.loggers.IELMLogger;
	import util.elm.loggers.TraceLogger;
	import util.elm.profiler.IELMProfilable;
	
	/**
	 * ELM Main Class.
	 */
	public class ELM {		
		/** @default LOG_LISTING				sets logging filter level.
		 * 										messages with the set value or greater will be logged.
		 *	  									values are:
		 *	  											LOG_LISTING:int = 1 (default show all),
		 *	  											LOG_SHOWING:int = 2
		 *	 							       			LOG_PROFILING:int = 3
		 *	 											LOG_INFO:int	= 20
		 *	  											LOG_WARNING:int = 40
		 *	               								LOG_ERROR:int   = 60		 	
		 **/
		public static var verboseLevel:int   = LOG_LISTING;
		/** @default false	set this to true if you want to enable the useCapture in addEventListener() **/		
		public static var useCapture:Boolean = false;	
		/** @default false set this to true if you want to use the Iterator to access the last modified Objects **/
		public static var useIterator:Boolean = false;
		/** @private logger **/
		public static var logger:IELMLogger;
		/** @private profilerFunction **/
		public static var profilerFunction:Function = null;
		
		/** @private objList **/
		private static var objList:Array;		
				
		/** @private lastModifiedObjects **/
		private static var lastModifiedObjects:Array;
		/** @private showLogTitle **/
		private static var showLogTitle:String = "";

		public static const VERSION:String = "1.52";
		public static const	AUTHOR:String = "Michael Dinkelaker";		
		public static const	LOG_LISTING:int = 1;
		public static const	LOG_SHOWING:int = 2;
		public static const	LOG_PROFILING:int = 3;
		public static const	LOG_INFO:int	= 20;
		public static const	LOG_WARNING:int = 40;
		public static const	LOG_ERROR:int   = 60;
		public static const	JOB_DISABLE:String = "DISABLE";
		public static const	JOB_ENABLE:String = "ENABLE";
		public static const	JOB_REMOVE:String = "REMOVE";
		public static const	JOB_SHOW:String = "SHOW";
		public static const	JOB_ADD:String = "ADD";
		public static const	AUTOREMOVE:String = "AUTO_REMOVE";
		public static const	PROTECTED:String = "PROTECTED";
		/** @private GROUP **/				
		public static const	GROUP:String  = "group";
		/** @private GROUPS **/				
		public static const	GROUPS:String  = "groups";
		/** @private EVENT **/		
		public static const	EVENT:String  = "event";
		/** @private OBJECT **/				
		public static const	OBJECT:String = "object";
		/** @private LISTENER **/
		public static const	LISTENER:String = "listener";
				
		// ________________________________________________________________________________PUBLIC METHODS
		/** @private **/
		public function ELM() {
			logIt("this static class should not be instantiated.", LOG_ERROR);
        }
		
		/**
		* Adds an eventListener
		*		
		* @param group String="" (optional) (since v1.28 ELM can handle more Groups. 
		* To keep it compatible with prior releases you can add only one group here. @see ELM.addGroups())
		* @param special String="" (optional) ELM.PROTECTED or ELM.AUTOREMOVE
		* PROTECTED mappings can't be disabled or removed
		* AUTOREMOVE mappings can't be disabled 
		*
		* @example
		* <listing version="4.0">import util.elm.ELM;
		*  ELM.add(mySprite, MouseEvent.CLICK, mouseHandler);  //  add with no group
		*  ELM.add(mySprite0, MouseEvent.CLICK, mouseHandler, "myGroup");  //  add to group "myGroup";
		*  ELM.add(mySprite0, MouseEvent.MOUSE_OVER, mouseHandler, "otherGroup");  //  mySprite0 belongs to "myGroup" and "otherGroup" (since 1.50)
		*  ELM.add(mySprite1, MouseEvent.CLICK, mouseHandler, "myGroup", ELM.AUTOREMOVE);  //  same group, but autoremoving when triggered
		*  ELM.add(mySprite2, MouseEvent.CLICK, mouseHandler, "myGroup", ELM.PROTECTED);  //  same group, but protected (not removable)
		*  function mouseHandler(e:MouseEvent):void {
		*      trace("after this click you can't click me again - because auto_remove was set to true!");
		*  }
		* </listing>
		*/		
		public static function add(obj:IEventDispatcher, evt:String, fct:Function, group:String="", special:String=""):void {
			init();
			var autoremove:Boolean = (special == AUTOREMOVE) ? true : false,
				protection:Boolean = (special == PROTECTED) ? true : false,
				i:int = findELMObject(obj);
				
			if (i == -1) objList.push(new ELMObject(obj, evt, fct, group, autoremove, protection));				
			
			else {
				var eObj:ELMObject = ELMObject(objList[i]);
				if (eObj.findEventMapping(evt, fct) == -1) {
					if (group != "") eObj.modifyGroupNames([group], true);  //  v1.5 - multiple groups allowed
					eObj.addEventMapping(evt, fct, autoremove, protection);					
				} else  logIt(obj+" already mapped event '"+evt+"' to that same function", LOG_INFO);
			}
		}
		/**
		* Adds an eventListener but with multiple groupnames
		* @param groups Array with groupname strings per element
		*
		* * @example
		* <listing version="4.0">import util.elm.ELM;
		*  ELM.add(mySprite, MouseEvent.CLICK, mouseHandler, ["myGroup", "otherGroup"]);
		* </listing>   		
		*/ 
		public static function add2(obj:IEventDispatcher, evt:String, fct:Function, groups:Array, special:String=""):void {
			if (groups.length == 0) groups[0] = "";
			add(obj, evt, fct, String(groups[0]), special);
			if (groups.length > 1) addGroupNames(obj, groups);			
		}
		/**
		* Adds eventMappings (event/listener) from an existing EventDispatcher to (multiple) other EventDispatchers
		* this is useful if you want to bind several buttons with the same events and listener method.
		* note that the enabled/disabled state, autoremove/protected and all groupnames will be cloned, too.
		* 
		* @param obj IEventDispatcher existing EventDispatcher in ELM to clone to
		* @param arr IEventDispatchers array with new EventDispatchers
		*
		* * @example
		* <listing version="4.0">import util.elm.ELM;
		*  ELM.add(mySprite, MouseEvent.CLICK, mouseHandler, "myGroup");
		*  ELM.add(mySprite, MouseEvent.ROLL_OVER, mouseHandler);  
		*  ELM.add(mySprite, MouseEvent.ROLL_OUT, mouseHandler); 
		* 
		*  ELM.cloneAdd(mySprite, [otherSprite, btn0, btn1, btn2]);  //  clone click, rollover, rollout, "myGroup" to mouseHandler to btn0 - btn2
		* 
		* 
		* </listing>   		
		*/ 
		public static function cloneAdd(obj:IEventDispatcher, arr:Array):void {
			var i:int = findELMObject(obj), mapMe:*, eM:Array, eObj:ELMObject, grps:Array = [], s:String;
			if (i > -1) {				
				eObj = ELMObject(objList[i]);
				eM = eObj.getEventMappings();
				for (s in Object(eObj.groups)) grps.push(s);
				
				while (arr.length > 0) {
					mapMe = arr.pop();
					if (mapMe is IEventDispatcher) {
						i = eM.length;
						while (--i > -1) {
							s = (eM[i].auto_remove) ? AUTOREMOVE : (eM[i].protection) ? PROTECTED : "";
							add2(mapMe, eM[i].event, eM[i].listener, grps, s);
							if (!eM[i].enabled) disableObj(mapMe, eM[i].event);
						}						
					} else logIt(mapMe + " is not an EventDispatcher, can't cloneAdd!", LOG_INFO);
				}
			} else logIt("cloneAdd failed! couldn't find EventDispatcher: "+mapMe+" to clone", LOG_WARNING);
		}
		
		
		//	________________________________________________________________________________ FacadingFunctions
		//	______ GROUP
		/**
		 * Add more group names to an EventDispatcher  
		 *
		 * @example add groupA and pageC to spr" 
		 * <listing version="4.0"> 
		 * ELM.add(spr, MouseEvent.CLICK, mouseHandler, "myGroup");
		 * ELM.add(spr, MouseEvent.ROLL_OVER, mouseHandler, "otherGroup"); 
		 * ELM.addGroupNames(spr, ["groupA", "pageC"]);  //  spr belongs to groups: "myGroup, otherGroup, groupA, pageC"
		 * </listing>
		 */
		public static function addGroupNames(obj:IEventDispatcher, grpArr:Array):void {
			var i:int = findELMObject(obj);
			if (i > -1) ELMObject(objList[i]).modifyGroupNames(grpArr, true);				
			else logIt(obj+" wasn't found, can't add more groupnames", LOG_WARNING); 
			
		}
		/**
		 * Remove group names from an EventDispatcher
		 *
		 * @example <listing version="4.0">
		 *  ELM.add(mySprite0, MouseEvent.CLICK, mouseHandler, "myGroup");  //  add to group "myGroup";
		 *  ELM.add2(mySprite0, MouseEvent.MOUSE_OVER, mouseHandler, ["otherGroup", "groupC"]);  //  mySprite0 belongs to "myGroup", "otherGroup" and "groupC"		 
		 *  ELM.removeGroupNames(mySprite0, ["otherGroup, "groupC"]); //  mySprite0 belongs to group "myGroup"
		 * </listing>
		 */
		public static function removeGroupNames(obj:IEventDispatcher, grpArr:Array):void {
			var i:int = findELMObject(obj);
			if (i > -1) ELMObject(objList[i]).modifyGroupNames(grpArr, false);
			else logIt(obj+" wasn't found, can't remove groupnames", LOG_WARNING); 
		}
		/**
		 * Remove all eventMappings from a group 
		 *
		 * @example remove all member events of group "myGroup" 
		 * <listing version="4.0"> ELM.removeGroup("myGroup");
		 * ELM.removeGroup("myGroup", "otherGroup", "groupC"); //  since 1.50 remove three groups
		 * </listing>
		 */
		public static function removeGroup(...grps):void {
			var i:int = grps.length;
			while (--i > -1) {				
				if (grps[i] is String && grps[i] != "") prepWithOptions(new ParseOptions(JOB_REMOVE, null, "", null, String(grps[i])));				
			}						
		}
		/**
		 * Disable all eventMappings from a group
		 *
		 * @example disable all member events of group "myGroup" <listing version="4.0"> ELM.disableGroup("myGroup");
		 * ELM.disableGroup("myGroup", "otherGroup", "groupC"); //  since 1.50 disable three groups
		 * </listing>
		 */		
		public static function disableGroup(...grps):void {
			var i:int = grps.length;
			while (--i > -1) {				
				if (grps[i] is String && grps[i] != "") prepWithOptions(new ParseOptions(JOB_DISABLE, null, "", null, String(grps[i])));
			}						
		}
		/**
		 * Enable all eventMappings from a group
		 *
		 * @example enable all member events of group "myGroup" <listing version="4.0"> ELM.enableGroup("myGroup");
		 * ELM.enableGroup("myGroup", "otherGroup", "groupC"); //  since 1.50 enable three groups 
		 * </listing>
		 */
		public static function enableGroup(...grps):void {
			var i:int = grps.length;
			while (--i > -1) {				
				if (grps[i] is String && grps[i] != "") prepWithOptions(new ParseOptions(JOB_ENABLE, null, "", null, String(grps[i])));
			}						
		}
		/**
		 * Show all eventMappings from a group
		 *
		 * @example show all member events of group "myGroup" <listing version="4.0"> ELM.showGroup("myGroup");</listing>
		 */
		public static function showGroup(grp:String):void {
			showLogTitle = "group: "+grp;			
			prepWithOptions(new ParseOptions(JOB_SHOW, null, "", null, grp));
		}
		//	______ EVENTS
		/**
		 * Remove all eventMappings with a specific event	
		 *
		 * @example remvove all clicks: <listing version="4.0"> ELM.removeEvent(MouseEvent.CLICK);</listing>
		 */
		public static function removeEvent(evt:String):void {
			prepWithOptions(new ParseOptions(JOB_REMOVE, null, evt));
		}
		/**
		 * Enable all eventMappings with a specific event
		 *
		 * @example enable all clicks: <listing version="4.0"> ELM.enableEvent(MouseEvent.CLICK);</listing>
		 */
		public static function enableEvent(evt:String):void {
			prepWithOptions(new ParseOptions(JOB_ENABLE, null, evt));			
		}
		/**
		 * Disable all eventMappings with a specific event
		 *
		 * @example disable all clicks: <listing version="4.0"> ELM.disableEvent(MouseEvent.CLICK);</listing>
		 */
		public static function disableEvent(evt:String):void {
			prepWithOptions(new ParseOptions(JOB_DISABLE, null, evt));
		}
		/**
		 * Show all eventMappings with a specific event
		 *
		 * @example show all clicks <listing version="4.0"> ELM.showEvent(MouseEvent.CLICK);</listing>
		 */
		public static function showEvent(evt:String):void {
			showLogTitle = "event: "+evt;
			prepWithOptions(new ParseOptions(JOB_SHOW, null, evt));
		}
		//	______ LISTENER
		/**
		 * Remove all eventMappings which are mapped to a specific function
		 *
		 * @example <listing version="4.0"> ELM.removeListener(mouseHandler);</listing>
		 */
		public static function removeListener(fct:Function):void {
			prepWithOptions(new ParseOptions(JOB_REMOVE, null, "", fct));
		}
		/**
		 * Enable all eventMappings which are mapped to a specific function
		 *
		 * @example <listing version="4.0"> ELM.enableListener(mouseHandler);</listing>
		 */
		public static function enableListener(fct:Function):void {
			prepWithOptions(new ParseOptions(JOB_ENABLE, null, "", fct));
		}
		/**
		 * Disables all eventMappings which are mapped to a specific function
		 *
		 * @example <listing version="4.0"> ELM.disableListener(mouseHandler);</listing>
		 */
		public static function disableListener(fct:Function):void {
			prepWithOptions(new ParseOptions(JOB_DISABLE, null, "", fct));
		}
		/**
		 * Show all eventMappings which are mapped to a specific function
		 *
		 * @example <listing version="4.0"> ELM.showListener(mouseHandler);</listing>
		 */
		public static function showListener(fct:Function):void {
			showLogTitle = "listener: "+fct;
			prepWithOptions(new ParseOptions(JOB_SHOW, null, "", fct));
		}						
		//	______ LISTENER+EVENT
		/**
		 * Remove all eventMappings which are mapped to a specific event and function 
		 *	
		 * @example <listing version="4.0"> ELM.removeListenerEvent(mouseHandler, MouseEvent.CLICK);</listing>
		 */
		public static function removeListenerEvent(fct:Function, evt:String):void {
			prepWithOptions(new ParseOptions(JOB_REMOVE, null, evt, fct));
		}
		/**
		 * Enable all eventMappings which are mapped to a specific event and function		
		 *
		 * @example <listing version="4.0"> ELM.enableListenerEvent(mouseHandler, MouseEvent.CLICK);</listing>
		 */
		public static function enableListenerEvent(fct:Function, evt:String):void {
			prepWithOptions(new ParseOptions(JOB_ENABLE, null, evt, fct));
		}
		/**
		 * Disable all eventMappings which are mapped to a specific event and function
		 *
		 * @example <listing version="4.0"> ELM.disableListenerEvent(mouseHandler, MouseEvent.CLICK);</listing>
		 */
		public static function disableListenerEvent(fct:Function, evt:String):void {
			prepWithOptions(new ParseOptions(JOB_DISABLE, null, evt, fct));
		}
		/**
		 * Show all eventMappings which are mapped to a specific event and function
		 *
		 * @example <listing version="4.0"> ELM.showListenerEvent(mouseHandler, MouseEvent.CLICK);</listing>
		 */
		public static function showListenerEvent(fct:Function, evt:String):void {
			showLogTitle = "listener: "+fct+" and event: "+evt;
			prepWithOptions(new ParseOptions(JOB_SHOW, null, evt, fct));
		}
		//	______ OBJECT
		/**
		 * Remove eventmappings from a specific EventDispatcher with optional specific event
		 * if no event is given all events will be removed from the EventDispatcher. 
		 *
		 * @param evt String="" (optional). 
		 *
		 * @example <listing version="4.0"> ELM.removeObj(mySprite, MouseEvent.CLICK);</listing>
		 */
		public static function removeObj(obj:IEventDispatcher, evt:String=""):void {
			prepWithOptions(new ParseOptions(JOB_REMOVE, obj, evt));
		}
		/**
		 * Disable eventmappings from a specific EventDispatcher with optional specific event
		 * if no event is given all EventDispatcher's events will be disabled. 
		 *		 
		 * @param evt String="" (optional). 
		 *
		 * @example <listing version="4.0"> ELM.disableObj(mySprite, MouseEvent.CLICK);</listing>
		 */
		public static function disableObj(obj:IEventDispatcher, evt:String=""):void {
			prepWithOptions(new ParseOptions(JOB_DISABLE, obj, evt));
		}
		/**
		 * Enable eventmappings from a specific EventDispatcher with optional specific event
		 * if no event is given all EventDispatcher's events will be enabled. 
		 *	
		 * @param evt String="" (optional).
		 *
		 * @example <listing version="4.0"> ELM.enableObj(mySprite, MouseEvent.CLICK);</listing>
		 */
		public static function enableObj(obj:IEventDispatcher, evt:String=""):void {
			prepWithOptions(new ParseOptions(JOB_ENABLE, obj, evt));
		}
		/**
		 * Show eventmappings from a specific EventDispatcher with optional specific event
		 * if the optional event is given, it only shows that in the logger if present.
		 *
		 * @param evt (optional). 
		 *
		 * @example <listing version="4.0"> ELM.showObj(mySprite);</listing>
		 */
		public static function showObj(obj:IEventDispatcher, evt:String=""):void {
			showLogTitle = "object: "+obj+ (evt == "") ? evt : " and event: "+evt;
			prepWithOptions(new ParseOptions(JOB_SHOW, obj, evt));
		}						
		//	______ MOD.ALL
		/**
		 * Enable all disabled eventMappings
		 *
		 * @example <listing version="4.0"> ELM.enableAll();</listing>
		 */
		public static function enableAll():void {			
			var opt:ParseOptions = new ParseOptions(JOB_ENABLE); opt.criterias = -1;
			prepWithOptions(opt);
		}
		/**
		 * Disable all enabled eventMappings
		 *
		 * @example <listing version="4.0"> ELM.disableAll();</listing>
		 */
		public static function disableAll():void {
			var opt:ParseOptions = new ParseOptions(JOB_DISABLE); opt.criterias = -1;
			prepWithOptions(opt);
		}
		/**
		 * Remove all eventMappings
		 *
		 * @example <listing version="4.0"> ELM.removeAll();</listing>
		 */
		public static function removeAll():void {
			var opt:ParseOptions = new ParseOptions(JOB_REMOVE); opt.criterias = -1;
			prepWithOptions(opt);
		}
		/**
		 * Show all EventDispatchers, events, groups and properties
		 *
		 * @example <listing version="4.0"> ELM.showAll();</listing>
		 */
		public static function showAll():void {
			showLogTitle = "ALL";
			var opt:ParseOptions = new ParseOptions(JOB_SHOW); opt.criterias = -1;
			prepWithOptions(opt);
		}
		//	______ MISC
		/**
		 * This installs the logger class of your choice which handles ELM's
		 * info, warn and error messages. 
		 * (show, listing, profiling messages = info)
		 * 
		 * By default ELM uses the util.elm.loggers.TraceLogger
		 * There are some presets for Arthropod, ThunderboldAS3, DeMonsterDebugger, etc.
		 * You need to download the logger classes yourself, these are not included with ELM. 
		 * check: util.elm.loggers - open the .as template and read all informations are in there!
		 * 				 		  		
		 * @param log class instance which implements the IELMLogger
		 *
		 * @example <listing version="4.0">
		 * import util.elm.ELM;		 
		 * import util.elm.loggers.ThunderBoldAS3;
		 *
		 * package {
		 *     public class MyClass extends Sprite {
		 *
		 *         public function MyClass() {
		 * 		       ELM.installLogger(new ThunderBoldAS3());		 
		 * 			   // ELM.installLogger(new Arthropod());
		 *         }		 	
		 * }
		 * </listing>

		 */		
		public static function installLogger(l:IELMLogger):void {
			init();
			logger = l;
			startLogger();
		}
		/**
		 * This (re)sets the ELM logger to the default util.loggers.TraceLogger
		 * @see installLogger
		 *
		 * @example <listing version="4.0"> ELM.initLogger();</listing>
		 */
		public static function initLogger():void {
			logger = new TraceLogger();
			startLogger();
		}
		/**
		 * This installs a custom profiling method which generates trace-outs about
		 * the current ELM operation.
		 * This might come handy for application debugging and profiling.
		 * The users class needs to implement the util.profiler.IELMProfilable Interface.
		 * The required method interceptFilter returns true or false.
		 * If it returns true the current action will generate a traced-out or log.
		 * See example below.
		 *
		 * @param c Class which implements the IELMprofilable Interface
		 *
		 *
		 * @example <listing version="4.0">
		 * import util.elm.ELM;
		 * import util.elm.profiler.IELMProfilable;
		 * import flash.display.Sprite;
		 * import flash.events.IEventDispatcher;
		 * import flash.events.MouseEvent;
		 *
		 * package {
		 *     public class MyClass extends Sprite implements IELMProfilable {
		 *
		 *         public function MyClass() {
		 *             ELM.installProfiler(this);  //  installs the profiler
		 *             ELM.add(this, MouseEvent.CLICK, mouseHandler, "myGroup");
		 *         }
		 *
		 *         function interceptFilter(obj:IEventDispatcher, group:String, job:String, mObj:Object):Boolean {		 
		 *                 //
		 *                 // obj:IEventDispatcher -- current EventDispatcher
		 *                 // group:String -- group name
		 *                 // job:String -- current job. Use constants for comparisons:
		 *                 //     ELM.JOB_ADD, ELM.JOB_REMOVE, ELM.JOB_DISABLE, ELM.JOB_ENABLE, ELM.JOB_SHOW
		 *                 //
		 * 				   // mObj is the ELMObjects internal class ELMMO (short for ELM Mapping Object) 
		 *                 // mObj.event:String --  current Event
		 *                 // mObj.listener:Function -- current EventHandler Function
		 *                 // mObj.auto_remove:Boolean -- true if it's auto_remove
		 *                 // mObj.enabled:Boolean -- true if Event is enabled
		 *
		 *                 //  profile all ADDs
		 *                 if (job == ELM.JOB_ADD) return true;  //  true = trace-out action
		 *                 else return false;  //  false = don't 
		 *         }
		 *     }
		 * }
		 * </listing>
		 */
		public static function installProfiler(c:IELMProfilable):void {
			ELM.init();
			profilerFunction = c.interceptFilter;
		}
		/**
		 * Remove/uninstall profiling
		 * @see installProfiler
		 *
		 * @example <listing version="4.0"> ELM.uninstallProfiler();</listing>
		 */
		public static function uninstallProfiler():void {
			profilerFunction = null;
		}
		/**
		 * List all Groups in the logger
		 *
		 * @example <listing version="4.0"> ELM.listGroups();</listing>
		 */
		public static function listGroups():void {
			prepListing(GROUPS, "available groups");
		}
		/**
		 * List all EventDispatchers and their Events in the logger
		 *
		 */
		public static function listObjects():void {
			prepListing(OBJECT, "mapped Objects");
		}
		/**
		 * List all EventDispatchers and their Events with the auto_remove property in the logger
		 *
		 * @example <listing version="4.0"> ELM.listAutoRemoves();</listing>
		 */
		public static function listAutoRemoves():void {
			prepListing(AUTOREMOVE, "auto removing events");
		}
		/**
		 * List all EventDispatchers and their Events with the protected property in the logger
		 *
		 * @example <listing version="4.0"> ELM.listAutoRemoves();</listing>
		 */
		public static function listProtected():void {
			prepListing(PROTECTED, "protected events");
		}
		
		/** @private */
		private static function prepListing(prop:String, title:String):void {
			var arr:Array = [], str:String = "", n:int = 0, i:int = objList.length;
			while (--i > -1) {
				switch (prop) {
					case AUTOREMOVE:
					case PROTECTED:
						str += ELMObject(objList[i]).showEventMappings(prop);
						break;
					case GROUPS:
						for (str in ELMObject(objList[i]).groups) {
							arr.push(str);
						}
						str = "";						
						break;
					default:
						arr.push(ELMObject(objList[i])[prop]);
						break;					
				}				
			}
			if ( (prop == AUTOREMOVE || prop == PROTECTED) && str == "") str = "- nothing found -";
			else if (str == "" && (i = arr.length) == 0) str = "- empty -";
			else if (str == "") {
				arr.sort(2);
				while (--i > -1) {
					if (i > 0 && arr[i] == arr[int(i-1)]) arr.splice(i,1);
					else {
						n++; str += (str == "") ? "'"+arr[i]+"'" : ", '"+arr[i]+"'";
					}
				}
			}
			arr = null;
			str = (prop == AUTOREMOVE || prop == PROTECTED) ? title +" "+str+"\n" : title + "("+n+"): "+str;
			logIt(str, LOG_LISTING);
		}
		/**
		 * Returns the length of ELM's EventDispatchers objects.
		 * Each object can listen to several events
		 *
		 * @return length of changed EventDispatchers
		 *
		 * @example <listing version="4.0"> var val:int = ELM.lastChangesLength();</listing>
		 */
		public static function length():int {
			return objList.length;
		}
		/**
		 * Returns how many EventDispatchers were modified by the last performed operation.
		 * This concerns only the last remove, disable or enable operation. 
		 * add, show, lists operations don't change or reset this value.
		 * Call ELM.resetIterator(); to reset this value to zero.
		 *
		 * @return length of changed EventDispatchers
		 *
		 * @example <listing version="4.0"> var val:int = ELM.lastChangesLength();</listing>
		 */
		public static function lastChangesLength():int {
			return lastModifiedObjects.length;
		}
		/**
		 * Returns how many EventDispatchers and Events are mapped
		 *
		 * @example <listing version="4.0"> ELM.status();</listing>
		 */
		public static function status():void {
			var i:int = objList.length, e:int = 0;
			while (--i > -1) e += ELMObject(objList[i]).eventMappingsLength();
			logIt("ELM is managing "+objList.length+" object/s with "+e+" event/s", LOG_INFO);
		}
		/** 
		 * Reset the result Iterator
		 * @see getIterator()   
		 *
		 * @example <listing version="4.0"> ELM.resetIterator();</listing>
		 */
		public static function resetIterator():void {
			lastModifiedObjects = [];
		}
		/**
		 * Returns an iterator of the last modified EventDispatchers
		 * NOTE THAT 
		 * ELM.useIterator = true 
		 * must be set to enable this feature, by default it's disabled!
		 *
		 * @return ELMIterator
		 *
		 * @example <listing version="4.0">
		 *
		 * import util.elm.ELM;
		 * import util.elm.iterator.ELMIterator;
		 *
		 * //  add two Sprites
		 * ELM.add(mySprite0, MouseEvent.CLICK, mouseHandler, "myGroup", true);
		 * ELM.add(mySprite1, MouseEvent.CLICK, mouseHandler, "myGroup", true);
		 *
		 * //  remove Events
		 * ELM.useIterator = true; //  this must be set anywhere only once, since it's a static var!
		 * ELM.removeGroup("myGroup");
		 *
		 * //  remove Children from Stage
		 * var it:ELMIterator = ELM.getIterator();
		 * while (it.hasNext()) {
		 *     removeChild(it.next());
		 * }
		 * </listing>
		 */
		public static function getIterator():ELMIterator {
			if (!useIterator) logIt("ELM.getIterator() was called, but useIterator is set to false, enable it with ELM.userIterator = true!!!", LOG_ERROR);
			return new ELMIterator(lastModifiedObjects);
		}
		/**
		 * Returns an iterator of ELM's current EventDispatchers
		 * For test purposes only!!! Use for read-only.
		 *
		 * @return ELMIterator
		 *
		 * @see getIterator()   		
		 */
		public static function getELMIterator():ELMIterator {
			return new ELMIterator(objList);
		}		
		
		/** @private */
		public static function logIt(msg:String, level:int):void {			
			if (level >= verboseLevel) {
				var f:Function;
				var txt:String = "# ELM "+VERSION+" ";
				switch (level) {
					case LOG_LISTING: txt += "<LISTING>"; f = logger.info; break;
					case LOG_SHOWING: txt += "<SHOWING>"; f = logger.info; break;
					case LOG_INFO:    txt += "<INFO>"; f = logger.info; break;
					case LOG_WARNING: txt += "<WARNING>"; f = logger.warn; break;
					case LOG_ERROR:   txt += "<ERROR>"; f = logger.error; break;
					case LOG_PROFILING: txt += "<PROFILING>"; f = logger.info; break;
				}
				if (showLogTitle != "") {
					txt += " "+showLogTitle;
					showLogTitle = "";
				}				
				f(txt + " " + msg);
				if (level == LOG_ERROR) throw new ArgumentError(txt);				
			}
		}
		//	________________________________________________________________________________CoreFunctions
		
		/**
		 * Initializes ELM
		 * This method will be called automatically when using ELM.add() or ELM.installLogger().
		 * This only needs to be called once. However you may call this manually.
		 *
		 * @example <listing version="4.0"> ELM.init();</listing>
		 */
		public static function init():void {
			if (logger == null) initInstance();
		}
		//	________________________________________________________________________________private METHODS
		/** @private */
		private	static function initInstance():void {			
			objList = []; lastModifiedObjects = [];
			initLogger();			
		}
		/** @private */
		private static function startLogger():void {
			logger.init();
			logger.info("ELM "+VERSION+" - http://code.google.com/p/as3listenermanager/\n");
		}
		/** @private */
		private	static function prepWithOptions(opt:ParseOptions):void {			
			if (opt.criterias == -1 || opt.criterias != 0) modifyListeners(opt);
		}
				
		/** @private */
		private	static function modifyListeners(args:ParseOptions):void {
			var i:int = objList.length, n:int, hitCounter:int, showLog:String = "", evFlag:Boolean, eObj:ELMObject, current:int;
			if (args.job != JOB_SHOW && useIterator) resetIterator();
			while (--i > -1) {
				n = -1;	eObj = ELMObject(objList[i]); current = i;
				if (args.criterias > 0) {
					hitCounter = 0;	evFlag = false;
					
					if (args.hasObject) {												
						if ( (i = findELMObject(args[OBJECT])) > -1) {
							eObj = ELMObject(objList[i]);
							current = i; i = -1; hitCounter++
						}												
					}					
					if (args.hasGroup) {
						if (eObj.findGroup(String(args[GROUP]))) hitCounter++;
					}
					if (args.hasEvent || args.hasListener) {							
						if (!evFlag) {
							if ( (args.hasEvent && args.hasListener) && ( (n = eObj.findEventMapping(args[EVENT], args[LISTENER])) != -1) ) { hitCounter += 2; evFlag = true;}
							else if ( (args.hasEvent && !args.hasListener) && ( (n = eObj.findEventMapping(args[EVENT], null)) != -1) ) hitCounter++;
							else if ( (args.hasListener && !args.hasEvent) && ( (n = eObj.findEventMapping("", args[LISTENER])) != -1) ) hitCounter++;
						}						
					}					
				}
				
				
				if (int(args.criterias) == hitCounter || int(args.criterias) == -1) {
					if (String(args.job) != JOB_SHOW && useIterator) lastModifiedObjects.push(eObj.object);
					switch (String(args.job)) {
						case JOB_ENABLE:
							eObj.enableEventMapping(n);
							break;
						case JOB_DISABLE:
							eObj.disableEventMapping(n);
							break;
						case JOB_REMOVE:
							eObj.removeEventMapping(n);
							if (eObj.eventMappingsLength() == 0) removeELMObject(current);
							break;
						case JOB_SHOW:
							showLog += eObj.showEventMappings();
							break;
					}
				}
			}
			if (args.job == JOB_SHOW) {
				if (showLog == "") showLog = "- nothing found -";
				logIt(showLog, LOG_SHOWING);
			}
			args = null;			
		}
		/** @private */
		public static function findELMObject(obj:IEventDispatcher):int {			
			var i:int = objList.length;
			while (--i > -1) if (ELMObject(objList[i]).object == obj) break;
			return i;			
		}
		/** @private */
		public static function removeELMObject(n:int):void {
			objList.splice(n, 1);
		}
		/** @private 
		 * return ELMObject.groups object as coma seperated String 
		 * for show/list/profiling purposes
		 */
		public static function getGroupsString(obj:Object):String {
			var result:String = "";
			for (var s:String in obj) result += (result == "") ? "'"+s : "', '"+s;
			result = (result != "") ? "["+result+"']" : "["+result+"]"; 
			return result;
		}
	}
}
internal class ParseOptions {	
	import flash.events.IEventDispatcher;
	public var job:String, object:IEventDispatcher, event:String, listener:Function, group:String, criterias:int = 0,
	hasGroup:Boolean, hasEvent:Boolean, hasListener:Boolean, hasObject:Boolean;
	function ParseOptions(j:String, o:IEventDispatcher=null, e:String="", l:Function=null, g:String=""):void {
		job = j;
		if (o != null) {object = o; hasObject = true; criterias++}
		if (e != "") {event = e; hasEvent = true; criterias++}
		if (l != null) {listener = l; hasListener = true; criterias++}
		if (g != "") {group = g; hasGroup = true; criterias++}		
	}	
}
