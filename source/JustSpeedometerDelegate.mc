import Toybox.Lang;
import Toybox.WatchUi;

class JustSpeedometerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new JustSpeedometerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}