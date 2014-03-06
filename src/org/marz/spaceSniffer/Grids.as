package org.marz.spaceSniffer {
    import flash.geom.Rectangle;
    
    import org.marz.spaceSniffer.c.ExploreFileTree;
    import org.marz.spaceSniffer.c.Refresh;
    import org.marz.sys.OnEnterFrame;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.facade.Facade;
    import org.puremvc.as3.patterns.mediator.Mediator;

    public class Grids extends Mediator {
        private static const NAME:String = 'Grids';

        public static const SHOW:String = 'show';

        public static const UPDATE:String = 'update';
        private var count:int;

        public function Grids() {
            super(NAME, null);

            facade.registerProxy(new GridsProxy);
			OnEnterFrame.addFunc('refresh', Refresh.doRefresh);
        }

        override public function handleNotification(notification:INotification):void {
            switch (notification.getName()) {
                case SHOW:
                    GridsProxy.instance.fileTree = notification.getBody() as FileTree;
					GridsProxy.instance.fileTreeArr = GridsProxy.instance.fileTree.getDirectoryListing().concat();
                    show();
					sendNotification(ExploreFileTree.EXLORE_FILE_TREE);
                    break;
                case UPDATE:
					if(count == 30){
						count = 0;
						dataChanged(GridsProxy.instance.fileTree);
					}
					sendNotification(ExploreFileTree.EXLORE_FILE_TREE);
					count++;
                default:
                    break;
            }
        }

        private function dataChanged(ft:FileTree):void {
            StartupProxy.instance.stage.removeChildren();

            var gridRenderer:GridRenderer = new GridRenderer;
            StartupProxy.instance.stage.addChild(gridRenderer);
            var rect:Rectangle = new Rectangle(0, 0, StartupProxy.instance.stage.stageWidth, StartupProxy.instance.stage.stageHeight);
            gridRenderer.depth = 0;
            gridRenderer.update(ft, rect);
        }

        private function show():void {
//            GridsProxy.instance.fileTree.explore(2);
//            GridsProxy.instance.fileTree.sort();

            StartupProxy.instance.stage.removeChildren();

            var gridRenderer:GridRenderer = new GridRenderer;
            StartupProxy.instance.stage.addChild(gridRenderer);
            var rect:Rectangle = new Rectangle(0, 0, StartupProxy.instance.stage.stageWidth, StartupProxy.instance.stage.stageHeight);
            gridRenderer.depth = 0;
            gridRenderer.update(GridsProxy.instance.fileTree, rect);
        }

        override public function listNotificationInterests():Array {
            return [ SHOW, UPDATE ];
        }

        public static function get instance():Grids {
            return Grids(Facade.getInstance().retrieveMediator(NAME));
        }
    }
}
