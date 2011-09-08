//
//  ChorusLayer.h
//  TIT
//
//  Created by swanky on 9/8/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GestureLayer.h"
#import "ChorusSinger.h"

@interface ChorusLayer : GestureLayer {
    ChorusSinger *player;
    NSArray *otherChorusSingers;
}

@property (nonatomic, retain) ChorusSinger *player;
@property (nonatomic, retain) NSArray *otherChorusSingers;


@end
