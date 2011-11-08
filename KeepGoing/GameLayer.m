//
//  HelloWorldLayer.m
//  KeepGoing
//
//  Created by Stephen Ceresia on 11-09-27.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "Constants.h"
#import "RoadsideObstacle.h"
#import "EnemyVehicle.h"
#import "VariableStore.h"

// HelloWorldLayer implementation
@implementation GameLayer

@synthesize playerSprite;
@synthesize rockSprite;
@synthesize waterSprite;
@synthesize bikeSprite;
@synthesize enemyArray;

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
        
        hudLayer = [[HUDLayer alloc] init];
        [self addChild: hudLayer z:999 tag:TAG_HUDLAYER];

        roadLayer = [CCLayer node];
        [self addChild:roadLayer];
        
        screenSize = [[CCDirector sharedDirector] winSize];
        enemyArray = [[NSMutableArray alloc] init];
        isJumping = NO;
        score=0;
        
        gameSpeed = 1.5f;
        [[VariableStore sharedInstance] setGameSpeed:gameSpeed];
        
        //[self scheduleUpdate];
        [self schedule:@selector(update:) interval:1/60];
        NSLog(@"here too");
        
        //[self loadBg];
        [self loadBackground];
        
        [self loadPlayerSprite];
        
        [self schedule:@selector(loadLevelObstacles:) interval:0.5f]; // need level time interval
        //[self schedule:@selector(loadLevelWater:) interval:12];
        //[self schedule:@selector(loadLevelEnemy:) interval:1];

        
        currentRoadTexture = 999;
        roadSegment1 = 1;
        roadSegment2 = 1;
        checkCount1 = 0;
        checkCount2 = 0;
        
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
        id jumpUp = [CCScaleTo actionWithDuration:0.75f scale:3.0f];
        id jumpDown = [CCScaleTo actionWithDuration:0.75f scale:1.0f];
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




#define TAG_ROADLAYER 111

- (void) loadBackground
{

    road1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"lv1-1.png"]];
	road2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"lv1-1.png"]];
	[road1.texture setAliasTexParameters];
    [road2.texture setAliasTexParameters];
    [road1 setPosition:ccp(screenSize.width/2,(screenSize.height/2))];
    [road2 setPosition:ccp(screenSize.width/2,(screenSize.height*1.49))];

    id move1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width/2, -(screenSize.height/2))];
    id place1 = [CCPlace actionWithPosition:ccp(screenSize.width/2,(screenSize.height/2))];
    id replaceOneCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentOneCheck)];
    id seq1 = [CCSequence actions:move1,place1, replaceOneCheck,nil];
    
    id move2 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width/2, (screenSize.height/2))];
    id place2 = [CCPlace actionWithPosition:ccp(screenSize.width/2,(screenSize.height*1.49))];
    id replaceTwoCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentTwoCheck)];
    id seq2 = [CCSequence actions:move2,place2, replaceTwoCheck, nil];
    
    [road1 runAction:[CCRepeatForever actionWithAction:seq1]];
    [road2 runAction:[CCRepeatForever actionWithAction:seq2]];
	[self addChild:road1 z:-1];
	[self addChild:road2 z:-1];
    
}

#define NUM_OF_ROAD_SEGMENT_LOOPS 5

- (void) newRoadSegmentOneCheck
{
    
    ++checkCount1;
    currentRoadTexture = 1; // to know which road texture to put obstacle sprites on
    
    if (checkCount1 >= NUM_OF_ROAD_SEGMENT_LOOPS)
    {
        checkCount1 = 1;
        
        switch (roadSegment1) {
            case 1:
                roadSegment1 =2;
                break;
                
            case 2:
                roadSegment1 =1;
                break;
                
            default:
                NSLog(@"NO SEGMENT");
                break;
                
        }
        
        CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"lv1-%i", roadSegment1]]];
        [road1 setTexture:txt];
        [road1.texture setAliasTexParameters];
    }
}

- (void) newRoadSegmentTwoCheck
{
    
    ++checkCount2;
    currentRoadTexture = 2; // to know which road texture to put obstacle sprites on
    
    if (checkCount2 >= (NUM_OF_ROAD_SEGMENT_LOOPS-1))
    {
        checkCount2 = 0;
        
        switch (roadSegment2) {
            case 1:
                roadSegment2 =2;
                break;
                
            case 2:
                roadSegment2 =1;
                break;
                                
            default:
                NSLog(@"NO SEGMENT");
                break;
        }
        
        CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"lv1-%i", roadSegment2]]];
        [road2 setTexture:txt];
        [road2.texture setAliasTexParameters];
    }
}

- (void) loadPlayerSprite
{
    
    playerSprite = [CCSprite spriteWithFile:@"c3.png"];
    [playerSprite.texture setAliasTexParameters];
    playerSprite.position = ccp(screenSize.width/2, playerSprite.contentSize.height*2);
    [self addChild:playerSprite z:1];
    
    // engine shaking effect
    id actionR = [CCRotateBy actionWithDuration:0.02f angle:1.5];
    id actionL = [CCRotateBy actionWithDuration:0.02f angle:-1.5];
    id seq = [CCRepeatForever actionWithAction:[CCSequence actions: actionR, [actionR reverse], actionL, [actionL reverse], nil]];
    
    [playerSprite runAction:seq];
    
}

- (void) loadLevelObstacles:(ccTime) t
{
    // TREE 
    RoadsideObstacle *tree = [[RoadsideObstacle alloc] initWithType:@"tree"];
    
    if (currentRoadTexture == 1)
    {
        [road1 addChild:tree.sprite z:1];
    } else if (currentRoadTexture ==2) {
        [road2 addChild:tree.sprite z:1];
    } else {
        // do nothing
    }
    
    [enemyArray addObject:tree];
    //[tree release];
    
    /* // ROCK 
    RoadsideObstacle *rock = [[RoadsideObstacle alloc] initWithType:@"rock"];
    
    if (currentRoadTexture == 1)
    {
        [road1 addChild:rock.sprite z:1];
    } else if (currentRoadTexture ==2) {
        [road2 addChild:rock.sprite z:1];
    } else {
        // do nothing
    }
    
    [enemyArray addObject:rock];
    */
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
    [enemyArray addObject:enemy];
    
    
    
    /*
    bikeSprite = [CCSprite spriteWithFile:@"b1.png"];
    [bikeSprite.texture setAliasTexParameters];
    bikeSprite.position = ccp(posX, screenSize.height + bikeSprite.contentSize.height);
    [self addChild:bikeSprite z:1];
    id actionMove = [CCMoveTo actionWithDuration:2 position:ccp(bikeSprite.position.x, -bikeSprite.contentSize.height)];
    id actionClean = [CCCallFuncND actionWithTarget:bikeSprite selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
    [bikeSprite runAction:[CCSequence actions:actionMove,actionClean, nil]];
    // LEAKING!!
    [enemyArray addObject:bikeSprite];
     */
}

- (void) loadLevelWater:(ccTime) t
{
    waterSprite = [CCSprite spriteWithFile:@"water1.png"];
    [waterSprite.texture setAliasTexParameters];
    waterSprite.position = ccp(screenSize.width/2, screenSize.height + waterSprite.contentSize.height);
    [self addChild:waterSprite z:1];
    
    id actionMove = [CCMoveTo actionWithDuration:2 position:ccp(screenSize.width/2, -waterSprite.contentSize.height)];
    //id actionClean = [CCCallFuncND actionWithTarget:rockSprite selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
    [waterSprite runAction:[CCSequence actions:actionMove,nil]];
    // LEAKING!!

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

    [self updateScore];
    
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
    
        
    if (!isJumping)
    {
        
        for (RoadsideObstacle *obstacle in enemyArray)
        {
            //obstacle.sprite.anchorPoint = ccp(0,0);
            //CGRect absoluteBox = CGRectMake(obstacle.sprite.position.x, obstacle.sprite.position.y, [obstacle.sprite boundingBox].size.width, [obstacle.sprite boundingBox].size.height);
            
            if (CGRectIntersectsRect(playerSprite.boundingBox, obstacle.sprite.boundingBox))
            {
                [self stopGame];
                //[playerSprite runAction:[CCMoveBy actionWithDuration:0 position:ccp(50,50)]];
            } 
            
            
        }
        
    } else {
        
        NSLog(@"array count is %i", [enemyArray count]);
        
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
    enemyArray = nil;
    [enemyArray release];
	[super dealloc];
}
@end
