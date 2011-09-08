//
//  ChorusLevelScene.h
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelScene.h"
#import "ChorusSinger.h"

@interface ChorusScene : LevelScene<IBroGestureDelegate> {
    ChorusSinger *player;
    NSArray *otherChorusSingers;
}

@property (nonatomic, retain) ChorusSinger *player;
@property (nonatomic,retain) NSArray *otherChorusSingers;

@end
