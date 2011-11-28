//
//  EnemyVehicle.h
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyVehicle : NSObject
{
    
    CGSize screenSize;

    CCSprite *sprite;
    NSString *type;
    
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) NSString *type;

-(id) initWithType:(NSString *) t;
- (void) loadSpriteForType;


@end
