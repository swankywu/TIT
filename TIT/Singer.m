//
//  Singer.m
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "Singer.h"


@implementation Singer
- (id) init{
    self = [super init];
    if( self ){
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"common_atlas.png"];
        CCSprite *singerSprite = [CCSprite spriteWithSpriteFrameName:@"singer0.png"];
        self.contentSize = singerSprite.contentSize;
        [batchNode addChild:singerSprite];
        [self addChild:batchNode];
        batchNode.position = ccp(self.contentSize.width/2,self.contentSize.height/2);

    }
    return self;
}
@end
