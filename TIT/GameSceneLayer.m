//
//  GameSceneLayer.m
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GameSceneLayer.h"


@implementation GameSceneLayer
@synthesize touchSprite = _touchSprite;
@synthesize batchNode   = _batchNode;
@synthesize isTouched = _isTouched;


- (id)init{
    self = [super initWithColor:ccc4(0xcc, 0xcc, 0xcc, 0xff)];
    if( self ) {
        self.isTouchEnabled = YES;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"common_atlas.plist"];
        self.batchNode= [CCSpriteBatchNode batchNodeWithFile:@"common_atlas.png"];
        self.touchSprite = [CCSprite spriteWithSpriteFrameName:@"touch0.png"];
        
        [_batchNode addChild:_touchSprite];
        
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        _touchSprite.position = ccp(winSize.width/2, winSize.height/2);


    }
    
    return self;
}

- (void)dealloc{
    self.batchNode = nil;
    self.touchSprite = nil;
    [super dealloc];
}

#pragma mark - touch events


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouched = YES;
    [self addChild:_batchNode];
    [self ccTouchesMoved:touches withEvent:event];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //get touch pos
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    pos = [[CCDirector sharedDirector] convertToGL:pos];
    
    //set touch sprite position
    _touchSprite.position = pos;
    
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouched = NO;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeChild:_batchNode cleanup:NO];
    _isTouched = NO;
}
@end
