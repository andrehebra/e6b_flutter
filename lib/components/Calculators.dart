import 'dart:math';

import 'package:e6b_flutter/pages/CalculatorPage.dart';

final calculators = [
  CalculatorPage(
    title: "Pressure and Density Altitude",
    fields: const [
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
        return "Pressure Altitude: -\nDensity Altitude: -";
      }
      if (temperature == 0) {
        return "Pressure Altitude: ${pressureAltitude.toStringAsFixed(0)} feet\nDensity Altitude: -";
      }
      return "Pressure Altitude: ${pressureAltitude.toStringAsFixed(0)} feet\nDensity Altitude: ${densityAltitude.toStringAsFixed(0)} feet";
    },
  ),
  CalculatorPage(
    title: "Crosswind Calculator",
    fields: const [
      CalculatorField(name: "windDir", label: "Wind Direction (°)"),
      CalculatorField(name: "windSpeed", label: "Wind Speed (kt)"),
      CalculatorField(name: "runway", label: "Runway Number"),
    ],
    calculate: (values) {
      final windDir = values["windDir"]!;
      final windSpeed = values["windSpeed"]!;
      final runway = values["runway"]!;

      if (windDir == 0 || windSpeed == 0 || runway == 0) {
        return "Please enter required values";
      }

      // Convert runway number (e.g. 27) into heading (e.g. 270°)
      final runwayHeading = runway * 10;

      // Calculate angle difference (wind - runway), normalized
      double angle = windDir - runwayHeading;
      while (angle > 180) {
        angle -= 360;
      }
      while (angle < -180) {
        angle += 360;
      }

      // Crosswind and headwind
      final crosswind = windSpeed * (sin(angle * pi / 180));
      final headwind = windSpeed * (cos(angle * pi / 180));

      final crossStr =
          "Crosswind: ${crosswind.abs().toStringAsFixed(1)} kt (${crosswind >= 0 ? "from right" : "from left"})";

      final headStr = headwind >= 0
          ? "Headwind: ${headwind.toStringAsFixed(1)} kt"
          : "Tailwind: ${headwind.abs().toStringAsFixed(1)} kt";

      return "$crossStr\n$headStr";
    },
  ),
  CalculatorPage(
    title: "Cloud Base and Freezing Level",
    fields: const [
      CalculatorField(
          name: "temperature", label: "Outside Air Temperature (°C)"),
      CalculatorField(
        name: "dewpoint",
        label: "Dewpoint (°C)",
      ),
      CalculatorField(
        name: "indicatedAlt",
        label: "Indicated Altitude (ft MSL)",
      ),
    ],
    calculate: (values) {
      final temperature = values["temperature"]!;
      final dewpoint = values["dewpoint"]!;
      final indicatedAlt = values["indicatedAlt"]!;

      if (temperature == 0 && dewpoint == 0 && indicatedAlt == 0) {
        return "Please enter required values";
      }

      // Cloud base (AGL)
      final spread = temperature - dewpoint;
      final cloudBase = (spread / 2.5) * 1000 + indicatedAlt;

      // Freezing level (MSL)
      double freezingLevel;
      if (temperature <= 0) {
        // Already below freezing at current altitude
        freezingLevel = indicatedAlt;
      } else {
        freezingLevel = indicatedAlt + (temperature / 2.44) * 1000;
      }

      return "Cloud Base: ${cloudBase.toStringAsFixed(0)} ft MSL\n"
          "Freezing Level: ${freezingLevel.toStringAsFixed(0)} ft MSL";
    },
  ),
  CalculatorPage(
    title: "Hydroplane Speed",
    fields: const [
      CalculatorField(name: "tirePressure", label: "Tire Pressure (PSI)"),
    ],
    calculate: (values) {
      final tirePressure = values["tirePressure"]!;

      if (tirePressure == 0) {
        return "Please enter a valid tire pressure";
      }

      // Hydroplane speed in knots
      final hydroplaneSpeed = 9 * sqrt(tirePressure);

      return "Speed: ${hydroplaneSpeed.toStringAsFixed(1)} knots (estimated)";
    },
  )
];
