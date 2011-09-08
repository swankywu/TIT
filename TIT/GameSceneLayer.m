//
//  GameSceneLayer.m
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GameSceneLayer.h"
#define kZTapTouchItemNode 100

@implementation GameSceneLayer
@synthesize batchNode;
@synthesize tapTouchItem;
@synthesize isTouched;
@synthesize gesture;

- (void)dealloc{
    self.tapTouchItem = nil;
    self.gesture = nil;
    [super dealloc];
}

- (id)init{
    self = [super initWithColor:ccc4(0xff, 0xff, 0xff, 0xff)];
    if( self ) {
        self.isTouchEnabled = YES;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"common_atlas.plist"];
        self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"common_atlas.png"];
        
        self.tapTouchItem = [TapTouchItem spriteWithSpriteFrameName:@"touch0.png"];        
        [batchNode addChild:tapTouchItem z:kZTapTouchItemNode];
        
        [self addChild:batchNode];
        
        //others
        IBroGesture *g = [[IBroGesture alloc] init];
        self.gesture = g;
        [g release];
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
    [tapTouchItem changeState:GameCharacterStateTapEnd];
    isTouched = NO;
    
    //get touch pos
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    pos = [[CCDirector sharedDirector] convertToGL:pos];
    
    //guesture
    [gesture addFinishedPoint:pos];
}

@end
