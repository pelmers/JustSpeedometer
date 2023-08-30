import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Application.Storage;

class JustSpeedometerView extends WatchUi.View {
    hidden var lastPosition;
    hidden var nSpeedsObserved = 0;
    hidden var maxSpeedsToAverage = 600;
    hidden var currentAvgSpeed = null;
    hidden var unitsFromKphFactor = 1.0;
    hidden var unitsText = "kph";

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        System.println("onLayout()");
        var layout = Rez.Layouts.MainLayout(dc);
        setLayout(layout);
        updateUnits();
        updatePositionDisplay(Position.getInfo());
        updateAvgSpeedDisplay();
    }

    function updateViewPosition(info) {
        System.println("updateViewPosition()");
        lastPosition = info;
        var quality = info.accuracy;
        // Update the current moving average if the quality is good enough
        if (quality == Position.QUALITY_GOOD || quality == Position.QUALITY_USABLE) {
            if (info has :speed && info.speed != null) {
                if (currentAvgSpeed == null) {
                    currentAvgSpeed = info.speed;
                } else {
                    currentAvgSpeed = ((currentAvgSpeed * nSpeedsObserved) + info.speed) / (nSpeedsObserved + 1);
                }
                nSpeedsObserved += 1;
                // Exponential moving average: cap the number of observations
                // in theory if this number was arbitrarily high we would hit precision issues
                if (nSpeedsObserved > maxSpeedsToAverage) {
                    nSpeedsObserved = maxSpeedsToAverage;
                }
            }
        }
    }

    function updatePositionDisplay(pos) {
        System.println("updatePositionDisplay()");
        var quality = pos.accuracy;
        var gpsText = View.findDrawableById("gpsText");
        if (quality == Position.QUALITY_GOOD) {
            gpsText.setText("GPS");
            gpsText.setColor(Graphics.COLOR_GREEN);
        } else if (quality == Position.QUALITY_USABLE) {
            gpsText.setText("GPS");
            gpsText.setColor(Graphics.COLOR_YELLOW);
        } else if (quality == Position.QUALITY_POOR) {
            gpsText.setText("GPS");
            gpsText.setColor(Graphics.COLOR_ORANGE);
        } else if (quality == Position.QUALITY_LAST_KNOWN) {
            gpsText.setText("GPS");
            gpsText.setColor(Graphics.COLOR_RED);
        } else if (quality == Position.QUALITY_NOT_AVAILABLE) {
            gpsText.setText("NO GPS");
            gpsText.setColor(Graphics.COLOR_WHITE);
            return;
        }

        var currentSpeedText = View.findDrawableById("curSpeedValue");
        if (pos has :speed && pos.speed != null) {
            var displaySpeed = pos.speed / 1000 * 3600 * unitsFromKphFactor;
            currentSpeedText.setText(displaySpeed.format("%.1f"));
            currentSpeedText.setColor(Graphics.COLOR_WHITE);
        } else {
            currentSpeedText.setText("0");
            currentSpeedText.setColor(Graphics.COLOR_RED);
        }

        var headingText = View.findDrawableById("headingText");
        if (pos has :heading && pos.heading != null) {
            var deg = pos.heading * 180 / Math.PI;
            // convert from [-180, 180] to 360
            if (deg < 0) {
                deg = 360 + deg;
            }
            var headingLabel;
            if (deg <= 22.5 || deg >= 337.5) {
                headingLabel = "N";
            } else if (deg >= 22.5 && deg <= 67.5) {
                headingLabel = "NE";
            } else if (deg >= 67.5 && deg <= 112.5) {
                headingLabel = "E";
            } else if (deg >= 112.5 && deg <= 157.5) {
                headingLabel = "SE";
            } else if (deg >= 157.5 && deg <= 202.5) {
                headingLabel = "S";
            } else if (deg >= 202.5 && deg <= 247.5) {
                headingLabel = "SW";
            } else if (deg >= 247.5 && deg <= 292.5) {
                headingLabel = "W";
            } else {
                headingLabel = "NW";
            }
            headingText.setText(deg.format("%.0f") + " " + headingLabel);
        } else {
            headingText.setText("--");
        }
    }

    function updateAvgSpeedDisplay() {
        var avgSpeedText = View.findDrawableById("avgSpeedText");
        var avgSpeedUnitText = unitsText;
        if (currentAvgSpeed != null) {
            var speedDisplay = currentAvgSpeed / 1000 * 3600 * unitsFromKphFactor;
            avgSpeedText.setText("AVG: " + speedDisplay.format("%.2f") + avgSpeedUnitText);
        } else {
            avgSpeedText.setText("AVG: --" + avgSpeedUnitText);
        }
    }

    function updateUnits() {
        System.println("updateUnits()");
        var unitTypeValue = Storage.getValue("Properties.unitType");
        if (unitTypeValue == 0) {
            // km
            unitsFromKphFactor = 1.0;
            unitsText = "kph";
        } else if (unitTypeValue == 1) {
            // miles
            unitsFromKphFactor = 0.621371;
            unitsText = "mph";
        } else if (unitTypeValue == 2) {
            // knots
            unitsFromKphFactor = 0.539957;
            unitsText = "kt";
        } else if (unitTypeValue == 3) {
            // m/s
            unitsFromKphFactor = 0.277778;
            unitsText = "m/s";
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        System.println("view onUpdate()");
        updateUnits();
        if (lastPosition != null) {
            updatePositionDisplay(lastPosition);
        }
        updateAvgSpeedDisplay();
        var timeText = View.findDrawableById("timeText");
        // TODO: allow different time formats
        var time = System.getClockTime();
        timeText.setText(time.hour.format("%02d")
                         + ":" + time.min.format("%02d")
                         + ":" + time.sec.format("%02d")
        );
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}
