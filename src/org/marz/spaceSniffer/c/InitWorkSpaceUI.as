package org.marz.spaceSniffer.c {
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import shinater.swing.Menu;
	import shinater.swing.MenuBar;
	import shinater.swing.MenuItem;

	public class InitWorkSpaceUI extends SimpleCommand {
		override public function execute(notification:INotification):void {
			var pickMenu:Menu = new Menu;

			var pickMenuItem:MenuItem = new MenuItem('Pick Volume');
			pickMenuItem.addEventListener(MouseEvent.CLICK, onChange);
			pickMenu.addMenuItem(pickMenuItem);

			var menuBar:MenuBar = new MenuBar;
			menuBar.addMenu(pickMenu);

			Global.stage.addChild(menuBar);

			function onChange(event:MouseEvent):void
			{
				var label:String = MenuItem(event.target).getLabel();
				switch(label)
				{
					case 'Pick Volume':
						
						break;
					default:
						break;
				}
			}
		}


	}
}
