//
//  GameObject.h
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Common.h"

@interface GameObject : CCSprite {
@private
    BOOL isActive;
    BOOL reactsToScreenBoundaries;
    CGSize screenSize;
    GameObjectType type;
}

@property BOOL isActive;
@property BOOL reactsToScreenBoundaries;
@property CGSize screenSize;
@property GameObjectType type;



- (void)updateStateWidthDeltaTime:(float)deltaTime
             andListOfGameObjects:(CCArray*)listOfGameObjects;
- (CGRect)adjustedBoundingBox;
- (CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                 andClassName:(NSString*)className;
@end
