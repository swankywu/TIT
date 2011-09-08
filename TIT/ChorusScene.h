//
//  ChorusLevelScene.h
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChorusLayer.h"
#import "LevelScene.h"


@interface ChorusScene : LevelScene{
    CCLayer *bgLayer;
    ChorusLayer *gameLayer;
}
@property (nonatomic, retain) CCLayer *bgLayer;
@property (nonatomic, retain) ChorusLayer *gameLayer;


@end
