package org.marz.spaceSniffer.c {
	import flash.utils.getTimer;

	import org.marz.spaceSniffer.m.vo.FileTree;
	import org.marz.spaceSniffer.m.GridsProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ExploreFileTree extends SimpleCommand {
		public static const EXLORE_FILE_TREE:String = 'exlore_file_tree';

		override public function execute(notification:INotification):void {
			var start:int = getTimer();
			var end:Number = start + 30;

			var arr:Array = GridsProxy.instance.fileTreeArr;
			if (arr.length > 0) {
				GridsProxy.instance.dataChanged = true;
				var count:int = 0;
				while (arr.length) {
//					var shiftStart:int = getTimer();
					var ft:FileTree = arr.shift();
//					trace('shift time:', getTimer() - shiftStart);

//					var shiftStart:int = getTimer();
					var directories:Array = ft.getDirectories();
//					trace('getDirectories time:', getTimer() - shiftStart);

					if (ft.file.isDirectory && ft.explored != ft.numDirectories) {
//						var shiftStart:int = getTimer();
						arr = arr.concat(directories);
//						trace('concat time:', getTimer() - shiftStart);
					}

//					if (count > 5) {
//						count = 0;
					if (end < getTimer()) {
						GridsProxy.instance.fileTreeArr = arr;
						trace('elapse time:', getTimer() - start, 'queue length', arr.length);
						break;
					}
//					}
					count++;
				}
			}
		}
	}
}
