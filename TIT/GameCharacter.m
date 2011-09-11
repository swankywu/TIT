//
//  GameCharacter.m
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GameCharacter.h"


@implementation GameCharacter
@synthesize state;
@synthesize animDic;

- (void)dealloc{
    self.animDic = nil;
    [super dealloc];
}

- (id)init{
    if( self = [super init]){
        self.animDic = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -
- (void)changeState:(GameCharacterState)newState{
    CCLOG(@"GameObject->changeState method should be overridden");
}

- (void)changeStateByNumber:(NSNumber*)newState{
    [self changeState:[newState intValue]];
}

- (void)changeStateByAnimationName:(NSString*)animationName{
    for(id ani in animDic){
        if( [[animDic objectForKey:ani] name] == animationName ){
            [self changeState:[ani intValue]];
            break;
        }
    }
}


-(void)checkAndClampSpritePosition{
    CGPoint currentSpritePosition = [self position];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Clamp for the iPad
        if (currentSpritePosition.x < 30.0f) {
            [self setPosition:ccp(30.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 1000.0f) {
            [self setPosition:ccp(1000.0f, currentSpritePosition.y)];
        }
    } else {
        //Clamp for iPhone, iPhone 4, or iPod touch
        if (currentSpritePosition.x < 24.0f) {
            [self setPosition:ccp(24.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 456.0f) {
            [self setPosition:ccp(456.0f, currentSpritePosition.y)];
        }
    }
}

#pragma mark -
- (CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                 andClassName:(NSString*)className
                       withGameCharacterState:(GameCharacterState)theState{
    id anim = [super loadPlistForAnimationWithName:animationName andClassName:className];
    [self.animDic setValue:anim forKey:[NSString stringWithFormat:@"%d", theState]];
    return anim;
    
}



@end
