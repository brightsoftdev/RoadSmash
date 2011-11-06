//
//  HelloWorldLayer.m
//  KeepGoing
//
//  Created by Stephen Ceresia on 11-09-27.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "RoadsideObstacle.h"
#import "EnemyVehicle.h"

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
        
        roadLayer = [CCLayer node];
        [self addChild:roadLayer];
        
        screenSize = [[CCDirector sharedDirector] winSize];
        enemyArray = [[NSMutableArray alloc] init];
        isJumping = NO;
        
        gameSpeed = 1.5f;
        
        [self scheduleUpdate];
        
        //[self loadBg];
        [self loadBackground];
        
        [self loadPlayerSprite];
        
        //[self schedule:@selector(loadLevelObstacles:) interval:5]; // need level time interval
        //[self schedule:@selector(loadLevelWater:) interval:12];
        [self schedule:@selector(loadLevelEnemy:) interval:4];

        
        roadSegment1 = 1;
        roadSegment2 = 1;
        checkCount1 = 0;
        checkCount2 = 0;
        /*
        //[self schedule:@selector(newRoadSegment:) interval:5];
         */
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    
    //id setTxt = [CCCallFunc actionWithTarget:self selector:@selector(changePlayerTexture)];
    //id delayTime = [CCDelayTime actionWithDuration:0.25f];
    
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
	[roadLayer addChild:road1 z:-1];
	[roadLayer addChild:road2 z:-1];
    
}

#define NUM_OF_ROAD_SEGMENT_LOOPS 5

- (void) newRoadSegmentOneCheck
{
    
    ++checkCount1;
    
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

/*
- (void) loadBg
{
    
    CCLayerColor *roadLayer = [CCLayerColor layerWithColor: ccc4(102, 102, 102, 255)];
	[self addChild:roadLayer z:-1 tag:TAG_ROADLAYER];
    
    gameSpeed = 1.5f;
    
    // LEFT SIDE
    l1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"r1.png"]];
	l2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"r1.png"]];
	
	[l1 setPosition:ccp(0,(screenSize.height/2))];
    id leftMove1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(0,-(screenSize.height/2))];
	id leftPlace1 = [CCPlace actionWithPosition:ccp(0,(screenSize.height/2))];
    id replaceOneCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentOneCheck)]; //****** should be here to come from offscreen

	id seqL1 = [CCSequence actions: leftMove1, leftPlace1, replaceOneCheck, nil];
    
    [l2 setPosition:ccp(0,(screenSize.height*1.49))];
	id leftMove2=[CCMoveTo actionWithDuration:gameSpeed position:ccp(0,(screenSize.height/2))];
    id leftPlace2 = [CCPlace actionWithPosition:ccp(0,(screenSize.height*1.49))];
    id replaceTwoCheck = [CCCallFunc actionWithTarget:self selector:@selector(newRoadSegmentTwoCheck)]; //****** should be here to come from offscreen

	id seqL2=[CCSequence actions: leftMove2, leftPlace2, replaceTwoCheck, nil];
	
	[l1 runAction:[CCRepeatForever actionWithAction:seqL1]];
    [l2 runAction: [CCRepeatForever actionWithAction:seqL2]];
	[self addChild:l1 z:1];
	[self addChild:l2 z:1];
    
    // RIGHT SIDE
    r1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"r1.png"]];
	r2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"r1.png"]];
    r1.scaleX *=-1;
    r2.scaleX *=-1;
	
	[r1 setPosition:ccp(screenSize.width,(screenSize.height/2))];
    id rightMove1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width,-(screenSize.height/2))];
	id rightPlace1 = [CCPlace actionWithPosition:ccp(screenSize.width,(screenSize.height/2))];
	id seqR1 = [CCSequence actions: rightMove1, rightPlace1,nil];
    
    [r2 setPosition:ccp(screenSize.width,(screenSize.height*1.49))];
	id rightMove2=[CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width,(screenSize.height/2))];
    id rightPlace2 = [CCPlace actionWithPosition:ccp(screenSize.width,(screenSize.height*1.49))];
	id seqR2=[CCSequence actions: rightMove2, rightPlace2, nil];
	
	[r1 runAction:[CCRepeatForever actionWithAction:seqR1]];
    [r2 runAction: [CCRepeatForever actionWithAction:seqR2]];
	[self addChild:r1 z:1];
	[self addChild:r2 z:1];

}
*/

- (void) loadPlayerSprite
{
    
    playerSprite = [CCSprite spriteWithFile:@"c3.png"];
    [playerSprite.texture setAliasTexParameters];
    playerSprite.position = ccp(screenSize.width/2, playerSprite.contentSize.height*2);
    [self addChild:playerSprite z:1];
    
    id actionR = [CCRotateBy actionWithDuration:0.02f angle:1.5];
    id actionL = [CCRotateBy actionWithDuration:0.02f angle:-1.5];
    id seq = [CCRepeatForever actionWithAction:[CCSequence actions: actionR, [actionR reverse], actionL, [actionL reverse], nil]];
    
    [playerSprite runAction:seq];
    
}

- (void) loadLevelObstacles:(ccTime) t
{
    /*
    rockSprite = [CCSprite spriteWithFile:@"c0.png"];
    [rockSprite.texture setAliasTexParameters];
    rockSprite.position = ccp(screenSize.width/2, screenSize.height + rockSprite.contentSize.height);
    [rockSprite runAction:[CCTintTo actionWithDuration:0 red:0 green:0 blue:255]];
    [self addChild:rockSprite z:1];
    
    
    id actionMove = [CCMoveTo actionWithDuration:2 position:ccp(screenSize.width/2, -rockSprite.contentSize.height)];
    //id actionClean = [CCCallFuncND actionWithTarget:rockSprite selector:@selector(removeFromParentAndCleanup:) data:(void*)NO];
    [rockSprite runAction:[CCSequence actions:actionMove, nil]];
    // LEAKING!!
    [enemyArray addObject:rockSprite];
    */
    
    // TREE 
    RoadsideObstacle *tree = [[RoadsideObstacle alloc] initWithType:@"tree"];
    [roadLayer addChild:tree.sprite z:1];
    [enemyArray addObject:tree];
    
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
    [roadLayer addChild:enemy.sprite z:1];
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
            
            if (obstacle.sprite.position.x > 0)
            {
                
                if (CGRectIntersectsRect(playerSprite.boundingBox, obstacle.sprite.boundingBox))
                {
                    [self stopGame];
                    //[playerSprite runAction:[CCMoveBy actionWithDuration:0 position:ccp(50,50)]];
                } 
                
            } else {
                
                [enemyArray removeObject:obstacle];
                [obstacle release];
                
            }
            
        }
        
    } else {
        
        NSLog(@"array count is %i", [enemyArray count]);
        
    }
    
    // assigning the modified position back
    playerSprite.position = pos;
    
}


- (void) stopGame
{
    
    CCLayerColor *stopRedLayer = [CCLayerColor layerWithColor: ccc4(255, 0, 0, 80)];
	[self addChild:stopRedLayer z:99 tag:TAG_ROADLAYER];
    
    [self unschedule:@selector(update:)];
    [[CCDirector sharedDirector] pause];
    NSLog(@"STOP GAME!");
}

- (void) dealloc
{
    enemyArray = nil;
    [enemyArray release];
	[super dealloc];
}
@end
