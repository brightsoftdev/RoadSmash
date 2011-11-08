//
//  VariableStore.m
//  RoadSmash
//
//  Created by Stephen Ceresia on 11-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableStore.h"

@implementation VariableStore

@synthesize gameSpeed;
@synthesize currentLevel;

+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
	
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
		
    }
    // return the instance of this class
    return myInstance;
}

-(id) init
{
	if( (self=[super init] )) 
	{
        
		// do stuff later
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}


@end
