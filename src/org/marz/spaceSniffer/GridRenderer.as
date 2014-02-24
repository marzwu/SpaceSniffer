package org.marz.spaceSniffer {
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    import shinater.swing.Label;
    import shinater.swing.TextArea;

    public class GridRenderer extends Sprite {
        private var label:Label;

        public function GridRenderer() {
            super();
            label = new Label('path 0');
        }

        public function update(fileTree:FileTree, rect:Rectangle):void {
            if (depth > 2)
                return;

            if (rect.width < 5 || rect.height < 5)
                return;

            graphics.clear();
            graphics.lineStyle(1);
			if(fileTree.file.isDirectory)
				graphics.beginFill(0x008888, .8);
			else
				graphics.beginFill(0xffffff, .8);
			
            graphics.drawRect(0, 0, rect.width, rect.height);
			graphics.endFill();

            var name:String = fileTree.file.nativePath.substr(fileTree.file.nativePath.lastIndexOf('/') + 1);
			label.setAutoSize('left');
			label.setText(name + ': ' + fileTree.size);
			
			if(rect.width < label.width)
				label.setText(fileTree.size+'');
				
            if (rect.width >= label.width && rect.height >= label.height)
                addChild(label);

            horizal = rect.width > rect.height;

            if (fileTree.file.isDirectory) {
                var list:Array = fileTree.getDirectoryListing();
                var cursor:int;
                for each (var i:FileTree in list) {
                    var renderer:GridRenderer = new GridRenderer;
                    renderer.depth = depth + 1;

                    if (horizal) {
                        renderer.x = Math.max(2, int((rect.width - 2 * 2) * (cursor / fileTree.size)));
                        renderer.y = 20;

                        var w:int = int((rect.width - 2 * 2) * i.size / fileTree.size) - 2;
                        var h:Number = rect.height - 20 - 2;
                        renderer.update(i, new Rectangle(0, 0, Math.max(1, w), Math.max(1, h)));
                    } else {
                        renderer.x = 2;
                        renderer.y = 20 + int((rect.height - 20 - 2) * (cursor / fileTree.size));

                        w = rect.width - 2 * 2;
                        h = int((rect.height - 20 - 2) * (i.size / fileTree.size)) - 2;
                        renderer.update(i, new Rectangle(0, 0, Math.max(1, w), Math.max(1, h)));
                    }
                    addChild(renderer);

                    cursor += i.size;
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
    }
}
