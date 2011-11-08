//
//  VariableStore.h
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariableStore : NSObject
{
    float gameSpeed;
    int currentLevel;
}

@property (nonatomic) float gameSpeed;
@property (nonatomic) int currentLevel;

+ (VariableStore *)sharedInstance;



@end
