//
//  GameScene.m
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

@synthesize rootLayer = _rootLayer;

- (id)init {
    self = [super init];
    if( self){
        self.rootLayer = [GameSceneLayer node];
        [self addChild:_rootLayer z:0];
    }
    return self;
}

- (void)dealloc{
    self.rootLayer = nil;
    [super dealloc];
}



@end
