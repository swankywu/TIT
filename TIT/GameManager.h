//
//  GameManager.h
//  TIT
//
//  Created by swanky on 9/7/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface GameManager : NSObject{
    BOOL isMusicOn;
    BOOL isSoundEffectsOn;
    BOOL isGameOver;
    SceneType currentScene;
}

@property BOOL isMusicOn;
@property BOOL isSoundEffectsOn;
@property BOOL isGameOver;

+ (GameManager*)sharedGameManager;
- (void) runSceneWithSceneType:(SceneType)sceneType;


@end
