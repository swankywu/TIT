//
//  IBroGesture.m
//  TIT
//
//  Created by swanky on 9/6/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "IBroGesture.h"
#define kMaxPointCount 256  //最多采样点数目
#define kMinDeltaTime 2  //触摸最短间隔时间
#define kMinPointsCount 4 //最少触摸的采样点数
#define kMinAngle 20 //判断角度

@implementation IBroGesture
@synthesize delegate;

- (void)dealloc{
    [guesturePoints removeAllObjects];
    [guesturePoints release];
    guesturePoints = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        guesturePoints = [[NSMutableArray alloc] init];
        lastTime = startTime = NSTimeIntervalSince1970;
        delegate = nil;
    }
    
    return self;
}

#pragma mark -
#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)

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

#pragma mark -

- (void)restoreDefault{
    [guesturePoints removeAllObjects];
}

- (void)addPoint:(CGPoint) point{
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if( now - lastTime > kMinDeltaTime) {
        [self restoreDefault];
    }
    if( [guesturePoints count] == 0){
        lastTime = startTime = [NSDate timeIntervalSinceReferenceDate];
        [guesturePoints addObject:NSStringFromCGPoint(point)]; 
    } else if([guesturePoints count] == kMaxPointCount ){
        [self restoreDefault];
        return;
    }
    [guesturePoints addObject:NSStringFromCGPoint(point)]; 
    lastTime = now;

}

- (void)addFinishedPoint:(CGPoint) finishedPoint{
    lastTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval deltaTime = lastTime - startTime; //using velocity
    NSLog(@"-----------------------");
    NSLog(@"points count: %d", [guesturePoints count]);

    if([guesturePoints count] > 2){ //detect condition
        
        CGPoint startPoint = CGPointFromString([guesturePoints objectAtIndex:0]);
        CGLine lastLine = CGMakeLine(startPoint, finishedPoint);
        
        BOOL isLine = NO;
//        int interval = [guesturePoints count]/kMinPointsCount;
//        if (interval == 0) {
//            interval = 1;
//        }
        int equalCount = 0;
        int notLineCount = 0;
        for (int i=1; i<[guesturePoints count]; i+=1) {
            CGPoint current = CGPointFromString([guesturePoints objectAtIndex:i]);
            if( startPoint.x == current.x && startPoint.y == current.y ){
                ++ equalCount;
                continue;
            }
            CGLine line = CGMakeLine(startPoint, current);
            CGFloat angle = angleBetweenLines(lastLine, line);
            NSLog(@"angle%d:%f", i, angle);
            if( angle  > kMinAngle ){ //line gesture
                ++notLineCount;
            }
        }
        if( notLineCount > [guesturePoints count]/2 ){
            isLine = NO;
        } else {
            isLine = YES;
        }
        if( [guesturePoints count] > kMinPointsCount && equalCount >= [guesturePoints count]/2 ){
            isLine = YES;
        }
        
        if( isLine ){

            if( [self.delegate conformsToProtocol:@protocol(IBroGestureDelegate)] 
               && [self.delegate respondsToSelector:@selector(lineGestureDetected:)] ){
                [self.delegate 
                    performSelector:@selector(lineGestureDetected:)
                         withObject:[NSNumber numberWithDouble:deltaTime]];
            }
        }

        
    }
    
    [self restoreDefault];
}


@end
