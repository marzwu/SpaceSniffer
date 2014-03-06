package org.marz.spaceSniffer.c
{
	import org.marz.spaceSniffer.Grids;
	import org.puremvc.as3.patterns.facade.Facade;

	public class Refresh
	{
		public function Refresh()
		{
		}
		
		public static function doRefresh():void
		{
			Facade.getInstance().sendNotification(Grids.UPDATE);
		}
	}
}