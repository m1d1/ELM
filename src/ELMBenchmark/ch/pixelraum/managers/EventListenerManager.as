package ch.pixelraum.managers
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectUtil;
	
	public class EventListenerManager
	{
		public static const DEFAULT_GROUP_NAME : String = "default";
		
		public static const ADD                : String = "add";
		public static const REMOVE             : String = "remove";
		public static const DISABLE            : String = "disable";
		public static const ENABLE             : String = "enable";
		
		private static var map           : Array = new Array();
		private static var disabledMap   : Array;
		private static var changesMap    : Array = new Array();
		
		public static function reset():void{
			remove( null, "", null, "", true );
		}
		
		public static function add( obj:IEventDispatcher, type:String, listener:Function, groupname:String=DEFAULT_GROUP_NAME, execute:Boolean=false ):void{
			var o:Object = { o:obj, t:type, l:listener, active:true, action:ADD };
			o[ groupname ] = true;
			changesMap.push( o );
			if( execute ) applyChanges();
		}
		
		public static function remove( obj:IEventDispatcher=null, event:String="", listener:Function=null, group:String="", execute:Boolean=false ):void{
			var m:int = mode( obj, event, listener, group );
			m == 0 ? removeAll() : modify( m, REMOVE, obj, event, listener, group );
			if( execute ) applyChanges();
		}
		
		private static function removeAll():void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].active ) map[ i ].o.removeEventListener( map[ i ].t, map[ i ].l );
			}
			disabledMap = null;
			changesMap = new Array();
			map = new Array();
		}
		
		public static function disable( obj:IEventDispatcher=null, event:String="", listener:Function=null, group:String="", execute:Boolean=false ):void{
			var m:int = mode( obj, event, listener, group );
			m == 0 ? disableAll() : modify( m, DISABLE, obj, event, listener, group );
			if( execute ) applyChanges();
		}
		
		private static function disableAll():void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].active ) map[ i ].o.removeEventListener( map[ i ].t, map[ i ].l );
				map[ i ].active = false;
			}
		}
		
		public static function enable( obj:IEventDispatcher=null, event:String="", listener:Function=null, group:String="", execute:Boolean=false ):void{
			var m:int = mode( obj, event, listener, group );
			m == 0 ? enableAll() : modify( m, ENABLE, obj, event, listener, group );
			if( execute ) applyChanges();
		}
		
		private static function enableAll():void{
			var i:int = map.length;
			while( --i > -1 ){
				if( !map[ i ].active ) map[ i ].o.addEventListener( map[ i ].t, map[ i ].l );
				map[ i ].active = true;
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		private static function modify( mode:int, action:String, obj:IEventDispatcher=null, event:String="", listener:Function=null, group:String="" ):void{
			switch( mode ){
				case 0:
					
					break;
				case 1:
					modifyObject( obj, action );
					break;
				case 10:
					modifyEvent( event, action );
					break;
				case 11:
					modifyObjectEvent( obj, event, action );
					break;
				case 100:
					modifyListener( listener, action );
					break;
				case 101:
					modifyObjectListener( obj, listener, action );
					break;
				case 110:
					modifyEventListener( event, listener, action );
					break;
				case 111:
					modifyObjectEventListener( obj, event, listener, action );
					break;
				case 1000:
					modifyGroup( group, action );
					break;
				case 1001:
					modifyObjectGroup( group, obj, action );
					break;
				case 1010:
					modifyEventGroup( event, group, action );
					break;
				case 1011:
					modifyEventListenerGroup( event, listener, group, action );
					break;
				case 1100:
					modifyListenerGroup( listener, group, action );
					break;
				case 1101:
					modifyObjectListenerGroup( obj, listener, group, action );
					break;
				case 1110:
					modifyObjectEventGroup( obj, event, group, REMOVE );
					break;
				case 1111:
					modifyObjectEventListenerGroup( obj, event, listener, group, action );
					break;
			}
		}
		
		private static function modifyGroup( groupname:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ][ groupname ] == true ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
				} 
			}
		}
		
		private static function modifyObjectGroup( groupname:String, obj:Object, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ][ groupname ] == true && map[ i ].o == obj ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObjectEventGroup( obj:Object, event:String, groupname:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ][ groupname ] == true && map[ i ].o == obj && map[ i ].t == event ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObject( obj:Object, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].o == obj ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObjectEvent( obj:Object, event:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event && map[ i ].o == obj ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObjectEventListener( obj:Object, event:String, listener:Function, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event && map[ i ].o == obj && map[ i ].l == listener ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObjectEventListenerGroup( obj:Object, event:String, listener:Function, group:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event && map[ i ].o == obj && map[ i ].l == listener && map[ i ][ group ] == true ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObjectListener( obj:Object, listener:Function, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].l == listener && map[ i ].o == obj ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyObjectListenerGroup( obj:Object, listener:Function, group:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].l == listener && map[ i ].o == obj && map[ i ][ group ] == true ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyEvent( event:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyEventListenerGroup( event:String, listener:Function, group:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event && map[ i ].l == listener && map[ i ][ group ] == true ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyEventGroup( event:String, group:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event && map[ i ][ group ] == true ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyEventListener( event:String, listener:Function, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].t == event && map[ i ].l == listener ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyListener( listener:Function, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].l == listener ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		private static function modifyListenerGroup( listener:Function, group:String, action:String ):void{
			var i:int = map.length;
			while( --i > -1 ){
				if( map[ i ].l == listener && map[ i ][ group ] == true ){
					map[ i ].active = false;
					map[ i ].action = action;
					changesMap.push( map[ i ] );
					map.splice( i, 1 );
				} 
			}
		}
		
		public static function applyChanges():void{
			var i:int = changesMap.length;
			while( --i > -1 ){
				switch( changesMap[ i ].action ){
					case ADD:
						changesMap[ i ].o.addEventListener( changesMap[ i ].t, changesMap[ i ].l );
						map.push( changesMap[ i ] );
						break;
					case REMOVE:
						changesMap[ i ].o.removeEventListener( changesMap[ i ].t, changesMap[ i ].l );
						break;
				}
			}
			changesMap = new Array();
		}
		
		private static function mode( obj:Object=null, event:String="", listener:Function=null, group:String=""):int{
			var p:uint = obj != null ? 1 : 0;
			p += event != "" ? 10 : 0;
			p += listener != null ? 100 : 0;
			p += group != "" ? 1000 : 0;
			return p;
		}
	}
}