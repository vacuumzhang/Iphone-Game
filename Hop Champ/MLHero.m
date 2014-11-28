//
//  MLHero.m
//  Hop Champ
//
//  Created by Yanbo Chen on 11/20/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import "MLHero.h"
//#import "GameScene.h"
@interface MLHero()
@property BOOL isJumping;
@end
@implementation MLHero

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;

+(id)hero
{
    MLHero *hero = [MLHero spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(20, 20)];
    
    SKSpriteNode *leftEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    leftEye.position = CGPointMake(-2.5, 6.5);
    [hero addChild:leftEye];
    
    SKSpriteNode *rightEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    rightEye.position = CGPointMake(7, 6.5);
    [hero addChild:rightEye];
    
    hero.name = @"hero";
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = ~obstacleCategory | groundCategory;
    //if not affect, use ~
    return hero;
}

/*-(void)walkRight
{
    SKAction *incrementRight = [SKAction moveByX:10 y:0 duration:0];
    [self runAction:incrementRight];
}*/
-(void)jump
{
    if (!self.isJumping) {
        [self.physicsBody applyImpulse:CGVectorMake(0, 10)];
        [self runAction:[SKAction playSoundFileNamed:@"onJump.wav" waitForCompletion:NO]];
        self.isJumping = YES;
    }
    
}
-(void)land
{
    self.isJumping = NO;
}
-(void)start
{
    SKAction *incrementRight = [SKAction moveByX:1.0 y:0 duration:0.006];
    SKAction *moveRight = [SKAction repeatActionForever:incrementRight];
    [self runAction:moveRight];
}

-(void)stop
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 5)];
    [self removeAllActions];
}


@end
