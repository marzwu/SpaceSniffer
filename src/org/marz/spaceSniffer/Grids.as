package org.marz.spaceSniffer
{
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class Grids extends Mediator
	{
		private static const NAME:String = 'Grids';
		
		public static const SHOW:String = 'show';
		public static const UPDATE:String = 'update';
		
		public function Grids()
		{
			super(NAME, new GridRenderer);
			
			facade.registerProxy(new GridsProxy);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW:
					GridsProxy.instance.fileTree = notification.getBody() as FileTree;
					show();
					break;
				default:
					break;
			}
		}
		
		private function show():void
		{
			StartupProxy.instance.stage.addChild(gridRenderer);
			var rect:Rectangle = new Rectangle(0, 0, 
				StartupProxy.instance.stage.stageWidth, StartupProxy.instance.stage.stageHeight);
			gridRenderer.depth = 0;
			gridRenderer.update(GridsProxy.instance.fileTree, rect);
		}
		
		public function get gridRenderer():GridRenderer 
		{
			return getViewComponent() as GridRenderer;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW, UPDATE];
		}
		
		public static function get instance():Grids 
		{
			return Grids(Facade.getInstance().retrieveMediator(NAME));
		}
	}
}