//
//  GameScene.h
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameSceneLayer.h"

@interface GameScene : CCScene {
    GameSceneLayer *_rootLayer;
}

@property (retain, nonatomic) GameSceneLayer *rootLayer;

@end
