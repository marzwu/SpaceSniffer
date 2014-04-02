package org.marz.spaceSniffer.v {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import org.bellona.utils.UIUtils;
	import org.marz.spaceSniffer.m.vo.FileTree;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import shinater.swing.Button;
	import shinater.swing.List;
	import shinater.swing.Panel;
	import shinater.swing.Window;

	public class PickVolumeMediator extends Mediator {
		private static const NAME:String = 'PickVolumeMediator';

		public static const SHOW_VOLUMES:String = 'showVolumes';
		public static const PICK_A_VOLUME:String = 'pickAVolume';

		public function PickVolumeMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
		}

		override public function listNotificationInterests():Array {
			return [SHOW_VOLUMES, PICK_A_VOLUME];
		}

		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case PICK_A_VOLUME:

					break;
				case SHOW_VOLUMES:
					window.setTitle('选择一个磁盘');


					var panel:Panel = window.getContent();
					panel.removeChildren();

					var lst:List = new List;
					lst.setSize(120, 150);
					panel.addChild(lst);

					var okBtn:Button = new Button('确定');
					okBtn.x = 160;
					okBtn.addEventListener(MouseEvent.CLICK, function onOkBtn(event:MouseEvent):void {
						var volume:String = String(lst.getSelectedItem());
						if (volume) {
							var file:File = new File(volume);
							sendNotification(GridsMediator.SHOW, new FileTree(file));
							UIUtils.removeFromParent(window);
						}
					});
					panel.addChild(okBtn);

					for each (var i:File in notification.getBody()) {
						lst.addItem(i.name);
					}

					window.closeButton.visible = false;
					window.setResizable(false);
					window.setModal(true);
					window.setVisible(true);
					Global.stage.addChild(window);
					UIUtils.centerToStage(window, window.stage);
					break;
				default:
					break;
			}
		}


		private function get window():Window {
			return Window(viewComponent);
		}
	}
}
