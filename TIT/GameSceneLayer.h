//
//  GameSceneLayer.h
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TapTouchItem.h"
#import "IBroGesture.h"

@interface GameSceneLayer : CCLayerColor{
@private
    bool isTouched;
    CCSpriteBatchNode *batchNode;
    TapTouchItem *tapTouchItem;    
    IBroGesture *gesture;
}

@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, retain) TapTouchItem *tapTouchItem;  
@property (readonly) bool isTouched;
@property (nonatomic, retain) IBroGesture *gesture;

@end
