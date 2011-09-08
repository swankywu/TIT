//
//  IBroGesture.h
//  TIT
//
//  Created by swanky on 9/6/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBroGestureDelegate <NSObject>

- (void)lineGestureDetected:(NSNumber*)delta;

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
- (void)addFinishedPoint:(CGPoint) point;
@end
