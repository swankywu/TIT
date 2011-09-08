//
//  ChorusLayer.m
//  TIT
//
//  Created by swanky on 9/8/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "ChorusLayer.h"
#define kSingerIntervalWidth 50
#define kSingerIntervalHeight 20
#define kSingerMarginBottom 40
#define kSingerBoundX (86/2)
#define kSingerBoundY (144/2)

@implementation ChorusLayer
@synthesize player;
@synthesize otherChorusSingers;

- (void)dealloc{
    self.player = nil;
    self.otherChorusSingers = nil;
    [super dealloc];
}


- (id)init{
    if(self = [super init] ){
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (int i=1; i<=3; ++i) {
            ChorusSinger *singer = [ChorusSinger spriteWithSpriteFrameName:@"singer0.png"];
            singer.position = ccp(singer.screenSize.width-(kSingerIntervalWidth+kSingerBoundX)*i, 
                                  kSingerIntervalHeight*i + kSingerBoundY + kSingerMarginBottom);
            [self.batchNode addChild:singer];
            if( player == nil)
                self.player = singer;
            else
                [arr addObject:singer];
            
        }
        self.otherChorusSingers = arr;       
        [arr release];
        [self scheduleUpdate];

    }
    return self;
}


- (void)update:(ccTime)dt {
    if( self.isTouched ) {
        [player changeState: GameCharacterStateIdle];
    } else{
        [player changeState: GameCharacterStateSingLow];
    }
}

#pragma mark - gesture delegate
- (void)gestureDetected:(IBroGestureArgs*)gestureArgs{
    if( gestureArgs.gestureType== IBroGestureTypeLine ){
        [player changeState:GameCharacterStateSingHigh];
    }
    
    [super gestureDetected:gestureArgs];
}

@end
