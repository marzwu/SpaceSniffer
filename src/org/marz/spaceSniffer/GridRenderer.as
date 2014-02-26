package org.marz.spaceSniffer {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import org.puremvc.as3.patterns.facade.Facade;

    import shinater.swing.Label;

    public class GridRenderer extends Sprite {
        private static const margin:int = 2;

        private static const min_size:int = 5;

        private static const LABEL_HEIGHT:Number = 20;

        private var label:Label;

        public function GridRenderer() {
            super();
            label = new Label('path 0');

            this.doubleClickEnabled = true;
            addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
            addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
        }

        protected function onRightClick(event:MouseEvent):void {
            if (fileTree.parent) {
                Facade.getInstance().sendNotification(Grids.SHOW, fileTree.parent);
                event.stopImmediatePropagation();
            }
        }

        protected function onDoubleClick(event:MouseEvent):void {
            Facade.getInstance().sendNotification(Grids.SHOW, fileTree);
            event.stopImmediatePropagation();
        }

        public function update(fileTree:FileTree, rect:Rectangle):void {
            this.fileTree = fileTree;

            if (depth > 2)
                return;

            if (rect.width < min_size || rect.height < min_size)
                return;

            graphics.clear();
            graphics.lineStyle(1);
            if (fileTree.file.isDirectory)
                graphics.beginFill(0x008888, .8);
            else
                graphics.beginFill(0xffffff, .8);

            graphics.drawRect(0, 0, rect.width - 1, rect.height - 1);
            graphics.endFill();

            var name:String = fileTree.file.nativePath.substr(fileTree.file.nativePath.lastIndexOf('/') + 1);
            label.setAutoSize('left');
            label.setText(name + ': ' + fileTree.size);

            if (rect.width < label.width)
                label.setText(fileTree.size + '');

            if (rect.width >= label.width && rect.height >= label.height)
                addChild(label);

            horizal = rect.width > rect.height;

            if (fileTree.file.isDirectory) {
                var list:Array = fileTree.getDirectoryListing();
                var sizeCursor:int;
                var clientW:Number = rect.width - min_size * 2;
                var clientH:Number = rect.height - LABEL_HEIGHT - min_size;
				var area:int = clientW * clientH;
                var acturalW:Number = clientW;
                var acturalH:Number = clientH;
				var cursorX:int = min_size;
				var cursorY:int = LABEL_HEIGHT;
                for each (var i:FileTree in list) {
                    var renderer:GridRenderer = new GridRenderer;
                    renderer.depth = depth + 1;
					
					horizal = acturalW > acturalH;

                    if (horizal) {
//                        renderer.x = min_size + int(acturalW * (sizeCursor / fileTree.size));
//                        renderer.y = LABEL_HEIGHT;
                        renderer.x = cursorX;
                        renderer.y = cursorY;

//                        var w:int = acturalW * i.size / fileTree.size;
                        var h:Number = acturalH;
						var w:int = area * (i.size / fileTree.size) / h;
                        renderer.update(i, new Rectangle(0, 0, Math.max(1, w), Math.max(1, h)));
						
						cursorX += w;
						acturalW -= w;
                    } else {
//                        renderer.x = min_size;
//                        renderer.y = LABEL_HEIGHT + int(acturalH * (sizeCursor / fileTree.size));
                        renderer.x = cursorX;
                        renderer.y = cursorY;

                        w = acturalW;
//                        h = acturalH * (i.size / fileTree.size);
                        h = area * (i.size / fileTree.size) / w;
						
                        renderer.update(i, new Rectangle(0, 0, Math.max(1, w), Math.max(1, h)));
						
						cursorY += h;
						acturalH -= h;
                    }
					horizal = !horizal;
					
                    addChild(renderer);

                    sizeCursor += i.size;
                }
            }
        }

        private var _depth:int;

        public function get depth():int {
            return _depth;
        }

        public function set depth(value:int):void {
            if (_depth == value)
                return;
            _depth = value;
        }

        public var horizal:Boolean;

        private var fileTree:FileTree;
    }
}
