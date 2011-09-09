//
//  IBroGesture.h
//  TIT
//
//  Created by swanky on 9/6/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    IBroGestureTypeUnkown = 0,
    IBroGestureTypeTap,
    IBroGestureTypeLine,
    
} IBroGestureType;



@interface IBroGestureArgs : NSObject{
    CGPoint startPoint;
    CGPoint endPoint;
    IBroGestureType gestureType;
    NSTimeInterval deltaTime;
}

@property CGPoint startPoint;
@property CGPoint endPoint;
@property IBroGestureType gestureType;
@property NSTimeInterval deltaTime;

+ (IBroGestureArgs*)gestureArgsWithStartPoint:(CGPoint)p0
                                 withEndPoint:(CGPoint)p1
                                      andType:(IBroGestureType)type
                                 andDeltaTime:(NSTimeInterval)detal;

@end

@protocol IBroGestureDelegate <NSObject>

- (void)gestureDetected:(IBroGestureArgs*)gestureArgs;

@end

@interface IBroGesture : NSObject{
@private
    NSMutableArray *guesturePoints;
    NSTimeInterval startTime; //in second
    NSTimeInterval lastTime;  //in second
    id<IBroGestureDelegate> delegate;
}

@property (nonatomic, retain) id<IBroGestureDelegate> delegate;

- (void)restoreDefault;
- (void)addPoint:(CGPoint) point;
- (void)decideGestureByLastPoint:(CGPoint) point;
@end



