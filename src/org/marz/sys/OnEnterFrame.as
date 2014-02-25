package org.marz.sys {
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public class OnEnterFrame extends SimpleCommand {
        override public function execute(notification:INotification):void {
            for each (var i:Function in funcs) {
                i();
            }
        }

        private static var funcs:Object = {};

        public static function addFunc(key:String, func:Function):void {
            funcs[key] = func;
        }

        public function deleteFunc(key:String):void {
            delete funcs[key];
        }
    }
}