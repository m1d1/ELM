package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;			
	import templates.*;
	import util.elm.ELM;

	[SWF (width="550", height = "706", backgroundColor="0x323232", frameRate="30")] 

	public class ELMBenchmark extends Sprite{
		/*
		//  Stage size: 		550x800px
		//  testCycles:			How many cycles running through the testValues.		
		//	testValues:			no of generated Sprites/IEventDispatchers
		//  testDdelay:			between cycles. default = 20ms (prevents flashplayer from freezing
		*/
		private const testDelay:uint = 100, // ms 100
					  testCycles:int = 5, //5
					  testValues:Array = [25, 50, 75, 100, 150, 200, 250, 350, 500, 1000],
					  testColors:Array = [0xebebeb, 0x000000, 0xFF0000, 0x0000FF, 0x00FF00],
					  BENCHVERSION:String = "ELM-Benchmark 1.36";

		private static var currentTest:int = -2;
		
		var currentCycle:int = 0,
		    testNo:int = -1,
		    resultArr:Array = [],
			
			resultStringTitle:String = BENCHVERSION+", Settings: delay = "+testDelay+" ms, cycles = "+testCycles+", Player: " + Capabilities.version,
			resultStringAVG:String = "AVERAGE RESULTS\n\n",
			resultString1k:String = testValues[int(testValues.length-1)]+" Sprites | "+(3*testValues[int(testValues.length-1)])+" Events\n\n",
			testTemplate:TemplateBase = null,
			baseMemory:Number = 0,
			memStatsStr:String = "start | peak MB: ",
		    startMemory:Number = 0,			
		    endMemory:Number = 0,
			peakMemory:Number = -1,
			startTime:Number = 0,
			endTime:Number = 0,
			sleeps:uint = 0,
		    timer:Timer = null,
			tfMemoryStatus:TextField;

		public function ELMBenchmark() {			
			trace(Capabilities.version+" / "+Capabilities.playerType);			
			stage.frameRate = 30;
			stage.scaleMode = "noScale";
			tfMemoryStatus = new TextField();
			tfMemoryStatus.defaultTextFormat = new TextFormat("_sans", "10", 0xFFFFFF, true, null, null, null, "center"); 
			tfMemoryStatus.setTextFormat(tfMemoryStatus.defaultTextFormat);
			tfMemoryStatus.x = 15;  tfMemoryStatus.y = 680; tfMemoryStatus.width = 500;			
			addChild(tfMemoryStatus);			
			nextTest();
		}
		public function nextTest():void {			
			testTemplate = null;
			runGC();
			switch (++currentTest) {
				case -1: // init run
					testTemplate = new InitTemplate();
					break;								
				case 0: // Flash				
					testTemplate = new FlashTemplate();
					break;					
				case 1: // AS3 Signals
					testTemplate = new SignalsTemplate();
					break;				
				case 2: // ELM									
					testTemplate = new ELMTemplate();
					break;				
				case 3: //  EventListenerManager						
					testTemplate = new EVLTemplate();					
					break;
				case 4:	// EventController
					testTemplate = new EventControllerTemplate();
					break;				
				case 5: //  Rabbit
					 //  needs to run last due to massive memory consumption
					testTemplate = new RabbitTemplate();					
					break;				
				default:
					showFinalResult();					
					return;
			}			
			resultArr = [];
			currentCycle = 0;
			testNo = -1;
			timer = null;
			sleeps = 0;			
			startMemory = getMem();
			memStatsStr = "start | peak MB:\t ["+(startMemory/1024).toFixed(2)+" | ";
			var tfInfo:TextField = new TextField();
			tfInfo.defaultTextFormat = new TextFormat("Arial", "18", 0xFFFFFF, true, null, null); //, "center"
			tfInfo.defaultTextFormat.align = "center";
			tfInfo.width = stage.stageWidth; tfInfo.y = int(stage.stageHeight / 5);
			tfInfo.autoSize = "center";			
			addChild(tfInfo);
			tfInfo.text = (currentTest == -1) ? BENCHVERSION+"\ninitialization" : BENCHVERSION+"\ntesting:\n\n"+testTemplate.getTitle();			
			runGC();
			startTime = getTimer();
			sleep(2000);
		}		
		private function startTest() {
			clearTestPattern();						
			if (++testNo >= testValues.length) {				
				if (++currentCycle >= testCycles) {
					endTime = getTimer();
					endTime -=  2000 - int(((sleeps-1)*testDelay));					
					prepTestResult();
					nextTest();
					return;
				}
				testNo = 0;
			}
			/*  Basic Test */
			createTestPattern();
			runGC();
			addHandler();
			runGC();
			disableHandler();
			runGC();
			enableHandler();
			runGC();
			removeHandler();
			
			/*  Extended Random Test
			createRandomTestPattern();
			runGC();
			addRandomHandler();
			runGC();
			disableRandomHandler();
			runGC();
			enableRandomHandler();
			runGC();
			removeRandomHandler();
			*/		
			
			
			sleep(testDelay);
		}
		private function showFinalResult() {
			tfMemoryStatus.text = "";
			var headline:TextField = new TextField();			
			var result:TextField = new TextField();
			var result2:TextField = new TextField();			
			headline.defaultTextFormat = result.defaultTextFormat = result2.defaultTextFormat = new TextFormat("Verdana", "10", 0xFFFFFF, false, null, null, null, "left");
			headline.wordWrap = result.wordWrap = result2.wordWrap = true;
			headline.x = result.x = 10; result2.x = 275; 			
			result.y = result2.y = 32; headline.y = 10;
			headline.width = 530; result.width = result2.width = 250; result.height = result2.height = 666;
			addChild(headline);addChild(result);addChild(result2);
			headline.text = resultStringTitle;
			result.text = resultStringAVG;
			result2.text = resultString1k;
			//trace(ELM.length());
			ELM.showAll();
		}
		//
		private function prepTestResult():void {
			runGC();
			if (currentTest == -1) return;
			endMemory = getMem();		
			resultStringAVG += "< "+testTemplate.getTitle()+" >\nbenchtime | mem use | peak mem\n"+
							Number((endTime-startTime)/1000).toFixed(2)+" sec | "+
							Number((endMemory-startMemory)/1024).toFixed(2)+" MB | ";

			var avgAddTime:Number = 0,
				avgAddMem:Number = 0,
				avgDisableTime:Number = 0,
				avgDisableMem:Number = 0,
				avgEnableTime:Number = 0,
				avgEnableMem:Number = 0,
				avgRemoveTime:Number = 0,
				avgRemoveMem:Number = 0,
				len:uint = uint(testValues.length-1);
				peakMemory = 0;
				
			for (var i:uint = 0; i < resultArr.length; i++) {				
				avgAddTime += Number(resultArr[i].endTime - resultArr[i].startTime);
				avgAddMem += Number(resultArr[i].endMem - resultArr[i].startMem);
				peakMemCheck(Number(resultArr[i].endMem));
				i++;
				avgDisableTime += Number(resultArr[i].endTime - resultArr[i].startTime);
				avgDisableMem += Number(resultArr[i].endMem - resultArr[i].startMem);
				peakMemCheck(Number(resultArr[i].endMem));
				i++;
				avgEnableTime += Number(resultArr[i].endTime - resultArr[i].startTime);
				avgEnableMem += Number(resultArr[i].endMem - resultArr[i].startMem);
				peakMemCheck(Number(resultArr[i].endMem));
				i++;
				avgRemoveTime += Number(resultArr[i].endTime - resultArr[i].startTime);
				avgRemoveMem += Number(resultArr[i].endMem - resultArr[i].startMem);
				peakMemCheck(Number(resultArr[i].endMem));												
			}

			resultStringAVG += Number((peakMemory-startMemory)/1024).toFixed(2)+" MB\n\n"+
							"add:     "+Number(avgAddTime/len).toFixed(2)+" ms | "+Number(avgAddMem/len).toFixed(2)+" kb\n"+
							"remove:  "+Number(avgRemoveTime/len).toFixed(2)+" ms | "+Number(avgRemoveMem/len).toFixed(2)+" kb\n";
							
			resultStringAVG += (testTemplate.isManager && testTemplate.getTitle().indexOf("Signals") == -1 && testTemplate.getTitle().indexOf("Controller") == -1) ?
								"enable:  "+Number(avgEnableTime/len).toFixed(2)+" ms | "+Number(avgEnableMem/len).toFixed(2)+" kb\n"+
								"disable: "+Number(avgDisableTime/len).toFixed(2)+" ms | "+Number(avgDisableMem/len).toFixed(2)+" kb\n\n"
								: "enable:  N/A ms | N/A kb\n"+"disable:  N/A ms | N/A kb\n\n";
							
							
			if (currentCycle >= testCycles && testNo >= testValues.length) {					
					i -=4;
					resultString1k += "< "+testTemplate.getTitle()+" >\n\n\n\n"+					
							"add:     "+Number(resultArr[i].endTime - resultArr[i].startTime).toFixed(2)+" ms | "+Number(resultArr[i].endMem - resultArr[i].startMem).toFixed(2)+" kb\n"+
							"remove:  "+Number(resultArr[int(i+3)].endTime - resultArr[int(i+3)].startTime).toFixed(2)+" ms | "+Number(resultArr[int(i+3)].endMem - resultArr[int(i+3)].startMem).toFixed(2)+" kb\n";
					resultString1k += (testTemplate.isManager && testTemplate.getTitle().indexOf("Signals") == -1 && testTemplate.getTitle().indexOf("Controller") == -1) ?
							"enable:  "+Number(resultArr[int(i+2)].endTime - resultArr[int(i+2)].startTime).toFixed(2)+" ms | "+Number(resultArr[int(i+2)].endMem - resultArr[int(i+2)].startMem).toFixed(2)+" kb\n"+
							"disable: "+Number(resultArr[int(i+1)].endTime - resultArr[int(i+1)].startTime).toFixed(2)+" ms | "+Number(resultArr[int(i+1)].endMem - resultArr[int(i+1)].startMem).toFixed(2)+" kb\n\n"
							: "enable:  N/A ms | N/A kb\n"+"disable:  N/A ms | N/A kb\n\n";
			}			
		}
		private function peakMemCheck(n:Number):void {
			if (n > peakMemory) peakMemory = n;
		}
		//
		private function addHandler():void {	
			var len:int = numChildren;
			startTimer();			
			while (--len > 0) {
				testTemplate.addL(getChildAt(len), MouseEvent.CLICK, dummyHandler);
				testTemplate.addL(getChildAt(len), MouseEvent.MOUSE_OVER, dummyHandler);
				testTemplate.addL(getChildAt(len), MouseEvent.MOUSE_OUT, dummyHandler);
			}
			endTimer();
		}
		private function disableHandler():void {
			startTimer()		
			testTemplate.disableL();
			endTimer();
		}
		private function enableHandler():void {
			startTimer();
			testTemplate.enableL();
			endTimer();
		}
		//
		private function removeHandler():void {			
			var len:int = numChildren;
			startTimer();
			while (--len > -1) {				
				testTemplate.removeL(getChildAt(len), MouseEvent.CLICK, dummyHandler);
				if (testTemplate.isManager || testTemplate is EventControllerTemplate) break;
				testTemplate.removeL(getChildAt(len), MouseEvent.MOUSE_OVER, dummyHandler);
				testTemplate.removeL(getChildAt(len), MouseEvent.MOUSE_OUT, dummyHandler);
			}
			endTimer();
		}
		private function createTestPattern() {
			var xp:uint = 0; var yp:uint = 0,
			total:int = testValues[testNo],
			rw:uint = 21, rh:uint = 9, stepX:uint = rw+1, stepY:uint = rh+1;

			while (--total > -1) {
				var spr:Sprite = new Sprite();
				spr.graphics.beginFill(Number(testColors[currentTest]));
				spr.graphics.drawRect(0,0, rw,rh);
				spr.graphics.endFill();
				spr.x = xp; spr.y = yp;
				spr.mouseEnabled = false;
				addChild(spr);

				xp += stepX;
				if (xp >= 550) {
					xp = 0;
					yp += stepY;
				}
			}
		}
		private function clearTestPattern() {
			while (numChildren > 1) {
				removeChildAt(int(numChildren-1));
			}
		}
		private function startTimer():void {			
			if (testCycles == int(currentCycle+1)) 
				resultArr.push(new ResultObj(numChildren, getTimer(), 0, getMem(), 0));
		}
		private function endTimer():void {
			if (testCycles == int(currentCycle+1)) {
				resultArr[int(resultArr.length-1)].endTime = getTimer();
				resultArr[int(resultArr.length-1)].endMem = getMem();
			}
		}
		/**
		* Forces the garbage collector to run. This is used internally to reduce the impact of GC operations on tests,
		* and to measure memory usage. (by Grant Skinner - www.gskinner.com/blog PerformanceTest2)
		**/
		public static function runGC():void {
			try {
				new LocalConnection().connect("_FORCE_GC_");
				new LocalConnection().connect("_FORCE_GC_");
			} catch(e:*) {}
		}
		private function getMem():Number {
			var mem:Number = Math.round(System.totalMemory/ 1024);						
			return mem;
		}
		private function sleep(sv:int):void {
			sleeps++;
			timer = new Timer(sv, 1);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			tfMemoryStatus.text = memStatsStr+(getMem()/1024).toFixed(2)+" MB ]";
		}
		private function timerHandler(e:TimerEvent=null):void {
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			timer = null;
			startTest();
		}
		private function dummyHandler(e:*):void {
			throw new ArgumentError("ERROR EVENT MUST NOT BE FIRED!");
		}
	}
}
internal class ResultObj {
	public var sprites:uint,
			   startTime:uint,
			   endTime:uint,
			   startMem:int,
			   endMem:int;

	public function ResultObj(spr:uint, st:uint, et:uint, sm:int, em:int):void {		
		sprites = spr-1; startTime = st; endTime = et; startMem = sm; endMem = em;
	}
}
