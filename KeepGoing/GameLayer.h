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
    
    float gameSpeed;
    
    CCLayer *roadLayer;
    
    // Player vars
    CCSprite *playerSprite;
    CGPoint playerVelocity;
    BOOL isJumping;
    
    // Enemy/obstacle vars
    CCSprite *rockSprite;
    CCSprite *waterSprite;
    CCSprite *bikeSprite;
    NSMutableArray *enemyArray;
    
    // Environment vars
    CCSprite *road1;
    CCSprite *road2;
    int checkCount1;
    int checkCount2;
    int roadSegment1;
    int roadSegment2;

    /*
    CCSprite *r1;
    CCSprite *r2;
    CCSprite *l1;
    CCSprite *l2;
    */

}

@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) CCSprite *rockSprite;
@property (nonatomic, retain) CCSprite *waterSprite;
@property (nonatomic, retain) CCSprite *bikeSprite;
@property (nonatomic, retain) NSMutableArray *enemyArray;

+(CCScene *) scene;
- (void) stopGame;
- (void) loadPlayerSprite;
- (void) setIsJumpingStatus;
- (void) loadBackground;

@end
