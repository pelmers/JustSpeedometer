import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Timer;

// position api:
// https://developer.garmin.com/connect-iq/api-docs/Toybox/Position.html

// simple app example:
// https://github.com/klimeryk/garmodoro/blob/master/source/GarmodoroApp.mc

class JustSpeedometerApp extends Application.AppBase {
    hidden var appTimer;
    hidden var view = new JustSpeedometerView();


    function initialize() {
        System.println("onInitialize()");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("onStart()");
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition)); 
        appTimer = new Timer.Timer();
        appTimer.start(method(:onTime), 1000, true);
    }

    function onTime() {
        System.println("onTime()");
        Toybox.WatchUi.requestUpdate();
    }

    function onPosition(info) {
        System.println("onPosition()");
        view.updateViewPosition(info);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        System.println("onStop()");
        Position.enableLocationEvents(Position.LOCATION_DISABLE, null); 
        appTimer.stop();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        System.println("getInitialView()");
        return [ view, new JustSpeedometerDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as JustSpeedometerApp {
    return Application.getApp() as JustSpeedometerApp;
}