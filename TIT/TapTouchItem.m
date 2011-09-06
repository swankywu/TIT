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
    [self loadPlistForAnimationWithName:@"tapEndAnim"
                           andClassName:NSStringFromClass([self class])
                 withGameCharacterState:GameCharacterStateTapEnd];
}

- (id) init{
    self = [super init];
    if( self ){
        //self.contentSize = CGSizeMake(128.0f, 128.0f);
        self.type = GameObjectTypeSinger;
        [self initAnimations];
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
    if( newState == GameCharacterStateTapEnd ){
        self.visible = NO;
        //action = [CCSequence actions:action,[CCFadeOut actionWithDuration:0.2f], nil];
    } else if( newState == GameCharacterStateTapStart ){
        self.visible = YES;
        //action = [CCSequence actions:action,[CCFadeIn actionWithDuration:0.0f], nil];
    }
 
    [self runAction:action];
}

- (void)updateStateWidthDeltaTime:(float)deltaTime
             andListOfGameObjects:(CCArray *)listOfGameObjects{
    
}
@end
