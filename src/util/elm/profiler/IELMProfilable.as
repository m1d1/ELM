package util.elm.profiler {
	/*
    ___________________________________________________________________________________________________

    IELMprofiler - part of ELM {EventListenerManager} rev. 6
    http://code.google.com/p/as3listenermanager/
    ___________________________________________________________________________________________________


    Copyright (c) 2010, 2011 Michael Dinkelaker

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

	/**
	 * ELM Profiling Interface
	 * @see ELM.installProfiler(c:IELMProfilable); 	 	
	 */
	public interface IELMProfilable {
		function interceptFilter(obj:IEventDispatcher, groups:Object, job:String, mObj:Object):Boolean;
	}
}