//
//  HelloWorldLayer.h
//  KeepGoing
//
//  Created by Stephen Ceresia on 11-09-27.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "HUDLayer.h"

@interface GameLayer : CCLayer
{
    CGSize screenSize;
    
    HUDLayer *hudLayer;
    
    float gameSpeed;
        
    // Score, etc.
    int score;
    
    // Player vars
    CCSprite *playerSprite;
    CGPoint playerVelocity;
    BOOL isJumping;
    
    // Enemy/obstacle vars
    CCLayer *obstacleLayer;
    CCSprite *rockSprite;
    CCSprite *bikeSprite;
    
    // Environment vars
    CCLayer *roadLayer;
    CCSprite *road1;
    CCSprite *road2;
    int checkCount1;
    int checkCount2;
    //int roadSegment1;
    //int roadSegment2;
    int currentRoadTexture;
    
    //NSArray *roadArray;
    int currentRoadIndex1;
    int currentRoadIndex2;
    int maxScreens;
    //NSArray *loopsArray;
    
    NSDictionary *levelDict;
        
}

@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) CCSprite *rockSprite;
@property (nonatomic, retain) CCSprite *bikeSprite;

//@property (nonatomic, retain) NSArray *roadArray;
//@property (nonatomic, retain) NSArray *loopsArray;

@property (nonatomic, retain) NSDictionary *levelDict;

+(CCScene *) scene;
- (void) stopGame;
- (void) loadPlayerSprite;
- (void) setIsJumpingStatus;
- (void) loadBackground;
- (void) updateScore;
- (int) getLoopValueForIndex:(int) i;


@end
