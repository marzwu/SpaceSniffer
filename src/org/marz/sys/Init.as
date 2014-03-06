package org.marz.sys {
    import flash.events.Event;

    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public class Init extends SimpleCommand {
        public static const INIT:String = 'INIT';

        override public function execute(notification:INotification):void {
            StartupProxy.instance.stage.addEventListener(Event.ENTER_FRAME, OnEnterFrameHandler);
        }

        protected function OnEnterFrameHandler(event:Event):void {
            sendNotification(CmdSys.ENTER_FRAME);
        }

    }
}