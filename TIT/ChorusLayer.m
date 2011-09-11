//
//  ChorusLayer.m
//  TIT
//
//  Created by swanky on 9/8/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "NSMutableArrayQueueExtend.h"
#import "GameManager.h"
#import "ChorusLayer.h"

#define kSingerIntervalWidth 35
#define kSingerIntervalHeight 20
#define kSingerMarginBottom 200
#define kSingerBoundX (70/2)
#define kSingerBoundY (112/2)

@implementation ChorusLayer
@synthesize player, singer0, singer1;
@synthesize otherChorusSingers;
@synthesize songProgressLabel;
@synthesize chorusTemplateArray;

- (void)dealloc{
    self.player = nil;
    self.singer0 = nil;
    self.singer1 = nil;
    self.otherChorusSingers = nil;
    self.songProgressLabel = nil;
    [self.chorusTemplateArray removeAllObjects];
    self.chorusTemplateArray = nil;
    [super dealloc];
}


- (id)init{
    if(self = [super init] ){
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (int i=1; i<4; ++i) {
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
        self.singer0 = [arr objectAtIndex:1];
        self.singer1 = [arr objectAtIndex:0];
        [arr release];
        
        //template
        [self loadSongScriptByName:@"TutorialSong"];
       
        
        
        //bmfonts
      
        CGSize winSize = [CCDirector sharedDirector].winSize;

        self.songProgressLabel = [CCLabelBMFont labelWithString:@"0:00" fntFile:@"impact64.fnt"];
        self.songProgressLabel.position = ccp(winSize.width-50, 20);
        [self addChild:songProgressLabel];
        [self.songProgressLabel runAction:[CCScaleTo actionWithDuration:0 scale:0.5]];
        
        //update
         [self scheduleUpdate];
    }
    return self;
}


- (void)update:(ccTime)dt {
    if( self.isTouched ) {
        [player changeState: GameCharacterStateIdle];
        //[player changeStateByAnimationName:@"idelAnim"];
    } else{
        [player changeState: GameCharacterStateSingLow];
    }
    AVAudioPlayer *avPlayer = [GameManager sharedGameManager].avPlayer;
    if( avPlayer != nil){
        NSString *songProgress =  [NSString stringWithFormat:@"%d:%02d", (int)avPlayer.currentTime / 60, (int)avPlayer.currentTime % 60, nil];
        [self.songProgressLabel setString:songProgress];

        NSDictionary *singData = [chorusTemplateArray peek];
        if( singData ){
            NSTimeInterval startedTime = [[singData objectForKey:@"startedTime"] floatValue];
            if(avPlayer.currentTime > startedTime){
                singData = [chorusTemplateArray dequeue]; //remove it
                NSString *changeStatePlayerName = [singData objectForKey:@"singer"];
                id changeState = [singData objectForKey:@"changeStateNum"];
                id duration = [singData objectForKey:@"duration"];
                id singer = [self valueForKey:changeStatePlayerName];
                [singer changeState:[changeState intValue]];
                
//                [singer runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:[duration floatValue]] 
//                                                    two:[CCCallFuncO actionWithTarget:singer
//                                                                             selector:@selector(changeState:)
//                                                                               object:[NSNumber numberWithInt:GameCharacterStateIdle]]
//                 
//                                   ]];
                
                [singer performSelector:@selector(changeStateByNumber:)
                             withObject:[NSNumber numberWithInteger:GameCharacterStateIdle]
                             afterDelay:[duration floatValue]];

            }
        }
    }
}

- (void)loadSongScriptByName:(NSString*)scriptName{
    NSString *plistPath = [GameManager resourceFullPath: scriptName ofType:@"plist"];

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (dic == nil) {
        NSLog(@"Error reading plist: %@.plist", scriptName);
    }
    
    

    NSString *bgMusic = [dic objectForKey:@"bgMusic"];
    NSString *bgMusicType = [dic objectForKey:@"bgMusicType"];
    
    self.chorusTemplateArray =[NSMutableArray arrayWithArray: [dic objectForKey:@"queue"]];
    [[GameManager sharedGameManager] avPlay:bgMusic ofType:bgMusicType];    
}

#pragma mark - gesture delegate
- (void)gestureDetected:(IBroGestureArgs*)gestureArgs{
    if( gestureArgs.gestureType== IBroGestureTypeLine ){
        [player changeState:GameCharacterStateSingHigh];
    }
    
    [super gestureDetected:gestureArgs];
}

@end
