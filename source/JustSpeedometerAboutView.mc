import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Application.Storage;

class JustSpeedometerAboutView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        System.println("about onLayout()");
        var layout = Rez.Layouts.AboutLayout(dc);
        setLayout(layout);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}
