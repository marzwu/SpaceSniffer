package org.marz.spaceSniffer.c {
    import flash.utils.getTimer;

    import org.marz.spaceSniffer.FileTree;
    import org.marz.spaceSniffer.GridsProxy;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public class ExploreFileTree extends SimpleCommand {
        public static const EXLORE_FILE_TREE:String = 'exlore_file_tree';

        override public function execute(notification:INotification):void {
            var start:int = getTimer();
            var end:Number = start + 30;

            var arr:Array = GridsProxy.instance.fileTreeArr;
            while (arr.length) {
                var ft:FileTree = arr.shift();
                if (ft.file.isDirectory)
                    arr.concat(ft.getDirectoryListing().concat());

                if (end < getTimer())
                    break;
            }

        }

    }
}