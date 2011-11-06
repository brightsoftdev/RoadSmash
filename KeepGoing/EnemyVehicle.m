//
//  EnemyVehicle.m
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EnemyVehicle.h"

@implementation EnemyVehicle

@synthesize sprite;
@synthesize type;


-(id) initWithType:(NSString *) t
{
    if( (self=[super init])) {
		
        if( (self=[super init])) {
            
            screenSize = [[CCDirector sharedDirector] winSize];
            
            float gameSpeed = 1.5f; // GET GLOBAL GAME SPEED
            self.type = t;
            
            if ([self.type isEqualToString:@"car"])
            {
                self.sprite = [CCSprite spriteWithFile:@"c1.png"];
                [self.sprite runAction:[CCTintTo actionWithDuration:0 red:0 green:0 blue:255]];

            } else if ([self.type isEqualToString:@"bike"])
            {
                self.sprite = [CCSprite spriteWithFile:@"b1.png"];
            }
            
            // set left or right lane
            float moveToPosX;
            if (CCRANDOM_0_1() > 0.5)
            {
                // LEFT LANE
                self.sprite.position = ccp(screenSize.width/4, screenSize.height + self.sprite.contentSize.height);
                //moveToPosX = screenSize.width/4;

            } else {
                // RIGHT LANE
                self.sprite.position = ccp(screenSize.width - screenSize.width/4, screenSize.height + self.sprite.contentSize.height);
                //moveToPosX = screenSize.width - screenSize.width/4;

            }
            
            //set moveto lane
            if (CCRANDOM_0_1() > 0.5)
            {
                moveToPosX = screenSize.width/4;
            } else {
                moveToPosX = screenSize.width - screenSize.width/4;

            }
            
            [self.sprite.texture setAliasTexParameters];
            id actionMove1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(moveToPosX, -self.sprite.contentSize.height)];
            id actionClean = [CCCallFuncND actionWithTarget:self.sprite selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
            [self.sprite runAction:[CCSequence actions:actionMove1, actionClean, nil]];
            
            // engine shaking effect
            id actionR = [CCRotateBy actionWithDuration:0.02f angle:1.5];
            id actionL = [CCRotateBy actionWithDuration:0.02f angle:-1.5];
            id seq = [CCRepeatForever actionWithAction:[CCSequence actions: actionR, [actionR reverse], actionL, [actionL reverse], nil]];
            [self.sprite runAction:seq];
            
        }
        return self;
        
	}
	return self;
}


- (void) dealloc
{
    [sprite release];
    [type release];
	[super dealloc];
}

@end
