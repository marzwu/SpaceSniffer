package org.marz.spaceSniffer
{
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GridsProxy extends Proxy
	{
		private static const NAME:String = 'GirdsProxy';
		public var fileTree:FileTree;
		public function GridsProxy()
		{
			super(NAME, null);
		}
		
		public static function get instance():GridsProxy
		{
			return GridsProxy(Facade.getInstance().retrieveProxy(NAME));
		}
	}
}