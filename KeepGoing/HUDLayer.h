//
//  HUDLayer.h
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HUDLayer : CCLayer
{
    CGSize screenSize;
	CCLabelBMFont *scoreLabel;
    
}

@property (nonatomic, retain) CCLabelBMFont *scoreLabel;

- (void) loadScoreLabel;


@end
