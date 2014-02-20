package
{
	import flash.display.Stage;
	
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class StartupProxy extends Proxy
	{
		private static const NAME:String = 'StartupProxy';
		
		public var stage:Stage;
		
		public function StartupProxy()
		{
			super(NAME, null);
		}
		
		public static function get instance():StartupProxy 
		{
			return StartupProxy(Facade.getInstance().retrieveProxy(NAME));
		}
	}
}