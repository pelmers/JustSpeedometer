import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Application.Storage;

class JustSpeedometerUnitsMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :itemKph) {
            System.println("set kph");
            Storage.setValue("Properties.unitType", 0);
        } else if (item == :itemMph) {
            System.println("set mph");
            Storage.setValue("Properties.unitType", 1);
        }
    }
}