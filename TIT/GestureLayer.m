//
//  GestureLayer.m
//  TIT
//
//  Created by swanky on 9/8/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GestureLayer.h"
#define kZTapTouchItemNode 100
#define kDeltaLength 150


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
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"texture_atlas.plist"];
        self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"texture_atlas.png"];
        
        self.tapTouchItem = [TapTouchItem spriteWithSpriteFrameName:@"touch0.png"]; 
        [tapTouchItem setPosition:ccp(-[tapTouchItem boundingBox].size.width, -[tapTouchItem boundingBox].size.height)];
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
    
    //guesture
    [gesture decideGestureByLastPoint:pos];

}

#pragma mark - gesture delegate
- (void)gestureDetected:(IBroGestureArgs*)gestureArgs{

    if( gestureArgs.gestureType == IBroGestureTypeTap ){
        [tapTouchItem changeState:GameCharacterStateTapEnd];
    } else if( gestureArgs.gestureType == IBroGestureTypeLine ){
        [tapTouchItem changeState:GameCharacterStateTapFinishing];    
        CGPoint startPoint = gestureArgs.startPoint;
        CGPoint endPoint = gestureArgs.endPoint;
        
        CGFloat offX = endPoint.x - startPoint.x;
        CGFloat offY = endPoint.y - startPoint.y;
        CGFloat radioX = offX!=0.0f ? fabsf((float)offY/offX) : 0.0f;
        CGFloat radioY = offY!=0.0f ? fabsf((float)offX/offY) : 0.0f;
        
        CGFloat deltaX = sqrtf(kDeltaLength*kDeltaLength/(radioX*radioX+1));
        CGFloat deltaY = sqrtf(kDeltaLength*kDeltaLength/(radioY*radioY+1));
        CGFloat realX, realY;
        if( offX > 0){
            realX = endPoint.x + deltaX;
        } else if( offX < 0) {
            realX = endPoint.x - deltaX;
        } else {
            realX = endPoint.x;
        }
        
        if( offY> 0){
            realY = endPoint.y + deltaY;
        } else if (offX < 0){
            realY = endPoint.y - deltaY;
        } else {
            realY = endPoint.y;
        }
        NSLog(@"GestureLayer -> line gesture detected.");
//        NSLog(@"GestureLayer -> start point(%f,%f), end point(%f, %f), target point (%f,%f), detal(%f,%f), offset(%f,%f), radio(%f,%f)", 
//              startPoint.x, startPoint.y, endPoint.x, endPoint.y, realX, realY, deltaX, deltaY, offX, offY, radioX, radioY);
        
        [self.tapTouchItem runAction:[CCMoveTo actionWithDuration:kGestureLineAnimationDuration
                                                         position:ccp(realX,realY)]];
    }
    
}



@end
