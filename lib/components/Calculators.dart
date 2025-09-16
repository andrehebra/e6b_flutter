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
      final indicated = values["indicatedAlt"];
      final altimeter = values["altimeter"];
      final temperature = values["temperature"];

      if (indicated == null || altimeter == null) {
        return const [
          CalculatorResult(
              title: "Pressure Altitude", value: null, unit: "feet"),
          CalculatorResult(
              title: "Density Altitude", value: null, unit: "feet"),
        ];
      }

      final pressureAltitude = ((29.92 - altimeter) * 1000) + indicated;
      final standardTemperature = 15 - ((pressureAltitude / 1000) * 2);

      if (temperature == null) {
        return [
          CalculatorResult(
              title: "Pressure Altitude",
              value: pressureAltitude,
              unit: "feet"),
          const CalculatorResult(
              title: "Density Altitude", value: null, unit: "feet"),
        ];
      }
      final densityAltitude =
          pressureAltitude + (120 * (temperature - standardTemperature));

      return [
        CalculatorResult(
            title: "Pressure Altitude", value: pressureAltitude, unit: "feet"),
        CalculatorResult(
            title: "Density Altitude", value: densityAltitude, unit: "feet"),
      ];

      //return "Pressure Altitude: ${pressureAltitude.toStringAsFixed(0)} feet\nDensity Altitude: ${densityAltitude.toStringAsFixed(0)} feet";
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
      final windDir = values["windDir"];
      final windSpeed = values["windSpeed"];
      final runway = values["runway"];

      if (windDir == null || windSpeed == null || runway == null) {
        return const [
          CalculatorResult(title: "Headwind", value: null, unit: "kts"),
          CalculatorResult(title: "Crosswind", value: null, unit: "kts"),
        ];
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

      if (headwind < 0) {
        return [
          CalculatorResult(title: "Tailwind", value: headwind, unit: "kts"),
          CalculatorResult(title: "Crosswind", value: crosswind, unit: "kts"),
        ];
      } else {
        return [
          CalculatorResult(title: "Headwind", value: headwind, unit: "kts"),
          CalculatorResult(title: "Crosswind", value: crosswind, unit: "kts"),
        ];
      }
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
      final temperature = values["temperature"];
      final dewpoint = values["dewpoint"];
      final indicatedAlt = values["indicatedAlt"];

      // If any required input is missing, don't show results
      if (temperature == null || dewpoint == null || indicatedAlt == null) {
        return const [
          CalculatorResult(title: "Cloud Base", value: null, unit: "ft MSL"),
          CalculatorResult(
              title: "Freezing Level", value: null, unit: "ft MSL"),
        ];
        ;
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

      return [
        CalculatorResult(title: "Cloud Base", value: cloudBase, unit: "ft MSL"),
        CalculatorResult(
            title: "Freezing Level", value: freezingLevel, unit: "ft MSL"),
      ];
    },
  ),
  CalculatorPage(
    title: "Hydroplane Speed",
    fields: const [
      CalculatorField(name: "tirePressure", label: "Tire Pressure (PSI)"),
    ],
    calculate: (values) {
      final tirePressure = values["tirePressure"];

      if (tirePressure == null) {
        return [
          const CalculatorResult(
              title: "Hydroplane Speed", value: null, unit: "PSI"),
        ];
      }

      // Hydroplane speed in knots
      final hydroplaneSpeed = 9 * sqrt(tirePressure);

      return [
        CalculatorResult(
            title: "Hydroplane Speed", value: hydroplaneSpeed, unit: "PSI"),
      ];
    },
  )
];
