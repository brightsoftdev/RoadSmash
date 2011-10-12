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
    
    //CCRenderTexture* _rt;
    int roadSegment1;
    int roadSegment2;
    int checkCount1;
    int checkCount2;

}

@property (nonatomic, retain) CCSprite *playerSprite;
//@property (nonatomic,assign) CCRenderTexture *_rt;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(BOOL) isCollisionBetweenSpriteA:(CCSprite*)spr1 spriteB:(CCSprite*)spr2 pixelPerfect:(BOOL)pp;
- (void) stopGame;

@end
