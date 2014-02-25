package
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	[SWF(width='800', height="600")]
	public class SpaceSniffer extends Sprite
	{
		public function SpaceSniffer()
		{
			initMVC();
		}

		private function initMVC():void
		{
			Facade.getInstance().registerCommand(Startup.STARTUP, Startup);
			Facade.getInstance().registerProxy(new StartupProxy);
			Facade.getInstance().sendNotification(Startup.STARTUP, stage);
		}


	}
}