//
//  GestureLayer.m
//  TIT
//
//  Created by swanky on 9/8/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GestureLayer.h"
#define kZTapTouchItemNode 100

@implementation GestureLayer
@synthesize batchNode;
@synthesize tapTouchItem;
@synthesize gesture;
@synthesize isTouched;


- (void)dealloc{
    self.batchNode = nil;
    self.tapTouchItem = nil;
    self.gesture = nil;
    [super dealloc];
}

- (id)init{
    self = [super init];
    if( self ) {
        self.isTouchEnabled = YES;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"common_atlas.plist"];
        self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"common_atlas.png"];
        
        self.tapTouchItem = [TapTouchItem spriteWithSpriteFrameName:@"touch0.png"];        
        [batchNode addChild:tapTouchItem z:kZTapTouchItemNode];
        
        [self addChild:batchNode];
        
        //gesture
        gesture = [[IBroGesture alloc] init];
        gesture.delegate = self;
    }
    
    return self;
}



#pragma mark - touch events


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    isTouched = YES;
    [tapTouchItem changeState:GameCharacterStateTapStart];
    [self ccTouchesMoved:touches withEvent:event];
    
    //guesture
    [gesture restoreDefault];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    isTouched = YES;
    //get touch pos
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    pos = [[CCDirector sharedDirector] convertToGL:pos];
    
    //set touch sprite position
    tapTouchItem.position = pos;
    
    //guesture
    [gesture addPoint:pos];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    isTouched = NO;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    isTouched = NO;
    
    //get touch pos
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    pos = [[CCDirector sharedDirector] convertToGL:pos];
    //change state
    [tapTouchItem changeState:GameCharacterStateTapEnd];
    //guesture
    [gesture decideGestureByLastPoint:pos];

}

#pragma mark - gesture delegate
- (void)gestureDetected:(IBroGestureArgs*)gestureArgs{
#define kDeltaLength 150
    
    CGPoint startPoint = gestureArgs.startPoint;
    CGPoint endPoint = gestureArgs.endPoint;
    
    CGFloat offX = endPoint.x - startPoint.x;
    CGFloat offY = endPoint.y - startPoint.y;
    CGFloat radio = fabsf(offY/offX);
    
    CGFloat deltaX = sqrtf(kDeltaLength*kDeltaLength/(radio*radio+1));
    CGFloat deltaY = sqrtf(kDeltaLength*kDeltaLength/(1/radio*radio+1));
    CGFloat realX, realY;
    if( offX > 0){
        realX = endPoint.x + deltaX;
    } else {
        realX = endPoint.x - deltaX;
    }
    
    if( offY> 0){
        realY = endPoint.y + deltaY;
    } else{
        realY = endPoint.y - deltaY;
    }
    NSLog(@"GestureLayer -> start point(%f,%f), line end point(%f, %f), delta(%f,%f)", endPoint.x, endPoint.y, realX,realY, deltaX, deltaY);

    [self.tapTouchItem runAction:[CCMoveTo actionWithDuration:kTapFadeOutDuration position:ccp(realX,realY)]];
}



@end
