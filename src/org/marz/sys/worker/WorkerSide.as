package org.marz.sys.worker {
    import flash.events.Event;
    import flash.system.MessageChannel;
    import flash.system.Worker;

    import org.marz.spaceSniffer.worker.LaunchScan;

    public class WorkerSide {
        private var mainToBack:MessageChannel;

        private var backToMain:MessageChannel;

        public function WorkerSide() {
        }

        private static var _instance:WorkerSide;

        private var processors:Object;

        public static function get instance():WorkerSide {
            if (_instance == null)
                _instance = new WorkerSide;
            return _instance;
        }

        public function init():void {
            var worker:Worker = Worker.current;

            //Listen on mainToBack for SHARPEN events
            mainToBack = worker.getSharedProperty("mainToBack");
            mainToBack.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
            //Use backToMain to dispatch SHARPEN_COMPLETE
            backToMain = worker.getSharedProperty("backToMain");
        }

        public function startWorking():void {
            processors = {};
            processors['launch_scan'] = LaunchScan.launch;
            backToMain.send('worker_side_ready');
        }

        protected function onMainToBack(event:Event):void {
            if (mainToBack.messageAvailable) {
                //Get the message type.
                var msg:*;
                var args:Array = [];
                while (msg = mainToBack.receive())
                    args.push(msg);
                trace(args);

                parse(args);
            }
        }

        private function parse(args:Array):void {
            var func:Function = processors[args.shift()];
            if (func != null)
                func(args);
        }

        public function sendMsg(... args):void {
            while (args.length)
                backToMain.send(args.shift());
        }
    }
}
