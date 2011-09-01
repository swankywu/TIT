//
//  GameSceneLayer.h
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameSceneLayer : CCLayerColor {
    bool _isTouched;
    CCSprite *_touchSprite;
    CCSpriteBatchNode *_batchNode;
    
}

@property (nonatomic, retain) CCSprite *touchSprite;  
@property (nonatomic, retain) CCSpriteBatchNode *batchNode;  

@property (nonatomic, readonly) bool isTouched;

@end
