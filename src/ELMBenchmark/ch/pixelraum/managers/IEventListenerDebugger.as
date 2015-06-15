package ch.pixelraum.managers
{
	import flash.utils.Dictionary;

	public interface IEventListenerDebugger
	{
		function emDebug( groups:Object, doubleClick:Dictionary ):void;
		function emProfile( msg:String ):void;
	}
}