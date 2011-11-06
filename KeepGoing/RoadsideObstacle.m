//
//  RoadsideObstacle.m
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RoadsideObstacle.h"

@implementation RoadsideObstacle

@synthesize sprite;
@synthesize type;

-(id) initWithType:(NSString *) t
{
    if( (self=[super init])) {
		
        screenSize = [[CCDirector sharedDirector] winSize];

        float gameSpeed = 1.5f; // GET GLOBAL GAME SPEED
        self.type = t;
        self.sprite = [CCSprite spriteWithFile:@"tree.png"];
        [self.sprite.texture setAliasTexParameters];
        self.sprite.position = ccp(self.sprite.contentSize.width/2, screenSize.height + self.sprite.contentSize.height);
        id actionMove1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(self.sprite.contentSize.width/2, -self.sprite.contentSize.height)];
        id actionClean = [CCCallFuncND actionWithTarget:self.sprite selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
        [self.sprite runAction:[CCSequence actions:actionMove1, actionClean, nil]];
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
