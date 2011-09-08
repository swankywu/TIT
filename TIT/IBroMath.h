//
//  Math.h
//  TIT
//
//  Created by swanky on 9/7/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radiansToDegrees(x) (180.0 * (x) / M_PI)


typedef struct 
{
	CGPoint point1;
	CGPoint point2;
} CGLine;



CGFloat distanceBetweenPoints (CGPoint first, CGPoint second);
CGFloat angleBetweenPoints(CGPoint first, CGPoint second);
CGFloat angleBetweenLines(CGLine line1, CGLine line2);
CGFloat distanceBetweenLines(CGLine line1, CGLine line2);

CGLine CGMakeLine(CGPoint point1, CGPoint point2);