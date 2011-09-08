//
//  ChorusLevelScene.m
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "ChorusLevelScene.h"


#define kSingerIntervalWidth 50
#define kSingerIntervalHeight 20
#define kSingerMarginBottom 40
#define kSingerBoundX (86/2)
#define kSingerBoundY (144/2)

@implementation ChorusLevelScene
@synthesize player;
@synthesize otherChorusSingers;

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];

        for (int i=1; i<=3; ++i) {
            ChorusSinger *singer = [ChorusSinger spriteWithSpriteFrameName:@"singer0.png"];
            singer.position = ccp(singer.screenSize.width-(kSingerIntervalWidth+kSingerBoundX)*i, 
                                  kSingerIntervalHeight*i + kSingerBoundY + kSingerMarginBottom);
            [self.rootLayer.batchNode addChild:singer];
            if( player == nil)
                self.player = singer;
            else
                [arr addObject:singer];

        }
        self.otherChorusSingers = arr;       
        [arr release];
        
        
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.mp3" loop:YES];
        [self scheduleUpdate];
        
        //gesture
        self.rootLayer.gesture.delegate = self;
    }
    return self;
}

- (void)update:(ccTime)dt {
    if( self.rootLayer.isTouched ) {
        [player changeState: GameCharacterStateIdle];
    } else{
        [player changeState: GameCharacterStateSingLow];
    }
}


#pragma mark - gesture delegate

- (void)lineGestureDetected:(NSNumber*)delta{
    //NSTimeInterval time = [delta doubleValue];
    NSLog(@"ChorusLevelScene -> line gesture detected!");
    [player changeState:GameCharacterStateSingHigh];
}


@end
