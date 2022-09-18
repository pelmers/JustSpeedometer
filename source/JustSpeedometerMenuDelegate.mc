import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class JustSpeedometerMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :itemUnits) {
            WatchUi.pushView( new Rez.Menus.UnitsMenu(), new JustSpeedometerUnitsMenuDelegate(), WatchUi.SLIDE_UP );
        } else if (item == :itemAbout) {
            // TODO: make an about screen
            WatchUi.pushView( new JustSpeedometerAboutView(), null, WatchUi.SLIDE_UP );
        }
    }
}