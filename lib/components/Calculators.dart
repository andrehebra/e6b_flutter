import 'dart:math';
import 'dart:math' as Math;

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
  ),
  CalculatorPage(
    title: "Planned True Airspeed",
    fields: const [
      CalculatorField(name: "pressureAlt", label: "Pressure Altitude (ft)"),
      CalculatorField(name: "temperature", label: "True Temperature (°C)"),
      CalculatorField(name: "cas", label: "Calibrated Airspeed (KCAS)"),
    ],
    calculate: (values) {
      final pressureAlt = values["pressureAlt"];
      final temperature = values["temperature"];
      final cas = values["cas"];

      // Require all values before calculating
      if (pressureAlt == null || temperature == null || cas == null) {
        return const [
          CalculatorResult(title: "True Airspeed", value: null, unit: "KTAS"),
          CalculatorResult(title: "Mach Number", value: null, unit: "M"),
          CalculatorResult(title: "Density Altitude", value: null, unit: "ft"),
        ];
      }

      // ---- Constants ----
      const double gamma = 1.4; // ratio of specific heats for air
      const double R = 287.05; // J/(kg·K) specific gas constant for dry air
      const double T0 = 288.15; // K, standard temperature at sea level
      const double p0 = 101325; // Pa, standard pressure at sea level

      // ---- Atmosphere calculations ----
      final tempK = temperature + 273.15; // convert to Kelvin
      final isaTemp = T0 - (pressureAlt / 1000) * 1.98; // rough ISA lapse (K)
      final isaDiff = tempK - isaTemp; // deviation from ISA (K)

      // Pressure at altitude (simplified ICAO model)
      final pressure = p0 * Math.pow(1 - (0.0065 * pressureAlt) / T0, 5.2561);

      // Air density
      final rho = pressure / (R * tempK);

      // Sea-level density
      final rho0 = p0 / (R * T0);

      // Density altitude approximation
      final densityAlt =
          pressureAlt + (120 * (temperature - (15 - 2 * (pressureAlt / 1000))));

      // ---- Airspeed conversions ----
      // Convert CAS (knots) to TAS (knots)
      final tas = cas * Math.sqrt(rho0 / rho);

      // Speed of sound at temp
      final a = Math.sqrt(gamma * R * tempK); // m/s
      final aKt = a * 1.94384; // convert to knots

      // Mach number
      final mach = tas / aKt;

      return [
        CalculatorResult(title: "True Airspeed", value: tas, unit: "KTAS"),
        CalculatorResult(title: "Mach Number", value: mach, unit: "M"),
        CalculatorResult(
            title: "Density Altitude", value: densityAlt, unit: "ft"),
      ];
    },
  ),
  CalculatorPage(
    title: "Heading and Groundspeed",
    fields: const [
      CalculatorField(
        name: "windDir",
        label: "Wind Direction (° True)",
      ),
      CalculatorField(
        name: "windSpeed",
        label: "Wind Speed (kts)",
      ),
      CalculatorField(
        name: "trueCourse",
        label: "True Course (° True)",
      ),
      CalculatorField(
        name: "trueAirspeed",
        label: "True Airspeed (kts)",
      ),
    ],
    calculate: (values) {
      final windDir = values["windDir"];
      final windSpeed = values["windSpeed"];
      final trueCourse = values["trueCourse"];
      final trueAirspeed = values["trueAirspeed"];

      if (windDir == null ||
          windSpeed == null ||
          trueCourse == null ||
          trueAirspeed == null) {
        return const [
          CalculatorResult(title: "Groundspeed", value: null, unit: "kts"),
          CalculatorResult(title: "True Heading", value: null, unit: "°"),
          CalculatorResult(
              title: "Wind Correction Angle", value: null, unit: "°"),
        ];
      }

      // Convert degrees to radians for trig
      final windDirRad = windDir * (3.141592653589793 / 180);
      final courseRad = trueCourse * (3.141592653589793 / 180);

      // Angle between wind direction and course
      final windAngle = windDirRad - courseRad;

      // Crosswind and headwind components
      final crosswind = windSpeed * (Math.sin(windAngle));
      final headwind = windSpeed * (Math.cos(windAngle));

      // Wind Correction Angle (radians → degrees)
      final wcaRad = Math.asin(crosswind / trueAirspeed);
      final wca = wcaRad * (180 / 3.141592653589793);

      // True Heading = Course + WCA
      final trueHeading = trueCourse + wca;

      // Groundspeed
      final groundspeed = trueAirspeed * Math.cos(wcaRad) - headwind;

      return [
        CalculatorResult(title: "Groundspeed", value: groundspeed, unit: "kts"),
        CalculatorResult(title: "True Heading", value: trueHeading, unit: "°"),
        CalculatorResult(title: "Wind Correction Angle", value: wca, unit: "°"),
      ];
    },
  ),
  CalculatorPage(
    title: "Compass Heading",
    fields: const [
      CalculatorField(name: "trueCourse", label: "True Course (°)"),
      CalculatorField(
          name: "windCorrection", label: "Wind Correction Angle (°)"),
      CalculatorField(name: "variation", label: "Magnetic Variation (°)"),
      CalculatorField(name: "deviation", label: "Compass Deviation (°)"),
    ],
    calculate: (values) {
      final trueCourse = values["trueCourse"];
      final windCorrection = values["windCorrection"];
      final variation = values["variation"];
      final deviation = values["deviation"];

      if (trueCourse == null || windCorrection == null || variation == null) {
        return [
          const CalculatorResult(title: "True Heading", value: null, unit: "°"),
          const CalculatorResult(
              title: "Magnetic Heading", value: null, unit: "°"),
          const CalculatorResult(
              title: "Compass Heading", value: null, unit: "°"),
        ];
      }

      // Navigation formulas:
      final trueHeading = (trueCourse + windCorrection) % 360;
      final magneticHeading = (trueHeading + variation) % 360;
      if (deviation == null) {
        return [
          CalculatorResult(
              title: "True Heading", value: trueHeading, unit: "°"),
          CalculatorResult(
              title: "Magnetic Heading", value: magneticHeading, unit: "°"),
          const CalculatorResult(
              title: "Compass Heading", value: null, unit: "°"),
        ];
      }
      final compassHeading = (magneticHeading + deviation) % 360;

      return [
        CalculatorResult(title: "True Heading", value: trueHeading, unit: "°"),
        CalculatorResult(
            title: "Magnetic Heading", value: magneticHeading, unit: "°"),
        CalculatorResult(
            title: "Compass Heading", value: compassHeading, unit: "°"),
      ];
    },
  )
];
