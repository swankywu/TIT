//
//  InitScene.m
//  TIT
//
//  Created by Swanky on 11-8-31.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "InitScene.h"
#import "ChorusLevelScene.h"


@implementation InitScene
- (void)dealloc{
    [super dealloc];
}


- (void)changeScene{
    [[CCDirector sharedDirector] replaceScene:[ChorusLevelScene node]];
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
