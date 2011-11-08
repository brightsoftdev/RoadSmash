//
//  RoadsideObstacle.h
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface RoadsideObstacle : NSObject
{
    CGSize screenSize;
    
    CCSprite *sprite;
    NSString *type;
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) NSString *type;

-(id) initWithType:(NSString *) t;

- (void) loadRockObstacle;
- (void) loadTreeObstacle;



@end
