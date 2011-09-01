//
//  ChorusPlayer.m
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//
#import "CCActionGrid3D.h"
#import "ChorusPlayer.h"


@implementation ChorusPlayer
- (id)init{
    if( self = [super init] ){
        
        [self runAction:[CCSequence actions:
                          [CCMoveTo actionWithDuration:2 position:ccp(5, 5)],
                          nil]];
        

        
    }
    return self;
}
@end
