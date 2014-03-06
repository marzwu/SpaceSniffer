package org.marz.spaceSniffer.worker
{
	import flash.filesystem.File;
	
	import org.marz.spaceSniffer.FileTree;
	import org.marz.sys.worker.WorkerSide;

	public class LaunchScan
	{
		public function LaunchScan()
		{
		}
		
		public static function launch(args:Array):void
		{
			var b:File = new File;
			var file:File = new File(args[0]);
			var ft:FileTree = new FileTree(file);
			WorkerSide.instance.sendMsg('update',ft);
		}
	}
}