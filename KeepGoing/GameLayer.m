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
@synthesize rockSprite;
@synthesize waterSprite;
@synthesize bikeSprite;
//@synthesize _rt;

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

        /*
        // create render texture and make it visible for testing purposes
        _rt = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
        _rt.position = ccp(screenSize.width*0.5f,screenSize.height*0.1f);
        [self addChild:_rt];
        _rt.visible = NO;
        */
        
        isJumping = NO;
        
        [self scheduleUpdate];
        
        //[self loadBg];
        [self loadBackground];
        
        [self loadPlayerSprite];
        
        [self schedule:@selector(loadLevelObstacles:) interval:5];
        [self schedule:@selector(loadLevelWater:) interval:12];
        [self schedule:@selector(loadLevelEnemy:) interval:4];

        roadSegment1 = 1;
        roadSegment2 = 1;
        checkCount1 = 0;
        checkCount2 = 0;
        //[self schedule:@selector(newRoadSegment:) interval:5];

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
                roadSegment1 =3;
                break;
                
            case 3:
                roadSegment1 =4;
                break;
                
            case 4:
                roadSegment1 =1;
                break;
                
            default:
                NSLog(@"NO SEGMENT");
                break;
        }
        /*
        if (roadSegment1 == 1)
        {
            roadSegment1 = 2;
        } else {
            roadSegment1 = 1;
        }
        */
        CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"r%i", roadSegment1]]];
        [l1 setTexture:txt];
        [r1 setTexture:txt];
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
                roadSegment2 =3;
                break;
                
            case 3:
                roadSegment2 =4;
                break;
                
            case 4:
                roadSegment2 =1;
                break;
                
            default:
                NSLog(@"NO SEGMENT");
                break;
        }
        
        /*
        if (roadSegment2 == 1)
        {
            roadSegment2 = 2;
        } else {
            roadSegment2 = 1;
        }
        */
        
        CCTexture2D *txt=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"r%i", roadSegment2]]];
        [l2 setTexture:txt];
        [r2 setTexture:txt];
    }
}

#define TAG_ROADLAYER 111

- (void) loadBackground
{
    gameSpeed = 1.5f;

    CCSprite *road1=[CCSprite spriteWithFile:[NSString stringWithFormat:@"lv1-1.png"]];
	CCSprite *road2=[CCSprite spriteWithFile:[NSString stringWithFormat:@"lv1-1.png"]];
	[road1.texture setAliasTexParameters];
    [road2.texture setAliasTexParameters];
    [road1 setPosition:ccp(screenSize.width/2,(screenSize.height/2))];
    [road2 setPosition:ccp(screenSize.width/2,(screenSize.height*1.49))];

    id move1 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width/2, -(screenSize.height/2))];
    id place1 = [CCPlace actionWithPosition:ccp(screenSize.width/2,(screenSize.height/2))];
    id seq1 = [CCSequence actions:move1,place1, nil];
    
    id move2 = [CCMoveTo actionWithDuration:gameSpeed position:ccp(screenSize.width/2, (screenSize.height/2))];
    id place2 = [CCPlace actionWithPosition:ccp(screenSize.width/2,(screenSize.height*1.49))];
    id seq2 = [CCSequence actions:move2,place2, nil];
    
    [road1 runAction:[CCRepeatForever actionWithAction:seq1]];
    [road2 runAction: [CCRepeatForever actionWithAction:seq2]];
	[self addChild:road1 z:-1];
	[self addChild:road2 z:-1];
    
}

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
    rockSprite = [CCSprite spriteWithFile:@"c0.png"];
    [rockSprite.texture setAliasTexParameters];
    rockSprite.position = ccp(screenSize.width/2, screenSize.height + rockSprite.contentSize.height);
    [rockSprite runAction:[CCTintTo actionWithDuration:0 red:0 green:0 blue:255]];
    [self addChild:rockSprite z:1];
    
    id actionMove = [CCMoveTo actionWithDuration:2 position:ccp(screenSize.width/2, -rockSprite.contentSize.height)];
    //id actionClean = [CCCallFuncND actionWithTarget:rockSprite selector:@selector(removeFromParentAndCleanup:) data:(void*)NO];
    [rockSprite runAction:[CCSequence actions:actionMove, nil]];
    
}

- (void) loadLevelEnemy:(ccTime) t
{
    
    float posX;
    int randy = CCRANDOM_0_1();
    if (randy==1)
    {
        posX = screenSize.width/4;
    } else {
        posX = screenSize.width - (screenSize.width/4);
    }
    
    bikeSprite = [CCSprite spriteWithFile:@"b1.png"];
    [bikeSprite.texture setAliasTexParameters];
    bikeSprite.position = ccp(posX, screenSize.height + bikeSprite.contentSize.height);
    [self addChild:bikeSprite z:1];
    id actionMove = [CCMoveTo actionWithDuration:2 position:ccp(bikeSprite.position.x, -bikeSprite.contentSize.height)];
    [bikeSprite runAction:[CCSequence actions:actionMove,nil]];

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
    
    /* The Player should also be stopped from going outside the screen
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
    */
    
    
    // KEEP THIS
    
    if (!isJumping)
    {
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
        } else if (CGRectIntersectsRect(playerSprite.boundingBox, rockSprite.boundingBox))
        {
            [self stopGame];
        } else if (CGRectIntersectsRect(playerSprite.boundingBox, waterSprite.boundingBox))
        {
            [self stopGame];
        }
    }
    // KEEP THIS
    
    // assigning the modified position back
    playerSprite.position = pos;
    
    //[self checkCollisions];

}

/*
-(void) checkCollisions
{
    // let's make it in a hard way :D
    
    if ([self isCollisionBetweenSpriteA:playerSprite spriteB:roadLeftSprite pixelPerfect:YES])
    {
        NSLog(@"stop game");
        [self stopGame];
        
    } if ([self isCollisionBetweenSpriteA:playerSprite spriteB:roadRightSprite pixelPerfect:YES])
    {
        NSLog(@"stop game");
        [self stopGame];
    }
    
}


-(BOOL) isCollisionBetweenSpriteA:(CCSprite*)spr1 spriteB:(CCSprite*)spr2 pixelPerfect:(BOOL)pp
{
    BOOL isCollision = NO; 
    CGRect intersection = CGRectIntersection([spr1 boundingBox], [spr2 boundingBox]);
    
    // Look for simple bounding box collision
    if (!CGRectIsEmpty(intersection))
    {
        // If we're not checking for pixel perfect collisions, return true
        if (!pp) {return YES;}
        
        // Get intersection info
        unsigned int x = intersection.origin.x;
        unsigned int y = intersection.origin.y;
        unsigned int w = intersection.size.width;
        unsigned int h = intersection.size.height;
        unsigned int numPixels = w * h;
        
        //NSLog(@"\nintersection = (%u,%u,%u,%u), area = %u",x,y,w,h,numPixels);
        
        // Draw into the RenderTexture
        [_rt beginWithClear:0 g:0 b:0 a:0];
        
        // Render both sprites: first one in RED and second one in GREEN
        glColorMask(1, 0, 0, 1);
        [spr1 visit];
        glColorMask(0, 1, 0, 1);
        [spr2 visit];
        glColorMask(1, 1, 1, 1);
        
        // Get color values of intersection area
        ccColor4B *buffer = malloc( sizeof(ccColor4B) * numPixels );
        glReadPixels(x, y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
        
        [_rt end];
        
        // Read buffer
        unsigned int step = 1;
        for(unsigned int i=0; i<numPixels; i+=step)
        {
            ccColor4B color = buffer[i];
            
            if (color.r > 0 && color.g > 0)
            {
                isCollision = YES;
                break;
            }
        }
        
        // Free buffer memory
        free(buffer);
    }
    
    return isCollision;
}
*/

- (void) stopGame
{
    
    CCLayerColor *stopRedLayer = [CCLayerColor layerWithColor: ccc4(255, 0, 0, 80)];
	[self addChild:stopRedLayer z:-1 tag:TAG_ROADLAYER];
    
    [self unschedule:@selector(update:)];
    [[CCDirector sharedDirector] pause];
    NSLog(@"STOP GAME!");
}

- (void) dealloc
{
	
	[super dealloc];
}
@end
