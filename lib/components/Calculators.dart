import 'package:e6b_flutter/pages/CalculatorPage.dart';

final calculators = [
  CalculatorPage(
    title: "Pressure and Density Altitude",
    fields: [
      CalculatorField(name: "indicatedAlt", label: "Altitude (feet)"),
      CalculatorField(name: "altimeter", label: "Altimeter Setting (in/hg)"),
      CalculatorField(name: "temperature", label: "Temperature (celsius)"),
    ],
    calculate: (values) {
      final indicated = values["indicatedAlt"]!;
      final altimeter = values["altimeter"]!;
      final temperature = values["temperature"]!;
      final pressureAltitude = ((29.92 - altimeter) * 1000) + indicated;
      final standardTemperature = 15 - ((pressureAltitude / 1000) * 2);
      final densityAltitude =
          pressureAltitude + (120 * (temperature - standardTemperature));

      if (indicated == 0 || altimeter == 0) {
        return "hello";
      }
      if (temperature == 0) {
        return "Pressure Altitude: " +
            pressureAltitude.toStringAsFixed(0) +
            " feet";
      }
      return "Pressure Altitude: " +
          pressureAltitude.toStringAsFixed(0) +
          " feet\nDensity Altitude: " +
          densityAltitude.toStringAsFixed(0) +
          " feet";
    },
  ),
  CalculatorPage(
    title: "Fuel Burn Calculator",
    fields: [
      CalculatorField(name: "time", label: "Time (hours)"),
      CalculatorField(name: "rate", label: "Burn Rate (gal/hr)"),
    ],
    calculate: (values) {
      final t = values["time"]!;
      final r = values["rate"]!;
      return (t * r).toStringAsFixed(1) + " gal";
    },
  ),
  CalculatorPage(
    title: "Ground Speed Calculator",
    fields: [
      CalculatorField(name: "distance", label: "Distance (NM)"),
      CalculatorField(name: "time", label: "Time (hours)"),
    ],
    calculate: (values) {
      final d = values["distance"]!;
      final t = values["time"]!;
      if (t == 0) return "—";
      return (d / t).toStringAsFixed(1) + " kt";
    },
  ),
];
