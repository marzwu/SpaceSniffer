package {
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import org.marz.spaceSniffer.FileTree;
	import org.marz.spaceSniffer.Grids;
	import org.marz.spaceSniffer.c.ExploreFileTree;
	import org.marz.spaceSniffer.worker.WorkerReady;
	import org.marz.sys.CmdSys;
	import org.marz.sys.Init;
	import org.marz.sys.OnEnterFrame;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class Startup extends SimpleCommand {
		public static const STARTUP:String = 'startup';

		override public function execute(notification:INotification):void {
			StartupProxy.instance.stage = notification.getBody() as Stage;
			initMVC();
			
			sendNotification(Init.INIT);

//			var directories:Array = File.getRootDirectories();
//			sendNotification(Grids.SHOW, new FileTree(directories[0]));

			if (Capabilities.os.indexOf('Mac') > -1)
				var path:String = '/Users/marzwu/Desktop';//Desktop Downloads
			else if (Capabilities.os.indexOf('Win') > -1) {
				path = 'E:/klive/dirty/snatchly';
			} else {
				path = '/';
			}

			var file:File = new File(path);
			sendNotification(Grids.SHOW, new FileTree(file));
		}

		private function initMVC():void {
			facade.registerCommand(CmdSys.ENTER_FRAME, OnEnterFrame);
			facade.registerCommand(WorkerReady.worker_side_ready, WorkerReady);
			facade.registerCommand(ExploreFileTree.EXLORE_FILE_TREE, ExploreFileTree);
			facade.registerCommand(Init.INIT, Init);
			
			facade.registerMediator(new Grids);
		}

	}
}
