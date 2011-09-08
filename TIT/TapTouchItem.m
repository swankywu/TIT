//
//  TapTouchItem.m
//  TIT
//
//  Created by swanky on 9/2/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "TapTouchItem.h"

@implementation TapTouchItem
- (void)dealloc{
    [super dealloc];
}

- (void)initAnimations{
    
    [self loadPlistForAnimationWithName:@"tapStartAnim"
                           andClassName:NSStringFromClass([self class])
                 withGameCharacterState:GameCharacterStateTapStart];
    [self loadPlistForAnimationWithName:@"tapKeepingAnim"
                           andClassName:NSStringFromClass([self class])
                 withGameCharacterState:GameCharacterStateTapKeeping];
    [self loadPlistForAnimationWithName:@"tapMovingAnim"
                           andClassName:NSStringFromClass([self class])
                 withGameCharacterState:GameCharacterStateTapMoving];
    [self loadPlistForAnimationWithName:@"tapFinishingAnim"
                           andClassName:NSStringFromClass([self class])
                 withGameCharacterState:GameCharacterStateTapFinishing];
    [self loadPlistForAnimationWithName:@"tapEndAnim"
                           andClassName:NSStringFromClass([self class])
                 withGameCharacterState:GameCharacterStateTapEnd];
}

- (id) init{
    self = [super init];
    if( self ){
        self.type = GameObjectTypeSinger;
        [self initAnimations];
        [self setPosition:ccp(-128, -128)];
        [self changeState:GameCharacterStateTapEnd];
    }
    return self;
}

#pragma mark - 
- (void)changeState:(GameCharacterState)newState{
    [self stopAllActions];
    [self setState:newState];
    id anim = [self.animDic objectForKey:[NSString stringWithFormat:@"%d", newState]];
    id action = [CCAnimate actionWithAnimation:anim restoreOriginalFrame:NO];
    if( newState == GameCharacterStateTapEnd || newState == GameCharacterStateTapFinishing ){
        action = [CCSpawn actions:action,[CCFadeOut actionWithDuration:kTapFadeOutDuration],[CCScaleTo actionWithDuration:kTapFadeOutDuration scale:0], nil];
    } else if( newState == GameCharacterStateTapStart ){
        action = [CCSpawn actions:action,[CCFadeIn actionWithDuration:0.1f], [CCScaleTo actionWithDuration:0.1f scale:1], nil];
    }
 
    [self runAction:action];
}

- (void)updateStateWidthDeltaTime:(float)deltaTime
             andListOfGameObjects:(CCArray *)listOfGameObjects{
    
}
@end
