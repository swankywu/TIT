//
//  InitScene.m
//  TIT
//
//  Created by Swanky on 11-8-31.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "SplashScene.h"
#import "GameManager.h"


@implementation SplashScene
- (void)dealloc{
    [super dealloc];
}


- (void)changeScene{
    [[GameManager sharedGameManager] runSceneWithSceneType:SceneTypeChorus];
}
- (id)init{
    if(self = [super init]){
        //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"sing_low.aiff"];
        [self performSelector:@selector(changeScene) withObject:nil afterDelay:0.1];

    }
    return self;
}

@end
