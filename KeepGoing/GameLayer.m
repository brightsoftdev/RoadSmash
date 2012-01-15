//
//  HelloWorldLayer.m
//  KeepGoing
//
//  Created by Stephen Ceresia on 11-09-27.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "GameLayer.h"
#import "Constants.h"
#import "RoadsideObstacle.h"
#import "EnemyVehicle.h"
#import "VariableStore.h"

@implementation GameLayer

@synthesize playerSprite;
@synthesize rockSprite;
@synthesize bikeSprite;

//@synthesize roadArray;
//@synthesize loopsArray;

@synthesize levelDict;

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
		
        self.isAccelerometerEnabled = YES;
        self.isTouchEnabled = YES;
        screenSize = [[CCDirector sharedDirector] winSize];
        
        // LAYERS
        hudLayer = [[HUDLayer alloc] init];
        [self addChild: hudLayer z:999 tag:TAG_HUDLAYER];
        roadLayer = [CCLayer node];
        [self addChild:roadLayer];
        obstacleLayer = [CCLayer node];
        [self addChild:obstacleLayer];
        
        /* // LEVEL ARRAYS
        NSString *path = [[NSBundle mainBundle] pathForResource:@"RoadSegments" ofType:@"plist"];
        roadArray = [[NSArray alloc] initWithContentsOfFile:path];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Loops" ofType:@"plist"];
        loopsArray = [[NSArray alloc] initWithContentsOfFile:path2];
        */
        
        // LEVEL DICTIONARY
        NSString *levelDictPath = [[NSBundle mainBundle] pathForResource:@"RSLevelData" ofType:@"plist"];
        levelDict = [[NSDictionary alloc] initWithContentsOfFile:levelDictPath];
        
        // VARS
        currentRoadIndex1 = 0;
        currentRoadIndex2 = 0;
        
        isJumping = NO;
        score=0;
        gameSpeed = 1.5f;
        [[VariableStore sharedInstance] setGameSpeed:gameSpeed];
        currentRoadTexture = 999;
        //roadSegment1 = [[roadArray objectAtIndex:currentRoadArrayIndex1]intValue]; //
        //roadSegment2 = [[roadArray objectAtIndex:currentRoadIndex2]intValue]; //
        //roadSegment1 = 
        checkCount1 = 0;
        checkCount2 = 0;
        //maxScreens = ([roadArray count] -1);
        maxScreens = ([levelDict count]-1);
        
        // GO
        [self schedule:@selector(update:) interval:1/60];
        [self loadBackground];
        [self loadPlayerSprite];
        //[self schedule:@selector(loadLevelObstacles:) interval:15.0f]; // need level time interval
        //[self schedule:@selector(loadLevelEnemy:) interval:1];
        
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    
    if (!isJumping)
    {
        id jumpUp = [CCScaleTo actionWithDuration:0.75f scale:JUMPING_SCALE];
        id jumpDown = [CCScaleTo actionWithDuration:0.75f scale:DRIVING_SCALE];
        id setJumpingBOOL = [CCCallFunc actionWithTarget:self selector:@selector(setIsJumpingStatus)];
        id seq = [CCSequence actions:setJumpingBOOL, jumpUp, jumpDown, setJumpingBOOL, nil];
        
        [playerSprite runAction:seq];
    }
    
    return YES;
}

- (void) setIsJumpingStatus
{
    
    if (isJumping)
    {
        isJumping = NO;
        [self reorderChild:playerSprite z:1];
        NSLog(@"ON THE ROAD");
    } else {
        isJumping = YES;
        [self reorderChild:playerSprite z:10];
        NSLog(@"JUMPING>>>");
    }
}



#define TOP_UP 1.5
- (void) loadBackground
{

    road1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"1-1.png"]];
	road2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"1-1.png"]];
    
    road1.scaleX = 1.15;
    road2.scaleX = 1.15;
	[road1.texture setAliasTexParameters];
    [road2.texture setAliasTexParameters];
    [road1 setPosition:ccp(screenSize.width/2,(screenSize.height/2))];
    [road2 setPosition:ccp(screenSize.width/2,(screenSize.height*TOP_UP))];

    id move1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width/2, -(screenSize.height/2))];
    id place1 = [CCPlace actionWithPosition:ccp(screenSize.width/2,(screenSize.height/2))];
    id replaceOneCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentOneCheck)];
    id seq1 = [CCSequence actions:move1,place1, replaceOneCheck,nil];
    
    id move2 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width/2, (screenSize.height/2))];
    id place2 = [CCPlace actionWithPosition:ccp(screenSize.width/2,(screenSize.height*TOP_UP))];
    id replaceTwoCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentTwoCheck)];
    id seq2 = [CCSequence actions:move2,place2, replaceTwoCheck, nil];
    
    [road1 runAction:[CCRepeatForever actionWithAction:seq1]];
    [road2 runAction:[CCRepeatForever actionWithAction:seq2]];
    
    [roadLayer addChild:road1 z:-1];
	[roadLayer addChild:road2 z:-1];
    
}


- (void) newRoadSegmentOneCheck
{
    
    ++checkCount1;
    currentRoadTexture = 1;
    
    int numOfLoops = [self getLoopValueForIndex:currentRoadIndex1];

    if (checkCount1 >= numOfLoops)
    {
        checkCount1 = 1;
        
        if (currentRoadIndex1 < maxScreens) // if we're at the end of LevelData, reset the index and start over
        {

            ++currentRoadIndex1;
            //roadSegment1 = [[roadArray objectAtIndex:currentRoadArrayIndex1]intValue];
            //NSArray *tempArray = [levelDict objectForKey:[NSString stringWithFormat:@"%i", currentRoadArrayIndex1]];
            //roadString = [tempArray objectAtIndex:INDEX_ROAD_SEGMENT_ID];
            //[tempArray release];
            
        } else {

            currentRoadIndex1 = 0;
            //roadSegment1 = [[roadArray objectAtIndex:currentRoadArrayIndex1]intValue];
            
        }
        
        NSArray *tempArray = [levelDict objectForKey:[NSString stringWithFormat:@"%i", currentRoadIndex1]];
        NSString *roadString;
        roadString = [tempArray objectAtIndex:INDEX_ROAD_SEGMENT_ID];
        
        
        BOOL hasObstacle = [[tempArray objectAtIndex:INDEX_HAS_OBSTACLE] boolValue];
        if (hasObstacle)
        {
            NSString *obstacleType = [tempArray objectAtIndex:INDEX_LEVEL_TYPE];
            
            [self loadObstacle:obstacleType];
            NSLog(@"HAS OBSTACLE");
        }
        
        //[tempArray release];
        
        //CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i", roadSegment1]]];
        CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:roadString]];
        [road1 setTexture:txt];
        [road1.texture setAliasTexParameters];
        
    }
    
}

- (void) newRoadSegmentTwoCheck
{
    
    ++checkCount2;
    currentRoadTexture = 2;
    
    int numOfLoops = [self getLoopValueForIndex:currentRoadIndex2];

    
    if (checkCount2 >= (numOfLoops -1))
    {
        checkCount2 = 0;
        
        if (currentRoadIndex2 < maxScreens)
        {
            
            ++currentRoadIndex2;
            //roadSegment2 = [[roadArray objectAtIndex:currentRoadIndex2]intValue];
            
        } else {

            currentRoadIndex2 = 0;
            //roadSegment2 = [[roadArray objectAtIndex:currentRoadIndex2]intValue];

        }
        
        NSArray *tempArray = [levelDict objectForKey:[NSString stringWithFormat:@"%i", currentRoadIndex2]];
        NSString *roadString;
        roadString = [tempArray objectAtIndex:INDEX_ROAD_SEGMENT_ID];
        //[tempArray release];
        
        //CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i", roadSegment2]]];
        CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:roadString]];
        [road2 setTexture:txt];
        [road2.texture setAliasTexParameters];
           
    }
    
}

- (int) getLoopValueForIndex:(int) i
{
    //return [[loopsArray objectAtIndex:i]intValue] +1;
    //int loops;
    //loops = [[roadSegmentDict objectForKey:@"loopCount"] intValue];
    //return loops;
    
    NSArray *tempArray = [levelDict objectForKey:[NSString stringWithFormat:@"%i", i]];
    int loops = [[tempArray objectAtIndex:INDEX_NUM_OF_LOOPS]intValue] +1; // add one so we get the same number as in plist
    
    return loops;

}

- (void) loadPlayerSprite
{
    
    playerSprite = [CCSprite spriteWithFile:@"c3.png"];
    playerSprite.scale = DRIVING_SCALE;
    [playerSprite.texture setAliasTexParameters];
    playerSprite.position = ccp(screenSize.width/2, playerSprite.contentSize.height*2);
    [self addChild:playerSprite z:1];
    
    // engine shaking effect
    id actionR = [CCRotateBy actionWithDuration:0.02f angle:1.5];
    id actionL = [CCRotateBy actionWithDuration:0.02f angle:-1.5];
    id seq = [CCRepeatForever actionWithAction:[CCSequence actions: actionR, [actionR reverse], actionL, [actionL reverse], nil]];
    
    //[playerSprite runAction:seq];
    
}

- (void) loadLevelObstacles:(ccTime) t
{
    
    //[self loadTrees];
    
    [self loadBridge];
    /* //ROCK 
     CCSprite *rock = [CCSprite spriteWithFile:@"rock.png"];
     [rock.texture setAliasTexParameters];
     
     [obstacleLayer addChild:rock];
     rock.position = ccp(screenSize.width/4, screenSize.height);
     id actionMove = [CCMoveBy actionWithDuration:gameSpeed*1.25 position:ccp(0, -screenSize.height*1.25)];
     id actionClean = [CCCallFuncND actionWithTarget:rock selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
     id actionSeq = [CCSequence actions:actionMove, actionClean, nil];
     [rock runAction:actionSeq];

    */ //ROCK
    
    /* //WATER 
    CCSprite *water = [CCSprite spriteWithFile:@"water1.png"];
    [water.texture setAliasTexParameters];
     
     [obstacleLayer addChild:water];
     water.position = ccp(screenSize.width/2, screenSize.height);
     id actionMove = [CCMoveBy actionWithDuration:gameSpeed*1.25 position:ccp(0, -screenSize.height*1.25)];
     id actionClean = [CCCallFuncND actionWithTarget:water selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
     id actionSeq = [CCSequence actions:actionMove, actionClean, nil];
     [water runAction:actionSeq];
     */ //WATER
    
    
    /* // OTHER

     CCSprite *water = [CCSprite spriteWithFile:@"water1.png"];
     [water.texture setAliasTexParameters];
     
     if (currentRoadTexture == 1)
     {
         [road1 addChild:water z:1];
         water.position = ccp(screenSize.width/2, screenSize.height);
         
     } else if (currentRoadTexture ==2) {
         
         [road2 addChild:water z:1];
         water.position = ccp(screenSize.width/2, screenSize.height);
         
     }
     
    */ //OTHER
}

- (void) loadObstacle:(NSString *) obs
{
    
    int obsType;
    if (obs == @"water")
    {
        obsType=(arc4random() % 3); // RANDOM 0-2
    } else {
        obsType = 0;
    }
    
    CCSprite *obstacle = [CCSprite spriteWithFile:[NSString stringWithFormat:@"obstacle-%@%i.png", obs, obsType]];
    [obstacle.texture setAliasTexParameters];
    [obstacleLayer addChild:obstacle z:999];
    obstacle.position = ccp(screenSize.width/2, screenSize.height*1.5);
    id actionMove = [CCMoveTo actionWithDuration:gameSpeed*1.5 position:ccp(screenSize.width/2, 0)];
    id actionMoveOff = [CCMoveTo actionWithDuration:gameSpeed*1.5 position:ccp(screenSize.width/2, -screenSize.height*1.5)];
    id actionClean = [CCCallFuncND actionWithTarget:obstacle selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
    id actionSeq = [CCSequence actions:actionMove, actionMoveOff,actionClean, nil];
    [obstacle runAction:actionSeq];
    
}

- (void) loadBridge
{
    
    CCSprite *bridge = [CCSprite spriteWithFile:@"bridge1.png"];
    [bridge.texture setAliasTexParameters];
    
    
    [obstacleLayer addChild:bridge z:999];
    bridge.position = ccp(screenSize.width/2, screenSize.height*1.5);
    id actionMove = [CCMoveTo actionWithDuration:gameSpeed*1.5 position:ccp(screenSize.width/2, 0)];
    id actionMoveOff = [CCMoveTo actionWithDuration:gameSpeed*1.5 position:ccp(screenSize.width/2, -screenSize.height*1.5)];
    id actionClean = [CCCallFuncND actionWithTarget:bridge selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
    id actionSeq = [CCSequence actions:actionMove, actionMoveOff,actionClean, nil];
    [bridge runAction:actionSeq];
     
    
    /*
    //[self unschedule:@selector(loadLevelObstacles:)];
    if (currentRoadTexture == 1)
    {
        [road1 addChild:bridge z:99];
        bridge.position = ccp(screenSize.width/2, 0);
        
    } else if (currentRoadTexture ==2) {
        
        [road2 addChild:bridge z:99];
        bridge.position = ccp(screenSize.width/2, 0);
        
    }
     */
     
}

- (void) loadTrees
{
    // // TREE 
    
    
     CCSprite *tree = [CCSprite spriteWithFile:@"tree.png"];
     [tree.texture setAliasTexParameters];
     tree.position = ccp(screenSize.width/8, screenSize.height*1.25);
     [obstacleLayer addChild:tree];
     
     id actionMove = [CCMoveBy actionWithDuration:gameSpeed*1.25 position:ccp(0, -screenSize.height*1.25)];
     id actionClean = [CCCallFuncND actionWithTarget:tree selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
     id actionSeq = [CCSequence actions:actionMove, actionClean, nil];
     [tree runAction:actionSeq];
     
     CCSprite *tree2 = [CCSprite spriteWithFile:@"tree.png"];
     [tree2.texture setAliasTexParameters];
     tree2.position = ccp(screenSize.width - screenSize.width/8, screenSize.height*1.25);
     [obstacleLayer addChild:tree2];
     
     id actionMove2 = [CCMoveBy actionWithDuration:gameSpeed*1.25 position:ccp(0, -screenSize.height*1.25)];
     id actionClean2 = [CCCallFuncND actionWithTarget:tree2 selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
     id actionSeq2 = [CCSequence actions:actionMove2, actionClean2, nil];
     [tree2 runAction:actionSeq2];
     
    
    /* //OLD
   
    CCSprite *tree = [CCSprite spriteWithFile:@"tree.png"];
    [tree.texture setAliasTexParameters];
    
    CCSprite *tree2 = [CCSprite spriteWithFile:@"tree.png"];
    [tree2.texture setAliasTexParameters];
    
    
    if (currentRoadTexture ==2) {
        
        [road2 addChild:tree z:1];
        tree.position = ccp(screenSize.width/4, screenSize.height/2);
        
        [road2 addChild:tree2 z:99];
        tree2.position = ccp(screenSize.width/4, screenSize.height);
        
    } else {
        [road1 addChild:tree z:1];
        tree.position = ccp(screenSize.width/4, screenSize.height/2);
        
        [road1 addChild:tree2 z:99];
        tree2.position = ccp(screenSize.width/4, screenSize.height);
    }
    */ //TREE
    
}

- (void) loadLevelEnemy:(ccTime) t
{
    
    
    NSString *string;
    if (CCRANDOM_0_1() > 0.5)
    {
        string = @"car";
    } else {
        string = @"bike";
    }
    EnemyVehicle *enemy = [[EnemyVehicle alloc] initWithType:string];
    [self addChild:enemy.sprite z:1];
    //[enemyArray addObject:enemy];
    
        
    bikeSprite = [CCSprite spriteWithFile:@"b1.png"];
    [bikeSprite.texture setAliasTexParameters];
    //bikeSprite.position = ccp(posX, screenSize.height + bikeSprite.contentSize.height);
    [self addChild:bikeSprite z:1];
    id actionMove = [CCMoveTo actionWithDuration:2 position:ccp(bikeSprite.position.x, -bikeSprite.contentSize.height)];
    id actionClean = [CCCallFuncND actionWithTarget:bikeSprite selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
    [bikeSprite runAction:[CCSequence actions:actionMove,actionClean, nil]];
    // LEAKING!!
    //[enemyArray addObject:bikeSprite];
     
}


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

    [self updateScore];
    
    // Keep adding up the playerVelocity to the player's position
    CGPoint pos = playerSprite.position;
    pos.x += playerVelocity.x;
    //pos.y += playerVelocity.y;
    
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
    
        
    if (!isJumping)
    {
        
        // obstacle collision
        for (CCSprite *obstacle in obstacleLayer.children)
        {
            CGPoint worldCoord = [obstacle convertToWorldSpace:self.position];
            CGRect absoluteBox = CGRectMake(worldCoord.x, worldCoord.y, obstacle.contentSize.width, obstacle.contentSize.height);
            
            if (CGRectIntersectsRect(playerSprite.boundingBox, absoluteBox))
            {
                [self stopGame];
                //[playerSprite runAction:[CCMoveBy actionWithDuration:0 position:ccp(50,50)]];
            } 
        }
        
        // roadside collision
        if ((playerSprite.position.x < playerSprite.contentSize.width) || (playerSprite.position.x > screenSize.width - playerSprite.contentSize.width))
        {
            [self stopGame];
        }
            
                
    } else {
        
        // air obstacle collision
    }
    
    // assigning the modified position back
    playerSprite.position = pos;
    
}

- (void) updateScore
{
    score += 1;
    [hudLayer.scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
    
    /*
    if (currentSpeed < 294) {
        currentSpeed = score /25;
    } else {
        
        currentSpeed = 294;
    }
    
    [currentSpeedLabel setString:[NSString stringWithFormat:@"%03i", currentSpeed]];
     */
}

- (void) stopGame
{
    
    CCLayerColor *stopRedLayer = [CCLayerColor layerWithColor: ccc4(255, 0, 0, 80)];
	[self addChild:stopRedLayer z:99 tag:TAG_ROADLAYER];
    
    [self unschedule:@selector(update:)];
    [[CCDirector sharedDirector] pause];
    NSLog(@"STOP GAME!");
    
    CCSprite *retry = [CCSprite spriteWithFile:@"retry.png"];
    [retry.texture setAliasTexParameters];
    CCMenuItemSprite *retryItem = [CCMenuItemSprite itemFromNormalSprite:retry selectedSprite:nil target:self selector:@selector(restart:)];
    CCMenu *menu = [CCMenu menuWithItems:retryItem, nil];
    [self addChild:menu z:1000];
    
    
}

- (void) restart:(id) sender
{
    NSLog(@"made it here");
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[GameLayer node]];

}

- (void) dealloc
{
	[levelDict release];    
    //[roadArray release];
    //[loopsArray release];
    [hudLayer release];
    [super dealloc];
}
@end
