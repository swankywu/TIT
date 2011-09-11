//
//  ChorusLevelScene.m
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "ChorusScene.h"


@implementation ChorusScene
@synthesize bgLayer;
@synthesize gameLayer;

- (void)dealloc{
    self.bgLayer = nil;
    self.gameLayer = nil;
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.bgLayer = [CCLayerColor layerWithColor:ccc4(0xff,0xff,0xff,0xff)
                                              width:winSize.width 
                                             height:winSize.height];
        [self addChild:bgLayer z:0];
        self.gameLayer = [ChorusLayer node];
        [self addChild:gameLayer z:1];
    }
    return self;
}


@end
