//
//  IBroGesture.m
//  TIT
//
//  Created by swanky on 9/6/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "IBroGesture.h"
#import "IBroMath.h"
#define kMaxPointCount 16  //最多采样点数目
#define kMinDeltaTime 0.2  //触摸最短间隔时间
#define kMinPointsCount 4 //最少触摸的采样点数
#define kMinAngle 20 //判断最小角度
#define kMinPointsLength 50 //最短距离

@implementation IBroGestureArgs
@synthesize startPoint,endPoint,gestureType,deltaTime;

+ (IBroGestureArgs*)gestureArgsWithStartPoint:(CGPoint)p0
                                 withEndPoint:(CGPoint)p1
                                      andType:(IBroGestureType)type
                                 andDeltaTime:(NSTimeInterval)detal{
    IBroGestureArgs* args = [[[IBroGestureArgs alloc] init] autorelease];
    
    args.startPoint = p0;
    args.endPoint = p1;
    args.gestureType = type;
    args.deltaTime = detal;
    return args;
}
@end

@implementation IBroGesture
@synthesize delegate;

- (void)dealloc{
    [guesturePoints removeAllObjects];
    [guesturePoints release];
    guesturePoints = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        guesturePoints = [[NSMutableArray alloc] init];
        lastTime = startTime = NSTimeIntervalSince1970;
        delegate = nil;
    }
    
    return self;
}

#pragma mark -

- (void)restoreDefault{
    lastTime = [NSDate timeIntervalSinceReferenceDate];
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

- (void)decideGestureByLastPoint:(CGPoint) finishedPoint{
    
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval deltaTime = now - startTime; //using velocity
    
    IBroGestureArgs *args = [IBroGestureArgs gestureArgsWithStartPoint:finishedPoint 
                                                          withEndPoint:finishedPoint
                                                               andType:IBroGestureTypeTap 
                                                          andDeltaTime:deltaTime];
    
    if( [guesturePoints count] >1 && deltaTime <= kMinDeltaTime) {

    
        CGPoint startPoint = CGPointFromString([guesturePoints objectAtIndex:0]);
        CGFloat lineLength = distanceBetweenPoints(startPoint, finishedPoint);
        
//        NSLog(@"IBroGesture->-----------------------");
//        NSLog(@"IBroGesture->up delta time:%f", now - lastTime);
//        NSLog(@"IBroGesture->points count: %d", [guesturePoints count]);
//        NSLog(@"IBroGesture->distance between start point and end point:%f", lineLength);
        
        if(lineLength > kMinPointsLength) {
            CGLine lastLine = CGMakeLine(startPoint, finishedPoint);
            BOOL isLine = NO;
            int notLineCount = 0;
            
            for (int i=1; i<[guesturePoints count]; i+=1) {
                CGPoint current = CGPointFromString([guesturePoints objectAtIndex:i]);
                if( startPoint.x == current.x && startPoint.y == current.y ){
                    continue;
                }
                CGLine line = CGMakeLine(startPoint, current);
                CGFloat angle = angleBetweenLines(lastLine, line);
                //NSLog(@"IBroGesture->angle%d:%f", i, angle);
                if( angle  > kMinAngle ){ //line gesture
                    ++notLineCount;
                }
            }
            if( notLineCount > [guesturePoints count]/2 ){
                isLine = NO;
            } else {
                isLine = YES;
            }
            
            if( isLine ){
                
                [args setStartPoint:startPoint];
                [args setEndPoint:finishedPoint];
                [args setGestureType:IBroGestureTypeLine];
               
            }
            
        }
    }
    [self restoreDefault];
    
    if( [self.delegate conformsToProtocol:@protocol(IBroGestureDelegate)] 
       && [self.delegate respondsToSelector:@selector(gestureDetected:)] ){
        [self.delegate performSelector:@selector(gestureDetected:)
                            withObject:args];
    }
}


@end
