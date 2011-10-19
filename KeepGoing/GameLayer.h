//
//  HelloWorldLayer.h
//  KeepGoing
//
//  Created by Stephen Ceresia on 11-09-27.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface GameLayer : CCLayer
{
    CGSize screenSize;
    
    CCSprite *playerSprite;
    CGPoint playerVelocity;
    
    CCSprite *r1;
    CCSprite *r2;
    CCSprite *l1;
    CCSprite *l2;
    
    //int roadSegment1;
    //int roadSegment2;
    int checkCount1;
    int checkCount2;
    
    // Road Segments
    NSDictionary *levelDictionary;
    NSArray *keysArray;
    int currentLevelIndexCount;
    int currentLevelIndex;
    int currentLevelPieceLoopCount;
}

@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) NSDictionary *levelDictionary;
@property (nonatomic, retain) NSArray *keysArray;

+(CCScene *) scene;
- (void) stopGame;
- (void) loadBg;
- (void) loadPlayerSprite;
- (void) levelUp;

@end
