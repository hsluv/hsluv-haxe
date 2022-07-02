package hsluv;

import hsluv.Hsluv;
import hsluv0.Geometry;
import hsluv0.ColorPicker;

// typedef Point = {
//     var x:Float;
//     var y:Float;
// }
// typedef Line = {
//     var slope:Float;
//     var intercept:Float;
// }
// // All angles in radians
// typedef Angle = Float;
// typedef PickerGeometry = {
//     var lines:Array<Line>;
//     // Ordered such that 1st vertex is interection between first and
//     // second line, 2nd vertex between second and third line etc.
//     var vertices:Array<Point>;
//     // Angles from origin to corresponding vertex
//     var angles:Array<Angle>;
//     // Smallest circle with center at origin such that polygon fits inside
//     var outerCircleRadius:Float;
//     // Largest circle with center at origin such that it fits inside polygon
//     var innerCircleRadius:Float;
// }
class ColorPicker2 {
	public var hsluv:Hsluv;

	public static function intersectLineLine(a:Line, b:Line):Point {
		var x = (a.intercept - b.intercept) / (b.slope - a.slope);
		var y = a.slope * x + a.intercept;
		return {x: x, y: y};
	}

	public static function distanceFromOrigin(point:Point):Float {
		return Math.sqrt(Math.pow(point.x, 2) + Math.pow(point.y, 2));
	}

	public static function distanceLineFromOrigin(line:Line):Float {
		// https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
		return Math.abs(line.intercept) / Math.sqrt(Math.pow(line.slope, 2) + 1);
	}

	public static function perpendicularThroughPoint(line:Line, point:Point):Line {
		var slope = -1 / line.slope;
		var intercept = point.y - slope * point.x;
		return {
			slope: slope,
			intercept: intercept
		}
	}

	public static function angleFromOrigin(point:Point):Angle {
		return Math.atan2(point.y, point.x);
	}

	public static function normalizeAngle(angle:Angle):Angle {
		var m = 2 * Math.PI;
		return ((angle % m) + m) % m;
	}

	public static function lengthOfRayUntilIntersect(theta:Angle, line:Line):Float {
		/*
			theta  -- angle of ray starting at (0, 0)
			m, b   -- slope and intercept of line
			x1, y1 -- coordinates of intersection
			len    -- length of ray until it intersects with line

			b + m * x1        = y1
			len              >= 0
			len * cos(theta)  = x1
			len * sin(theta)  = y1


			b + m * (len * cos(theta)) = len * sin(theta)
			b = len * sin(hrad) - m * len * cos(theta)
			b = len * (sin(hrad) - m * cos(hrad))
			len = b / (sin(hrad) - m * cos(hrad))
		 */

		return line.intercept / (Math.sin(theta) - line.slope * Math.cos(theta));
	}

	public static function getPickerGeometry(lightness:Float):PickerGeometry {
		// Array of lines
		var conv = new Hsluv();
		conv.calculateBoundingLines(lightness);
		var lines:Array<Line> = [
			{
				slope: conv.r0s,
				intercept: conv.r0i
			},
			{
				slope: conv.r1s,
				intercept: conv.r1i
			},
			{
				slope: conv.g0s,
				intercept: conv.g0i
			},
			{
				slope: conv.g1s,
				intercept: conv.g1i
			},
			{
				slope: conv.b0s,
				intercept: conv.b0i
			},
			{
				slope: conv.b1s,
				intercept: conv.b1i
			}
		];

		var numLines = lines.length;
		var outerCircleRadius = 0.0;

		// Find the line closest to origin
		var closestIndex = null;
		var closestLineDistance = null;

		for (i in 0...numLines) {
			var d = distanceLineFromOrigin(lines[i]);
			if (closestLineDistance == null || d < closestLineDistance) {
				closestLineDistance = d;
				closestIndex = i;
			}
		}

        var closestLine = lines[closestIndex];
		var perpendicularLine = {slope: 0 - (1 / closestLine.slope), intercept: 0.0};
		var intersectionPoint = intersectLineLine(closestLine, perpendicularLine);
		var startingAngle = angleFromOrigin(intersectionPoint);

		var intersections = [];
		var intersectionPoint;
		var intersectionPointAngle;
		var relativeAngle;

		for (i1 in 0...numLines - 1) {
			for (i2 in i1 + 1...numLines) {
				intersectionPoint = intersectLineLine(lines[i1], lines[i2]);
				intersectionPointAngle = angleFromOrigin(intersectionPoint);
				relativeAngle = intersectionPointAngle - startingAngle;
				intersections.push({
					line1: i1,
					line2: i2,
					intersectionPoint: intersectionPoint,
					intersectionPointAngle: intersectionPointAngle,
					relativeAngle: normalizeAngle(intersectionPointAngle - startingAngle)
				});
			}
		}

		intersections.sort(function(a, b) {
			if (a.relativeAngle > b.relativeAngle) {
				return 1;
			} else {
				return -1;
			}
		});

		var orderedLines = [];
		var orderedVertices = [];
		var orderedAngles = [];

		var nextIndex;
		var currentIntersection;
		var intersectionPointDistance;

		var currentIndex = closestIndex;
		var d = [];

		for (j in 0...intersections.length) {
			currentIntersection = intersections[j];
			nextIndex = null;
			if (currentIntersection.line1 == currentIndex) {
				nextIndex = currentIntersection.line2;
			} else if (currentIntersection.line2 == currentIndex) {
				nextIndex = currentIntersection.line1;
			}
			if (nextIndex != null) {
				currentIndex = nextIndex;

				d.push(currentIndex);
				orderedLines.push(lines[nextIndex]);
				orderedVertices.push(currentIntersection.intersectionPoint);
				orderedAngles.push(currentIntersection.intersectionPointAngle);

				intersectionPointDistance = distanceFromOrigin(currentIntersection.intersectionPoint);
				if (intersectionPointDistance > outerCircleRadius) {
					outerCircleRadius = intersectionPointDistance;
				}
			}
		}

		return {
			lines: orderedLines,
			vertices: orderedVertices,
			angles: orderedAngles,
			outerCircleRadius: outerCircleRadius,
			innerCircleRadius: closestLineDistance
		}
	}

	public static function closestPoint(geometry:PickerGeometry, point:Point):Point {
		// In order to find the closest line we use the point's angle
		var angle = angleFromOrigin(point);
		var numVertices = geometry.vertices.length;
		var relativeAngle;
		var smallestRelativeAngle = Math.PI * 2;
		var index1 = 0;

		for (i in 0...numVertices) {
			relativeAngle = normalizeAngle(geometry.angles[i] - angle);
			if (relativeAngle < smallestRelativeAngle) {
				smallestRelativeAngle = relativeAngle;
				index1 = i;
			}
		}

		var index2 = (index1 - 1 + numVertices) % numVertices;
		var closestLine = geometry.lines[index2];

		// Provided point is within the polygon
		if (distanceFromOrigin(point) < lengthOfRayUntilIntersect(angle, closestLine)) {
			return point;
		}

		var perpendicularLine = perpendicularThroughPoint(closestLine, point);
		var intersectionPoint = intersectLineLine(closestLine, perpendicularLine);

		var bound1 = geometry.vertices[index1];
		var bound2 = geometry.vertices[index2];
		var upperBound:Point;
		var lowerBound:Point;

		if (bound1.x > bound2.x) {
			upperBound = bound1;
			lowerBound = bound2;
		} else {
			upperBound = bound2;
			lowerBound = bound1;
		}

		var borderPoint;
		if (intersectionPoint.x > upperBound.x) {
			borderPoint = upperBound;
		} else if (intersectionPoint.x < lowerBound.x) {
			borderPoint = lowerBound;
		} else {
			borderPoint = intersectionPoint;
		}

		return borderPoint;
	}
}
