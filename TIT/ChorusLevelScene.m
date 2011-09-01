//
//  ChorusLevelScene.m
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "ChorusLevelScene.h"
#import "Singer.h"
#import "ChorusSinger.h"

@implementation ChorusLevelScene
- (id)init{
    if (self = [super init]) {
        
        Singer *singer = [ChorusSinger node];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        singer.position = ccp(winSize.width-50 - singer.contentSize.width/2, 50+singer.contentSize.height/2);
        CCLOG(@"%f, %f", singer.contentSize.width, singer.contentSize.height);
        [self.rootLayer addChild:singer];
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)dt {
    if( self.rootLayer.isTouched ) {
        
    } else{

    }
}


@end
