package org.marz.spaceSniffer.m
{
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.marz.spaceSniffer.m.vo.FileTree;
	
	public class GridsProxy extends Proxy
	{
		private static const NAME:String = 'GirdsProxy';
		public var fileTree:FileTree;
		public var fileTreeArr:Array;
		public var dataChanged:Boolean;
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