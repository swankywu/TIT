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
    ChorusSinger *singer0;
    ChorusSinger *singer1;
    ChorusSinger *player;
    NSArray *otherChorusSingers;
    CCLabelBMFont *songProgressLabel;
    NSMutableArray *chorusTemplateArray;
}

@property (nonatomic, retain) ChorusSinger *player;
@property (nonatomic, retain) ChorusSinger *singer0;
@property (nonatomic, retain) ChorusSinger *singer1;
@property (nonatomic, retain) NSArray *otherChorusSingers;
@property (nonatomic, retain) CCLabelBMFont *songProgressLabel;
@property (nonatomic, retain) NSMutableArray *chorusTemplateArray;


- (void)loadSongScriptByName:(NSString*)scriptName;


@end
