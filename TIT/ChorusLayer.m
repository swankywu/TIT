//
//  ChorusLayer.m
//  TIT
//
//  Created by swanky on 9/8/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "CCNode.h"
#import "NSMutableArrayQueueExtend.h"
#import "GameManager.h"
#import "ChorusLayer.h"


#define kSingerMarginBottom 240
#define kMinStartSeconds 3.0f
#define kStareRadio 0.7f

@interface ChorusLayer(Private)
- (void)synicSingersScript;
- (void)startOtherSingerStarePlayer;
- (void)synicPlayerScript;
- (void)synicSoundScript;
- (void)updateSongTemplate;
- (void)updatePlayerState:(ccTime)dt;
@end


@implementation ChorusLayer
@synthesize player, singer0, singer1;
@synthesize otherChorusSingers;
@synthesize songProgressLabel;
@synthesize singersScrpitQueue;
@synthesize playerScriptQueue;
@synthesize soundScriptQueue;

- (void)dealloc{
    self.player = nil;
    self.singer0 = nil;
    self.singer1 = nil;
    self.otherChorusSingers = nil;
    self.songProgressLabel = nil;
    self.singersScrpitQueue = nil;
    self.playerScriptQueue = nil;
    self.soundScriptQueue = nil;
    [super dealloc];
}


- (id)init{
    if(self = [super init] ){
        
        //singers and player
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (int i=1; i<4; ++i) {
            ChorusSinger *singer = [ChorusSinger spriteWithSpriteFrameName:@"singer0.png"];
            float singerSpritWidth = [singer boundingBox].size.width;
            float singerSpritHeight = [singer boundingBox].size.height;
            singer.position = ccp(singer.screenSize.width - (singerSpritWidth)*i, 
                                  singerSpritHeight/4*i  + kSingerMarginBottom);
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
        
        //chorus conductor
        
        ChorusConductor *conductor = [ChorusConductor spriteWithSpriteFrameName:@"conductor0.png"];
        
        conductor.position = ccp(80,180);
        [self.batchNode addChild:conductor];
        
        //points set
        gameHighPoints = 0;
        playerPoints = 0;
        timeGainPoints = 0;
        timeCutDownPoints = 0;
        
        //songs template
        [self loadSongScriptByName:@"TutorialSong"];
       
        
        
        //bmfonts
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.songProgressLabel = [CCLabelBMFont labelWithString:@"0:00.0" fntFile:@"v5pixl.fnt"];
        songProgressLabel.anchorPoint = CGPointMake(0, 0.5);
        songProgressLabel.position = ccp(winSize.width-songProgressLabel.contentSize.width - 5, songProgressLabel.contentSize.height/2 + 5);
        [self addChild:songProgressLabel];

        
        //update
        [self schedule:@selector(updatePlayerState:)];
        [self schedule:@selector(updateSongTemplate)];
    }
    return self;
}


- (void)synicSingersScript{
    AVAudioPlayer *avPlayer = [GameManager sharedGameManager].avPlayer;
    NSDictionary *singData = [singersScrpitQueue peek];
    if( singData ){
        NSTimeInterval startedTime = [[singData objectForKey:@"startedTime"] floatValue];
        if(avPlayer.currentTime > startedTime){
            singData = [singersScrpitQueue dequeue]; //remove it
            NSString *changeStatePlayerName = [singData objectForKey:@"singer"];
            id changeState = [singData objectForKey:@"changeStateNum"];
            id duration = [singData objectForKey:@"duration"];
            id singer = [self valueForKey:changeStatePlayerName];
            [singer changeState:[changeState intValue]];
            [singer performSelector:@selector(changeStateByNumber:)
                         withObject:[NSNumber numberWithInteger:GameCharacterStateIdle]
                         afterDelay:[duration floatValue]];
            
        }
    }

}

- (void)startOtherSingerStarePlayer{
    for (id singer in otherChorusSingers) {
        if( [singer state] == GameCharacterStateIdle ){
            [singer changeState:GameCharacterStateSingStare];
            [singer performSelector:@selector(changeStateByNumber:)
                         withObject:[NSNumber numberWithInt:GameCharacterStateIdle] 
                         afterDelay:5.0f];
        }
    }

}

- (void)synicPlayerScript{
    AVAudioPlayer *avPlayer = [GameManager sharedGameManager].avPlayer;
    NSDictionary *peekData = [playerScriptQueue peek];
    BOOL hasTemplateTouch = NO;
    if( peekData ){
        NSTimeInterval startedTime = [[peekData objectForKey:@"startedTime"] floatValue];
        NSTimeInterval residual = [[peekData objectForKey:@"residual"] floatValue];
        NSTimeInterval duration = [[peekData objectForKey:@"duration"] floatValue];
        if(avPlayer.currentTime > startedTime - residual && avPlayer.currentTime < startedTime + duration + residual){
            hasTemplateTouch = YES;
            
            int changeState = [[peekData objectForKey:@"changeStateNum"] intValue];
            if( changeState == player.state ){
                timeGainPoints ++;
            } else {
                timeCutDownPoints ++;
            }

        } else if( avPlayer.currentTime > startedTime + duration + residual){
            hasTemplateTouch = YES;
            int basePoint = [[peekData objectForKey:@"point"] intValue];
            float percentGain = (float)timeGainPoints /(timeGainPoints + timeCutDownPoints);
            int playerGainPoints =  percentGain * basePoint;
            
            playerPoints += playerGainPoints;
            
            NSLog(@"ChorusLayer -> player's time gain points:%d and time cut down points:%d right radio :%f curent gain points:%d, gameHighPoints:%d, player points:%d",timeGainPoints, timeCutDownPoints, percentGain, playerGainPoints, gameHighPoints, playerPoints);
            if( percentGain < kStareRadio ){
                [self startOtherSingerStarePlayer];
            }
            
            //reset data
            timeGainPoints = 0;
            timeCutDownPoints = 0;
            [playerScriptQueue dequeue];  //remove it
        }
    } 
    if( !hasTemplateTouch && avPlayer.currentTime > kMinStartSeconds){
        if( player.state != GameCharacterStateIdle ){
            playerPoints--;
            [self startOtherSingerStarePlayer];
        }
    }
}

- (void)synicSoundScript{
    AVAudioPlayer *avPlayer = [GameManager sharedGameManager].avPlayer;
    NSDictionary *peekData = [soundScriptQueue peek];
    if( peekData ){
        NSTimeInterval startedTime = [[peekData objectForKey:@"startedTime"] floatValue];
        if(avPlayer.currentTime > startedTime){
            peekData = [soundScriptQueue dequeue]; //remove it
            
            id duration = [peekData objectForKey:@"duration"];
            id fileName = [peekData objectForKey:@"fileName"];
            int remindSoundId = [[GameManager sharedGameManager] playSoundEffect:fileName];
            if( remindSoundId > 0 ){
                [[GameManager sharedGameManager] performSelector:@selector(stopSoundEffectByNumber:)
                                                      withObject:[NSNumber numberWithInteger:remindSoundId]
                                                      afterDelay:[duration floatValue]];
            }
        }
    }
}

- (void)updateSongTemplate{
    AVAudioPlayer *avPlayer = [GameManager sharedGameManager].avPlayer;
    if( avPlayer != nil && avPlayer.playing){
        NSString *songProgress =  [NSString stringWithFormat:@"%d:%02d.%d", (int)avPlayer.currentTime / 60, (int)avPlayer.currentTime % 60, (int)(avPlayer.currentTime*10) % 10, nil];
        [self.songProgressLabel setString:songProgress];

        //singers script
        [self synicSingersScript];
        //player script
        [self synicPlayerScript];
        
        //sound script
        [self synicSoundScript];
    } else { //game over display points
        NSLog(@"ChorusLayer -> Game over: Player's points:%d and all points:%d", playerPoints, gameHighPoints);
        //TODO change scence here
    }

}
- (void)updatePlayerState:(ccTime)dt {
    if( self.isTouched ) {
        [player changeState: GameCharacterStateIdle];
        //[player changeStateByAnimationName:@"idelAnim"];
    } else{
        [player changeState: GameCharacterStateSingLow];
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
    
    self.singersScrpitQueue =[NSMutableArray arrayWithArray: [dic objectForKey:@"singersScrpitQueue"]];
    self.playerScriptQueue = [NSMutableArray arrayWithArray: [dic objectForKey:@"playerScriptQueue"]];
    self.soundScriptQueue = [NSMutableArray arrayWithArray: [dic objectForKey:@"soundScriptQueue"]];
    
    for (id plData in playerScriptQueue) {
        int basePoint = [[plData objectForKey:@"point"] intValue];
        gameHighPoints += basePoint;
    }
    
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
