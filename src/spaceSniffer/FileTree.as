package spaceSniffer {
    import flash.filesystem.File;

    public class FileTree {
        public var file:File;

        public function FileTree(file:File) {
            this.file = file;
            if (file.isDirectory == false) {
                try {
                    size = file.size;
                } catch (e:Error) {
                    trace(e.message);
                }
            }
        }

        public var parent:FileTree;

        private var children:Array;

        public var size:int;

        public function getDirectoryListing():Array {
            if (children)
                return children;

            if (file.isDirectory) {
                children = [];
                var list:Array = file.getDirectoryListing();
                for each (var i:File in list) {
                    var ft:FileTree = new FileTree(i);
                    children.push(ft);
                    size += ft.size;
                }
            }

            return children;
        }

        public function explore(deep:int):void {
            if (deep > 1)
                return;

            getDirectoryListing();

            for each (var i:FileTree in children) {
                i.explore(deep + 1);
            }
        }
    }
}