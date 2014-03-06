package org.marz.sys.worker {
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    
    import org.marz.spaceSniffer.worker.LaunchScan;
    import org.puremvc.as3.patterns.facade.Facade;

    public class MainSide {
        private var loaderInfo:LoaderInfo;

        private var worker:Worker;

        private var mainToBack:MessageChannel;

        private var backToMain:MessageChannel;


        public function MainSide() {

        }

        public function init(loaderInfo:LoaderInfo):void {
            this.loaderInfo = loaderInfo;
        }

        public function start():void {
            worker = WorkerDomain.current.createWorker(loaderInfo.bytes); //WorkerFactory.getWorkerFromClass(SharpenWorker, loaderInfo.bytes);

            //Create message channel TO the worker
            mainToBack = Worker.current.createMessageChannel(worker);

            //Create message channel FROM the worker, add a listener.
            backToMain = worker.createMessageChannel(Worker.current);
            backToMain.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain, false, 0, true);

            //Now that we have our two channels, inject them into the worker as shared properties.
            //This way, the worker can see them on the other side.
            worker.setSharedProperty("backToMain", backToMain);
            worker.setSharedProperty("mainToBack", mainToBack);
			
            //Lastly, start the worker.
            worker.start();
        }

        protected function onBackToMain(event:Event):void {
			var msg:*;
			var args:Array = [];
			while(msg = backToMain.receive())
				args.push(msg);
			trace(args);
			
			Facade.getInstance().sendNotification(args.shift(), args);
        }

        private static var _instance:MainSide;

        public static function get instance():MainSide {
            if (_instance == null)
                _instance = new MainSide;
            return _instance;
        }
		
		public function sendMsg(...args):void
		{
			while(args.length)
				mainToBack.send(args.shift());
		}
    }
}