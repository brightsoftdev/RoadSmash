//
//  HUDLayer.m
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"
#import "Constants.h"

@implementation HUDLayer

@synthesize scoreLabel;

-(id) init
{
	
	if( (self=[super init] )) 
	{
        
		screenSize = [[CCDirector sharedDirector] winSize];
		[self loadScoreLabel];
		
	}
	return self;
}

- (void) loadScoreLabel
{
    scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:SCORE_FONT];
	
    scoreLabel.position = ccp(screenSize.width/2, screenSize.height - scoreLabel.contentSize.height/1.1);
	
    [scoreLabel.texture setAliasTexParameters];
    
    [self addChild:scoreLabel z:999];

}

- (void) dealloc
{

	[super dealloc];
}

@end
