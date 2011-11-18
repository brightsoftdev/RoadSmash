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
        [self loadHUDmask];
		
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

- (void) loadHUDmask
{
    CCLayerColor *maskBg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 200) width:screenSize.width height:screenSize.height/16];
    [self addChild:maskBg];
    
    //CCLayerColor *mask = [CCLayerColor layerWithColor:ccc4(0, 51, 102, 180) width:screenSize.width height:screenSize.height/18];
    //[self addChild:mask];
}

- (void) dealloc
{

	[super dealloc];
}

@end
