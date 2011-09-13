//
//  Singer.h
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCharacter.h"
#import "SimpleAudioEngine.h"

@interface Singer : GameCharacter {
    CDSoundSource *soundSource;
    int soundPlayId;
}




@end
