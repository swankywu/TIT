//
//  Math.m
//  TIT
//
//  Created by swanky on 9/7/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "IBroMath.h"

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
	CGFloat deltaX = second.x - first.x;
	CGFloat deltaY = second.y - first.y;
	return sqrt((deltaX*deltaX) + (deltaY*deltaY));
};

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat height = second.y - first.y;
	CGFloat width = first.x - second.x;
	CGFloat rads = atan(height/width);
	return radiansToDegrees(rads);
};


CGFloat angleBetweenLines(CGLine line1, CGLine line2) {
	
	CGFloat a = line1.point2.x - line1.point1.x;
	CGFloat b = line1.point2.y - line1.point1.y;
	CGFloat c = line2.point2.x - line2.point1.x;
	CGFloat d = line2.point2.y - line2.point1.y;
	
	CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
	
	return radiansToDegrees(rads);	
};

CGFloat distanceBetweenLines(CGLine line1, CGLine line2)
{
	CGFloat centerLine1 = (distanceBetweenPoints(line1.point1, line1.point2) / 2);
	CGFloat centerLine2 = (distanceBetweenPoints(line2.point1, line2.point2) / 2);
	
	CGFloat distance = abs(centerLine1 - centerLine2);
	
	return distance;
};

CGLine CGMakeLine(CGPoint point1, CGPoint point2)
{
	CGLine nLine;
	
	nLine.point1 = point1;
	nLine.point2 = point2;
	
	return nLine;
};
