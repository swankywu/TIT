//
//  GameObject.m
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject
@synthesize isActive;
@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize type;

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        isActive = YES;
        screenSize = [CCDirector sharedDirector].winSize;
        type = GameObjectTypeNone;
    }
    return self;
}


#pragma mark -

- (void)updateStateWidthDeltaTime:(float)deltaTime
             andListOfGameObjects:(CCArray*)listOfGameObjects{
    CCLOG(@"GameObject->updateStateWithDeltaTime method should be overridden");   
}

- (CGRect)adjustedBoundingBox{
    CCLOG(@"GameObect adjustedBoundingBox should be overridden");
    return [self boundingBox];
}

- (CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                 andClassName:(NSString*)className{
    
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    // 1: Get the Path to the plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
    }
    // 2: Read in the plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    // 4: Get just the mini-dictionary for this animation
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil; }
    
    // 5: Get the delay value for the animation
    float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    // 6: Add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix,frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    return animationToReturn;
}

@end
