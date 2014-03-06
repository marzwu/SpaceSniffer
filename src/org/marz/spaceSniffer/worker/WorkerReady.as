package org.marz.spaceSniffer.worker
{
	import org.marz.sys.worker.MainSide;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class WorkerReady extends SimpleCommand
	{
		public static const worker_side_ready:String = 'worker_side_ready';
		
		override public function execute(notification:INotification):void
		{
			MainSide.instance.sendMsg('hi');
//			MainSide.instance.sendMsg('launch_scan', '/Users/marzwu/Desktop');
		}
		
	}
}