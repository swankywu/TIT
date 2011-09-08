//
//  GameManager.m
//  TIT
//
//  Created by swanky on 9/7/11.
//  Copyright 2011 iBrother. All rights reserved.
//
#import <Foundation/NSException.h>
#import "cocos2d.h"
#import "GameManager.h"
#import "GameScene.h"
#import "SplashScene.h"
#import "ChorusScene.h"



@implementation GameManager
static GameManager *_singletonSharedGameManager = nil;
@synthesize isMusicOn;
@synthesize isSoundEffectsOn;
@synthesize isGameOver;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])
    {
        if(!_singletonSharedGameManager)
            [[self alloc] init];
        return _singletonSharedGameManager;
        return nil;

    }
}

+(id)alloc {
    @synchronized ([GameManager class])
    {
//        NSAssert(_singletonSharedGameManager == nil,
//                 @"Attempted to allocate a second instance of the Game
//                 Manager singleton");
        _singletonSharedGameManager = [super alloc];
        return _singletonSharedGameManager;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        isMusicOn = YES;
        isSoundEffectsOn = YES;
        isGameOver = NO;
        currentScene = SceneTypeUninitialized;
    }
    
    return self;
}


- (void)runSceneWithSceneType:(SceneType)sceneType{
    NSLog(@"%d", sceneType);
    id sceneToRun = nil;
    if (sceneType == SceneTypeChorus) {
        sceneToRun = [ChorusScene node];
    }else if(sceneType == SceneTypeSplash){
        sceneToRun = [SplashScene node];
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
}

@end
