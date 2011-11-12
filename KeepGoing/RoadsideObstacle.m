//
//  RoadsideObstacle.m
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RoadsideObstacle.h"
#import "VariableStore.h"

@implementation RoadsideObstacle

@synthesize sprite;
@synthesize type;

-(id) initWithType:(NSString *) t
{
    if( (self=[super init])) {
		
        screenSize = [[CCDirector sharedDirector] winSize];

        self.type = t;
        
        if ([self.type isEqualToString:@"rock"])
        {
            [self loadRockObstacle];
        } else if ([self.type isEqualToString:@"tree"])
        {
            [self loadTreeObstacle];
        }
        
	}
    
	return self;
}

- (void) loadRockObstacle
{
    
    
    
    self.sprite = [CCSprite spriteWithFile:@"rock.png"];
    [self.sprite.texture setAliasTexParameters];
    //self.sprite.position = ccp(screenSize.width/2,self.sprite.position.y);
    self.sprite.position = ccp(screenSize.width/2, self.sprite.position.y); // LEFT LANE

    /*
    if (CCRANDOM_0_1() > 0.5)
    {
        // LEFT LANE
        self.sprite.position = ccp(screenSize.width/3, self.sprite.position.y);
        
    } else {
        // RIGHT LANE
        self.sprite.position = ccp(screenSize.width - screenSize.width/3, self.sprite.position.y);
        
    }
     */
}

- (void) loadTreeObstacle
{
    self.sprite = [CCSprite spriteWithFile:@"tree.png"];
    [self.sprite.texture setAliasTexParameters];
    self.sprite.position = ccp(screenSize.width/4, self.sprite.position.y); // LEFT LANE

}


- (void) dealloc
{
    [sprite release];
    [type release];
	[super dealloc];
}


@end
