//
//  HelloWorldLayer.m
//  KeepGoing
//
//  Created by Stephen Ceresia on 11-09-27.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"

// HelloWorldLayer implementation
@implementation GameLayer

@synthesize playerSprite;
@synthesize levelDictionary;
@synthesize keysArray;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{

	if( (self=[super init])) {
		
        roadLayer = [CCLayer node];
        [self addChild:roadLayer z:5 tag:9999];
        
        self.isAccelerometerEnabled = YES;
        //self.isTouchEnabled = YES;
        
        screenSize = [[CCDirector sharedDirector] winSize];
        
        //levelDictionary = [[NSDictionary alloc] init];
        //keysArray = [[NSArray alloc] init];
        [self levelUp];
        [self scheduleUpdate];
        [self loadBg];
        [self loadPlayerSprite];
        
        //roadSegment1 = 0;
        //roadSegment2 = 0;
        checkCount1 = 0;
        checkCount2 = 0;

	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) levelUp
{
    levelDictionary = nil;
    keysArray = nil;
    
    int lv=1; //CURRENT LEVEL TEMP
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Level%idata", lv] ofType:@"plist"];
    //levelDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    levelDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //
    NSArray *unsortedKeys = [[NSArray alloc] initWithArray:[levelDictionary allKeys]];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    keysArray = [[NSArray alloc] initWithArray:sortedKeys];
    [unsortedKeys release];
    //
    
    /////keysArray = [[NSArray alloc] initWithArray:[levelDictionary allKeys]];
    ////[keysArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    /*
    NSArray *sortedKeys = [keysArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (id item in sortedKeys)
    {
        NSLog(@"item %@", item);
    }
    */
    
    currentLevelIndexCount = [keysArray count];
    currentLevelIndex = 0;
    
    //NSLog(@"currentLevelIndexCount = %i", [keysArray count]);
    //NSLog(@"currentLevelIndex = %i", currentLevelIndex);
}

- (int) getNumberOfRoadSegmentLoops
{

    id nextKey = [keysArray objectAtIndex:currentLevelIndex];
    
    //NSLog(@"got here");

    id nextValue = [levelDictionary objectForKey:nextKey];
    
    //NSLog(@"nextValue is %i", [nextValue intValue]);
    
    return [nextValue intValue];
}

- (NSString *) getRoadSegmentKeyForIndex
{
    NSString *key = [keysArray objectAtIndex:currentLevelIndex];
    NSString *newStr = [key substringFromIndex:1];
    
    NSLog(@"index %i, key is %@, with loops %i",currentLevelIndex,key,[self getNumberOfRoadSegmentLoops]);
    return newStr;
}


- (void) newRoadSegmentOneCheck
{
    
    //NSLog(@"ROAD CHECK 1");
    //NSLog(@"INDEX IS %i", currentLevelIndex);
    
    int currentRoadSegmentLoops = [self getNumberOfRoadSegmentLoops];
    
    if (checkCount1 >= currentRoadSegmentLoops)
    {
        // we need a new road segment
        //NSLog(@"NEED NEW ROAD SEGMENT1");
        checkCount1 = 1;
        
        if (currentLevelIndex >= currentLevelIndexCount)
        {
            // new level
            //NSLog(@"LEVEL UP");
            [self levelUp];
            
        }
        
        NSString *roadSegment1 = [self getRoadSegmentKeyForIndex];
        currentRoadSegmentLoops = [self getNumberOfRoadSegmentLoops];

        NSLog(@"NEW roadSegment1 string is %@ with %i loops", roadSegment1, currentRoadSegmentLoops);
        
        CCTexture2D *txtL=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@L", roadSegment1]]];
        CCTexture2D *txtR=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@R", roadSegment1]]];
        
        [l1 setTexture:txtL];
        [l1 setTextureRect:CGRectMake(0.0f, 0.0f, txtL.contentSize.width, txtL.contentSize.height)];
        [l1.texture setAliasTexParameters];
        [l2.texture setAliasTexParameters];
        
        [r1 setTexture:txtR];
        [r1 setTextureRect:CGRectMake(0.0f, 0.0f, txtR.contentSize.width, txtR.contentSize.height)];
        [r1.texture setAliasTexParameters];
        [r2.texture setAliasTexParameters];
        
        ++currentLevelIndex;

        
    } else {

        ++checkCount1;

    }
    
    
    

}

- (void) newRoadSegmentTwoCheck
{
    
    //NSLog(@"ROAD CHECK 2");
    //NSLog(@"INDEX IS %i", currentLevelIndex);
    
    int currentRoadSegmentLoops = [self getNumberOfRoadSegmentLoops];

    if (checkCount2 >= currentRoadSegmentLoops)
    {
        checkCount2 = 1;
        
        if (currentLevelIndex >= currentLevelIndexCount)
        {
            // new level
            [self levelUp];
            
        }
        
        NSString *roadSegment2 = [self getRoadSegmentKeyForIndex];
        currentRoadSegmentLoops = [self getNumberOfRoadSegmentLoops];
        
        NSLog(@"NEW roadSegment2 string is %@ with %i loops", roadSegment2, currentRoadSegmentLoops);
        
        CCTexture2D *txtL=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@L", roadSegment2]]];
        CCTexture2D *txtR=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@R", roadSegment2]]];
        
        [l2 setTexture:txtL];
        [l2 setTextureRect:CGRectMake(0.0f, 0.0f, txtL.contentSize.width, txtL.contentSize.height)];
        [l1.texture setAliasTexParameters];
        [l2.texture setAliasTexParameters];
        
        [r2 setTexture:txtR];
        [r2 setTextureRect:CGRectMake(0.0f, 0.0f, txtR.contentSize.width, txtR.contentSize.height)];
        [r1.texture setAliasTexParameters];
        [r2.texture setAliasTexParameters];
        
        ++currentLevelIndex;

    } else {
    
        ++checkCount2;
    
    }
    
}

#define TAG_ROADCOLORLAYER 111

- (void) loadBg
{
    
    CCLayerColor *roadColorLayer = [CCLayerColor layerWithColor: ccc4(102, 102, 102, 255)];
	[self addChild:roadColorLayer z:-1 tag:TAG_ROADCOLORLAYER];
    
    float speed = 2.0f;
    
    // LEFT SIDE
    l1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"1-1L.png"]];
	l2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"1-1L.png"]];
    [l1.texture setAliasTexParameters];
    [l2.texture setAliasTexParameters];
    l1.anchorPoint = ccp(0,0.5);
    l2.anchorPoint = ccp(0,0.5);

	
	[l1 setPosition:ccp(0,(screenSize.height/2))];
    [l2 setPosition:ccp(0,(screenSize.height*1.49))];

    id leftMove1 = [CCMoveTo actionWithDuration:speed position:ccp(0,-(screenSize.height/2))];
	id leftPlace1 = [CCPlace actionWithPosition:ccp(0,(screenSize.height/2))];
    id replaceOneCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentOneCheck)]; //****** should be here to come from offscreen
	id seqL1 = [CCSequence actions: leftMove1, leftPlace1, replaceOneCheck, nil];
    
	id leftMove2=[CCMoveTo actionWithDuration:speed position:ccp(0,(screenSize.height/2))];
    id leftPlace2 = [CCPlace actionWithPosition:ccp(0,(screenSize.height*1.49))];
    id replaceTwoCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentTwoCheck)]; //****** should be here to come from offscreen
	id seqL2=[CCSequence actions: leftMove2, leftPlace2, replaceTwoCheck, nil];
	
	[l1 runAction:[CCRepeatForever actionWithAction:seqL1]];
    [l2 runAction: [CCRepeatForever actionWithAction:seqL2]];
    
	[roadLayer addChild:l1 z:1];
	[roadLayer addChild:l2 z:1];
    
    // RIGHT SIDE
    r1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"1-1R.png"]];
	r2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"1-1R.png"]];
    [r1.texture setAliasTexParameters];
    [r2.texture setAliasTexParameters];
	r1.anchorPoint = ccp(1,0.5);
    r2.anchorPoint = ccp(1,0.5);
    
	[r1 setPosition:ccp(screenSize.width - 0,(screenSize.height/2))];
    [r2 setPosition:ccp(screenSize.width- 0,(screenSize.height*1.49))];
    
    
    id rightMove1 = [CCMoveTo actionWithDuration:speed position:ccp(screenSize.width- 0,-(screenSize.height/2))];
	id rightPlace1 = [CCPlace actionWithPosition:ccp(screenSize.width- 0,(screenSize.height/2))];
	id seqR1 = [CCSequence actions: rightMove1, rightPlace1,nil];
    
	id rightMove2=[CCMoveTo actionWithDuration:speed position:ccp(screenSize.width- 0,(screenSize.height/2))];
    id rightPlace2 = [CCPlace actionWithPosition:ccp(screenSize.width- 0,(screenSize.height*1.49))];
	id seqR2=[CCSequence actions: rightMove2, rightPlace2, nil];
	
	[r1 runAction:[CCRepeatForever actionWithAction:seqR1]];
    [r2 runAction: [CCRepeatForever actionWithAction:seqR2]];
	
    [roadLayer addChild:r1 z:1];
	[roadLayer addChild:r2 z:1];
    
    //[roadLayer runAction:seqL1];

}

- (void) loadPlayerSprite
{
    
    playerSprite = [CCSprite spriteWithFile:@"player.png"];
    [playerSprite.texture setAliasTexParameters];
    playerSprite.position = ccp(screenSize.width/2, playerSprite.contentSize.height*2);
    [self addChild:playerSprite z:1];
    
}

#define kHeroMovementAction 1
#define kPlayerSpeed 100

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // controls how quickly velocity decelerates (lower = quicker to change direction)
    float decelerationX = 0.01f;
    
    // determines how sensitive the accelerometer reacts (higher = more sensitive)
    float sensitivityX = 15.0f;
    
    float maxVelocity = 100;
    
    // adjust velocity based on current accelerometer acceleration
    playerVelocity.x = playerVelocity.x * decelerationX + acceleration.x * sensitivityX;

    // we must limit the maximum velocity of the player sprite, in both directions
    if (playerVelocity.x > maxVelocity)
    {
        playerVelocity.x = maxVelocity;
    }
    else if (playerVelocity.x < - maxVelocity)
    {
        playerVelocity.x = - maxVelocity;
    }
    
}

-(void) update:(ccTime)delta
{
    
    // Keep adding up the playerVelocity to the player's position
    CGPoint pos = playerSprite.position;
    pos.x += playerVelocity.x;
    //
    pos.y += playerVelocity.y;
    
    // The Player should also be stopped from going outside the screen
    float imageWidthHalved = [playerSprite texture].contentSize.width * 0.5f;
    float leftBorderLimit = imageWidthHalved;
    float rightBorderLimit = screenSize.width - imageWidthHalved;
    
    // preventing the player sprite from moving outside the screen
    if (pos.x < leftBorderLimit)
    {
        pos.x = leftBorderLimit;
        playerVelocity = CGPointZero;
    }
    else if (pos.x > rightBorderLimit)
    {
        pos.x = rightBorderLimit;
        playerVelocity = CGPointZero;
    }
    
    
    
    // KEEP THIS
    
    if (CGRectIntersectsRect(playerSprite.boundingBox, r1.boundingBox))
    {
        [self stopGame];
    } else if (CGRectIntersectsRect(playerSprite.boundingBox, r2.boundingBox))
    {
        [self stopGame];
    } else if (CGRectIntersectsRect(playerSprite.boundingBox, l2.boundingBox))
    {
        [self stopGame];
    } else if (CGRectIntersectsRect(playerSprite.boundingBox, l2.boundingBox))
    {
        [self stopGame];
    }
    
    // KEEP THIS
    
    // assigning the modified position back
    playerSprite.position = pos;
    
    //[self checkCollisions];

}

- (void) stopGame
{
    
    CCColorLayer *stopRedLayer = [CCColorLayer layerWithColor: ccc4(255, 0, 0, 80)];
	[self addChild:stopRedLayer z:-1 tag:TAG_ROADCOLORLAYER];
    
    [self unschedule:@selector(update:)];
    [[CCDirector sharedDirector] pause];
    NSLog(@"STOP GAME!");
}

- (void) dealloc
{
	[keysArray release];
    [levelDictionary release];
	[super dealloc];
}
@end
