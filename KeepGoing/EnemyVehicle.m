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
		
        self.type = t;
        self.sprite = [CCSprite spriteWithFile:@"c1.png"];
        
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
