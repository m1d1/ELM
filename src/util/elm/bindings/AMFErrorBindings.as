package util.elm.bindings {
	/*
    ___________________________________________________________________________________________________

    AMFRemotingErrorBindings - part of ELM {EventListenerManager} rev.2
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
		
	import util.elm.bindings.EventMappings;
	import flash.net.NetConnection;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IEventDispatcher;
	
	/**
	 * Easy AMFErrorBindings with ELM 	 	
	 */
	public class AMFErrorBindings {
		
		
		/**
		 * Bind AMF error events of a NetConnection to one Listener Function and to one Group.
		 *
		 * @example <listing version="4.0">
		 * import util.elm.bindings.AMFErrorBindings;		 
		 *
		 * package {
		 *     public class MyClass extends MovieClip {
		 * 
		 *         var con:NetConnection;
		 *         public function MyClass() {
		 * 		       con  = new NetConnection();
		 * 		       AMFErrorBindings.bindTo(con, conErrorHandler, ["amfErrorGroup"]);
		 *         }
		 * 
		 *         public function conErrorHandler(e:*) {
		 * 		       switch (e.type) {
		 * 		           case IOErrorEvent.IO_ERROR:
		 * 		               trace("IOError: "+e.toString());
		 * 		               break;
		 * 		           case NetStatusEvent.NET_STATUS:
		 * 		               if (e.info.code == "NetConnection.Call.Failed") {
         *                         e.info.code = "Can't connect to the Server!\nAre you connected to the Internet?\nOr ServerScript (PHP) Error";
		 *	                   } 
		 *	                   trace("netStatusHandler: "+ e.info.code);
		 * 		              break;
		 * 		           case SecurityErrorEvent.SECURITY_ERROR:
		 * 		              trace("SecurityError: "+e.toString());
		 * 		              break;
		 * 		       }
		 *         }
		 * }
		 * </listing>
		 */
		public static function bindTo(con:NetConnection, fct:Function, group:String, io:Boolean=true, net:Boolean=true, sec:Boolean=true):void {		
			var map:EventMappings = new EventMappings();
			map.addItem(io, IOErrorEvent.IO_ERROR);
			map.addItem(net, NetStatusEvent.NET_STATUS);
			map.addItem(sec, SecurityErrorEvent.SECURITY_ERROR);
			
			EventMappings.bind(con, fct, [group], map.getIterator());
			map = null;  //  free res.
		}		
		public static function bindTo2(con:NetConnection, fct:Function, groups:Array, io:Boolean=true, net:Boolean=true, sec:Boolean=true):void {		
			var map:EventMappings = new EventMappings();
			map.addItem(io, IOErrorEvent.IO_ERROR);
			map.addItem(net, NetStatusEvent.NET_STATUS);
			map.addItem(sec, SecurityErrorEvent.SECURITY_ERROR);

			if (groups.length == 0) groups[0] = "AMF_ERROR";
			EventMappings.bind(con, fct, groups, map.getIterator());
			map = null;  //  free res.
		}		
	}
}