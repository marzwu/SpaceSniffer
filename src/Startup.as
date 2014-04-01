package {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import org.marz.spaceSniffer.c.ExploreFileTree;
	import org.marz.spaceSniffer.m.vo.FileTree;
	import org.marz.spaceSniffer.v.GridsMediator;
	import org.marz.spaceSniffer.v.PickVolumeMediator;
	import org.marz.sys.CmdSys;
	import org.marz.sys.Init;
	import org.marz.sys.OnEnterFrame;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import shinater.swing.Menu;
	import shinater.swing.MenuBar;
	import shinater.swing.MenuItem;
	import shinater.swing.Window;

	public class Startup extends SimpleCommand {
		public static const STARTUP:String = 'startup';

		override public function execute(notification:INotification):void {
			var stage:Stage = notification.getBody() as Stage;
			Global.stage = stage;
			Global.stage = stage;

			initMVC();

			sendNotification(Init.INIT);

			var directories:Array = File.getRootDirectories();
//			sendNotification(Grids.SHOW, new FileTree(directories[0]));

			if (Capabilities.os.indexOf('Mac') > -1)
				var path:String = '/Users/marzwu/'; //Desktop Downloads
			else if (Capabilities.os.indexOf('Win') > -1) {
//				path = 'E:/klive/dirty/snatchly';
//				path = 'E:/klive/';
				path = 'E:/';
				sendNotification(PickVolumeMediator.SHOW_VOLUMES, directories);
			} else {
				path = '/';
			}

//			var file:File = new File(path);
//			sendNotification(GridsMediator.SHOW, new FileTree(file));
		}

		private function onChange(event:Event):void
		{
			trace(event);
			var getLabel:String = MenuItem(event.target).getLabel();
		}

		private function initMVC():void {
			facade.registerCommand(CmdSys.ENTER_FRAME, OnEnterFrame);
//			facade.registerCommand(WorkerReady.worker_side_ready, WorkerReady);
			facade.registerCommand(ExploreFileTree.EXLORE_FILE_TREE, ExploreFileTree);
			facade.registerCommand(Init.INIT, Init);

			facade.registerMediator(new GridsMediator);
			facade.registerMediator(new PickVolumeMediator(new Window));
		}

	}
}
