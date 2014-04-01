package org.marz.spaceSniffer.v {
	import flash.display.DisplayObject;
	import flash.filesystem.File;

	import org.bellona.utils.UIUtils;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import shinater.swing.Button;
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

					window.getContent().removeChildren();
					var x:int = 0;
					var y:int = 0;
					for each (var i:File in notification.getBody()) {
						var button:Button = new Button(i.name);
						button.setAutoSize(true);

						button.x = x;
						button.y = y;
						window.getContent().addChild(button);
						x += button.getWidth();
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
