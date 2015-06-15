package tests {

    import flash.events.Event;

    public class ELMTestEvent extends Event {
        public static const TEST_EVENT:String = "elmtest:testing123";
		public static const TEST_EVENT0:String = "elmtest:testing456";
		public static const TEST_EVENT1:String = "elmtest:testing789";
		public static const TEST_EVENT2:String = "elmtest:testingabc";
		public static const TEST_EVENT3:String = "elmtest:testingdef";
		public static const COMPLETED:String = "elmtest:complete";
		public static const FAILED:String = "elmtest:failed";
               
        public function ELMTestEvent(param1:String, param2:Boolean = false, param3:Boolean = false) {
            super(param1, param2, param3);            
        }
    }
}