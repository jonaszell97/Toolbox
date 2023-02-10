# ``Toolbox``

Toolbox is a collection of useful extensions, functions, and types for building Swift apps.

## Overview

In addition to its own functions and types, Toolbox provides useful extensions to builtin Swift types. These extensions can be found in the files `Array.swift`, `Calendar.swift`, `Coding.swift`, `Dictionary.swift`, `Graphics.swift`, `Set.swift`, and `String.swift`.

## Topics

### Formatting

- ``FormatToolbox``
- ``FormatToolbox/format(_:)``
- ``FormatToolbox/format(_:alwaysShowSign:)``
- ``FormatToolbox/format(_:decimalPlaces:minDecimalPlaces:alwaysShowSign:)-7xqxl``
- ``FormatToolbox/format(_:decimalPlaces:minDecimalPlaces:alwaysShowSign:)-60ikv``
- ``FormatToolbox/format(_:decimalPlaces:minDecimalPlaces:alwaysShowSign:)-4khnz``
- ``FormatToolbox/format(_:decimalPlaces:minDecimalPlaces:)``
- ``FormatToolbox/formatOrdinal(_:)``
- ``FormatToolbox/formatYear(_:)``
- ``FormatToolbox/formatDate(_:timeZone:locale:dateStyle:)``
- ``FormatToolbox/formatTime(_:timeZone:locale:timeStyle:)``
- ``FormatToolbox/formatDateTime(_:timeZone:locale:dateStyle:timeStyle:)``
- ``FormatToolbox/formatTimeLimit(_:includeMilliseconds:)``
- ``FormatToolbox/formatPercentage(_:decimalPlaces:minDecimalPlaces:)``
- ``FormatToolbox/formatByteSize(_:)``

### Geometry

- ``GeometryToolbox``
- ``GeometryToolbox/pointOnCircle(radius:angleRadians:)``
- ``GeometryToolbox/getIntersectionPoint(_:_:_:_:)``
- ``GeometryToolbox/CircleLineIntersectionResult``
- ``GeometryToolbox/circleLineIntersections(_:_:radius:center:)``

### Hashing

- ``HashingToolbox``
- ``HashingToolbox/combineHashes(_:_:)``
- ``StableHashable``

### Logging

- ``Log``
- ``Log/reportCriticalError``
- ``LogContainer``
- ``Logger``
- ``Logger/critical(_:)``
- ``NSLocalizedString(_:)``

### Maths

- ``MathsToolbox``
- ``MathsToolbox/clamp(_:lower:upper:)``
- ``MathsToolbox/factorial(_:)``
- ``MathsToolbox/requiredDigits(_:)``
- ``MathsToolbox/requiredDigits(_:base:)``
- ``MathsToolbox/requiredDigits(_:thousandsSeparators:)``
- ``MathsToolbox/decimalDigits(of:)``
- ``**(_:_:)-92984``
- ``**(_:_:)-9irmr``

### Random

- ``ARC4RandomNumberGenerator``

### Statistics

- ``StatsToolbox``
- ``StatsToolbox/linearRegression(_:_:)``
- ``StatsToolbox/normalDistribution(_:mean:std:)``
- ``StatsToolbox/normalDistributionCdf(_:mean:std:)``

### Types

- ``Either``
- ``Pair``
- ``VersionTriple``
