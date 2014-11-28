//
//  MLWorldGenerator.m
//  Hop Champ
//
//  Created by Yanbo Chen on 11/20/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import "MLWorldGenerator.h"

@interface MLWorldGenerator()
@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;
@end

@implementation MLWorldGenerator

static const uint32_t obstacleCategory = 0x1 << 0;
static const uint32_t groundCategory = 0x1 << 2;

+(id)generatorWithWorld:(SKNode *)world
{
    MLWorldGenerator *generator =[MLWorldGenerator node];
    generator.currentGroundX =0;
    generator.currentObstacleX =400;
    generator.world = world;
    
    return generator;
}
-(void)populate
{
    for(int i=0;i<3;i++)
  [self generate];
}
-(void)gameGround
{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    //spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(self.scene.frame.size.width, 100)
    ground.name = @"ground";
    ground.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/5 + ground.frame.size.height/5);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.categoryBitMask =groundCategory;
    ground.physicsBody.dynamic = NO;
    [self.world addChild:ground];
    self.currentGroundX += ground.frame.size.width;
}
-(void)generate
{
    
    
    
    
    SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(70, 10)];
    
    obstacle.name = @"obstacle";
    obstacle.position = CGPointMake(self.currentObstacleX, arc4random()%80);// + obstacle.frame.size.height/2
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacle.size];
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    obstacle.physicsBody.dynamic = NO;
    [self.world addChild:obstacle];
    
    self.currentObstacleX += 150;
    
}
-(UIColor *)getRandomColor
{
    int rand = arc4random() %6;
    UIColor *color;
    switch (rand) {
            
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor orangeColor];
            break;
        case 2:
            color = [UIColor yellowColor];
            break;
        case 3:
            color = [UIColor greenColor];
            break;
        case 4:
            color = [UIColor blueColor];
            break;
        case 5:
            color = [UIColor purpleColor];
            break;
        default:
            break;
    }
    return color;
}
@end
