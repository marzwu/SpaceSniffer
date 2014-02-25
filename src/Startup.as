package {
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import org.marz.spaceSniffer.FileTree;
	import org.marz.spaceSniffer.Grids;
	import org.marz.sys.CmdSys;
	import org.marz.sys.OnEnterFrame;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class Startup extends SimpleCommand {
		public static const STARTUP:String = 'startup';

		override public function execute(notification:INotification):void {
			initMVC();

			StartupProxy.instance.stage = notification.getBody() as Stage;
			
			facade.registerCommand(CmdSys.ENTER_FRAME, OnEnterFrame);

//			var directories:Array = File.getRootDirectories();
//			sendNotification(Grids.SHOW, new FileTree(directories[0]));

			if (Capabilities.os.indexOf('Mac') > -1)
				var path:String = '/Users/marzwu/Desktop';
			else if (Capabilities.os.indexOf('Win') > -1) {
				path = 'F:/';
			} else {
				path = '/';
			}

			var file:File = new File(path);
			sendNotification(Grids.SHOW, new FileTree(file));
		}

		private function initMVC():void {
			facade.registerMediator(new Grids);
		}

	}
}
