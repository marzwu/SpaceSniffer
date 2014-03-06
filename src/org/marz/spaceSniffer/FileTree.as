package org.marz.spaceSniffer {
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	public class FileTree {
		public var file:File;

		public function FileTree(file:File) {
			this.file = file;
			if (file.isDirectory == false) {
				try {
					addSize(file.size);
				} catch (e:Error) {
					trace(e.message);
				}
			}
		}

		public var parent:FileTree;

		private var children:Array;

		private var _size:int;

		public var deep:int;

		public static var COUNT:int;

		public function get size():int {
			return _size;
		}

		public function addSize(s:int):int {
			_size += s;
			if (parent)
				parent.addSize(s);
			return size;
		}

		public function getDirectoryListing():Array {
			if (children)
				return children;

			if (file.isDirectory == false)
				return null;

			children = [];
			var list:Array = file.getDirectoryListing();
			for each (var i:File in list) {
				var ft:FileTree = new FileTree(i);
				ft.deep = deep + 1;
				ft.parent = this;
				children.push(ft);
				addSize(ft.size);
			}

			return children;
		}

		public function explore(maxDeep:int):void {
			trace(COUNT++);
			trace(file.nativePath);

			if (deep > maxDeep)
				return;

			for each (var i:FileTree in getDirectoryListing()) {
				i.explore(maxDeep);
			}
		}

		public function sort():void {
			var children:Array = getDirectoryListing();
			if (children)
				children.sortOn('size', Array.NUMERIC | Array.DESCENDING);

			for each (var i:FileTree in getDirectoryListing()) {
				i.sort();
			}

		}

		public function group(renderer:GridRenderer, rect:Rectangle, children:Array, size:int):void {
			var area:Number = rect.width * rect.height;

			var horizal:Boolean = rect.width > rect.height;
			var minArea:Number
			if (horizal)
				minArea = rect.height * rect.height * 0.618;
			else
				minArea = rect.width * rect.width * 0.618;

			var per:Number = minArea / area;

			var sum:int = 0;
			var interval:Array = [];
			var w:Number = rect.width;
			var h:Number = rect.height;

			while (children.length) {
				var i:FileTree = children.shift();
				sum += i.size;
				interval.push(i);


				var dPer:Number = sum / size;
				if (dPer >= per) {
					var curr:Rectangle = rect.clone();
					if (horizal) {
						w = int(dPer * area / h);
						curr.width = w;

						rect.x += w;
						rect.width -= w;
					} else {
						h = int(dPer * area / w);
						curr.height = h;

						rect.y += h;
						rect.height -= h;
					}

					if (interval.length > 2)
						group(renderer, curr, interval, sum);
					else {
						renderer.graphics.lineStyle(1);
						if (interval.length == 1)
							renderer.graphics.drawRect(curr.x, curr.y, curr.width, curr.height);
						else {
							var dHorizal:Boolean = curr.width > curr.height;
							var dd:int;
							if (dHorizal) {
								dd = curr.width * interval[0].size / sum;
								renderer.graphics.drawRect(curr.x, curr.y, dd, curr.height);
								renderer.graphics.drawRect(curr.x + dd, curr.y, curr.width - dd, curr.height);
							} else {
								dd = curr.height * interval[0].size / sum;
								renderer.graphics.drawRect(curr.x, curr.y, curr.width, dd);
								renderer.graphics.drawRect(curr.x, curr.y + dd, curr.width, curr.height - dd);
							}
						}
					}

					group(renderer, rect.clone(), children, size - sum);
					break;
				}
			}
		}
	}
}
