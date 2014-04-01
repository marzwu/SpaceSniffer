package org.marz.spaceSniffer.m.vo {
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.marz.spaceSniffer.v.vo.GridRenderer;

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

		private var _size:Number = 0;

		public var deep:int;
		public var numDirectories:uint;
		public var explored:int;

		private var directories:Array;

		public function get size():Number {
			return _size;
		}

		public function addSize(s:Number):Number {
			_size += s;
			sort();
			if (parent)
				parent.addSize(s);
//			trace('size:'+size);
			return size;
		}

		public function getDirectoryListing():Array {
			if (children)
				return children;

			if (file.isDirectory == false)
				return null;

			children = [];

			var sync:Boolean = true;

			if (sync) {
//				var s:int = getTimer();
				var list:Array = file.getDirectoryListing();
//				trace('getDirectoryListing time', getTimer() - s);

				var dSize:Number = parseList(list, children);
				addSize(dSize);
				sort();
			} else {
				file.getDirectoryListingAsync();
				file.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);

				function directoryListingHandler(event:FileListEvent):void {
					var list:Array = event.files;
					parseList(list, children);
				}
			}

			return children;
		}

		private function parseList(list:Array, children:Array):Number {
			var r:Number = 0;
			for each (var i:File in list) {
				var ft:FileTree = new FileTree(i);
				ft.deep = deep + 1;
				ft.parent = this;
				children.push(ft);
				r += ft.size;
			}
			return r;
		}


		public function sort():void {
			var children:Array = getDirectoryListing();
			if (children) {
//				var s:int = getTimer();
				children.sortOn('size', Array.NUMERIC | Array.DESCENDING);
//				trace('sort time', getTimer() - s);
			}
		}

		public function getDirectories():Array {
			if (directories)
				return directories.concat();

			directories = [];
			for each (var i:FileTree in getDirectoryListing()) {
				if (i.file.isDirectory)
					directories.push(i);
			}
			numDirectories = directories.length;

			if (numDirectories == 0 && parent)
				parent.explored++;
			return directories;
		}

		public function group(renderer:GridRenderer, rect:Rectangle, children:Array, size:Number):void {
			var area:Number = rect.width * rect.height;

			var horizal:Boolean = rect.width > rect.height;
			var minArea:Number
			if (horizal)
				minArea = rect.height * rect.height * 0.618;
			else
				minArea = rect.width * rect.width * 0.618;

			var per:Number = minArea / area;

			var sum:Number = 0;
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

					if (dPer < 1)
						group(renderer, curr, interval, sum);
					else {
//						renderer.graphics.lineStyle(1);

						renderGroup(renderer, interval, sum, curr.x, curr.y, curr.width, curr.height);

//						if (interval.length == 1) {
////							renderer.graphics.drawRect(curr.x, curr.y, curr.width, curr.height);
//							render(renderer, interval[0], curr.x, curr.y, curr.width, curr.height);
//						} else {
//							var dHorizal:Boolean = curr.width > curr.height;
//							var dd:int;
//							if (dHorizal) {
//								dd = curr.width * interval[0].size / sum;
////                                renderer.graphics.drawRect(curr.x, curr.y, dd, curr.height);
////                                renderer.graphics.drawRect(curr.x + dd, curr.y, curr.width - dd, curr.height);
//								render(renderer, interval[0], curr.x, curr.y, dd, curr.height);
//								render(renderer, interval[1], curr.x + dd, curr.y, curr.width - dd, curr.height);
//							} else {
//								dd = curr.height * interval[0].size / sum;
////                                renderer.graphics.drawRect(curr.x, curr.y, curr.width, dd);
////                                renderer.graphics.drawRect(curr.x, curr.y + dd, curr.width, curr.height - dd);
//								render(renderer, interval[0], curr.x, curr.y, curr.width, dd);
//								render(renderer, interval[1], curr.x, curr.y + dd, curr.width, curr.height - dd);
//							}
//						}
					}

					group(renderer, rect.clone(), children, size - sum);
					break;
				}
			}
		}

		private function renderGroup(renderer:GridRenderer, interval:Array, sum:Number, x:Number, y:Number, width:Number, height:Number):void {
			var dHorizal:Boolean = width > height;
			var dd:int;
			var cursor:Number = 0;
			for each (var i:FileTree in interval) {
				var scale:Number = cursor / sum;
				if (dHorizal) {
					dd = width * scale;
					render(renderer, i, x + dd, y, width * i.size / sum, height);
				} else {
					dd = height * scale;
					render(renderer, i, x, y + dd, width, height * i.size / sum);
				}
				cursor += i.size;
			}
		}

		private function render(renderer:GridRenderer, f:FileTree, x:Number, y:Number, width:Number, height:Number):void {
			var r:GridRenderer = new GridRenderer;
			r.x = x;
			r.y = y;
			r.depth = renderer.depth + 1;
			r.update(f, new Rectangle(0, 0, width, height));
			renderer.addChild(r);
		}
	}
}
