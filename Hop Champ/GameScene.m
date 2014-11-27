//
//  GameScene.m
//  Hop Champ
//
//  Created by Yanbo Chen on 11/20/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import "GameScene.h"
#import "MLHero.h"
#import "MLWorldGenerator.h"
#import "MLPointsLabel.h"
#import "GameData.h"

@interface GameScene()
@property BOOL isStarted;
@property bool isGameOver;
//backgroundmusic

@end

@implementation GameScene
{
    MLHero *hero;
    SKNode *world;
    MLWorldGenerator *generator;
}

static NSString *GAME_FONT = @"AmericanTypewriter-Bold";

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
    
    /* Setup your scene here */
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.physicsWorld.contactDelegate = self;
    
    [self createContent];
    }
    return self;
    
    
}
-(void)createContent
{
    self.backgroundColor =[SKColor colorWithRed:0.54 green:0.7853 blue:1.0 alpha:1.0];
    
    world = [SKNode node];
    [self addChild:world];
    
    generator = [MLWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator generateGround];
    [generator populate];
    
    hero = [MLHero hero];
    [world addChild:hero];
    
    [self loadScoreLabel];
    
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"tap to begin";
    tapToBeginLabel.fontSize = 20.0;
    [self addChild:tapToBeginLabel];
    [self animationWithPulse:tapToBeginLabel];
    
    [self loadClouds];
    
    
    
    
}
-(void)loadScoreLabel
{
    MLPointsLabel * pointsLabel = [MLPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.position = CGPointMake(-150, 70);
    [self addChild:pointsLabel];
    
    GameData *data = [GameData data];
    [data load];
    
    
    MLPointsLabel *highScoreLabel = [MLPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    highScoreLabel.name = @"highScoreLabel";
    highScoreLabel.position = CGPointMake(150, 70);
    [highScoreLabel setPoints:data.highScore];
    [self addChild:highScoreLabel];
    
    SKLabelNode *bestLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    bestLabel.text = @"best";
    bestLabel.fontSize = 16.0;
    bestLabel.position = CGPointMake(-38, 0);
    [highScoreLabel addChild:bestLabel];
    
    [self updateHighScore];

}
-(void)updateHighScore
{
    MLPointsLabel *pointsLabel = (MLPointsLabel *)[self childNodeWithName:@"pointsLabel"];
    MLPointsLabel *highScoreLabel = (MLPointsLabel *)[self childNodeWithName:@"highScoreLabel"];
    
    
    
    if (pointsLabel.number > highScoreLabel.number) {
        [highScoreLabel setPoints:pointsLabel.number];
        
        GameData *data = [GameData data];
        data.highScore = pointsLabel.number;
        [data save];
    }
}

-(void)loadClouds
{
    SKShapeNode *cloud1 = [SKShapeNode node];
    cloud1.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,65,80,40)].CGPath;
    cloud1.fillColor = [UIColor whiteColor];
    cloud1.strokeColor = [UIColor blackColor];
    [self addChild:cloud1];
    
    SKShapeNode *cloud2 = [SKShapeNode node];
    cloud2.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-150,45,80,40)].CGPath;
    cloud2.fillColor = [UIColor whiteColor];
    cloud2.strokeColor = [UIColor blackColor];
    [self addChild:cloud2];
}
-(void)start
{
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    
    //[self runAction:[SKAction playSoundFileNamed:@"testBackground.mp3" waitForCompletion:NO]];
   
    
    [hero start];
    
}
-(void)clear
{
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}
-(void)gameOver
{
    self.isGameOver = YES;
    [hero stop];
    self.physicsWorld.gravity = CGVectorMake(0,0);
    [self runAction:[SKAction playSoundFileNamed:@"onGameOver.mp3" waitForCompletion:NO]];
    
//    SKScene *endGameScene = [[EndGameScene alloc] initWithSize:self.size];
//    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
//    [self.view presentScene:endGameScene transition:reveal];
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.position = CGPointMake(0, 60);
    [self addChild:gameOverLabel];
    
    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetLabel.name = @"tapToResetLabel";
    tapToResetLabel.text = @"tap to reset";
    tapToResetLabel.fontSize = 20.0;
    [self addChild:tapToResetLabel];
    [self animationWithPulse:tapToResetLabel];
    
    [self updateHighScore];
}
-(void)didSimulatePhysics
{
    [self centerOnNode:hero];
    [self handlePoints];
    [self handleGeneration];
    [self handleCleanup];
    
}
-(void)handlePoints
{
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x) {
            MLPointsLabel *pointsLabel = (MLPointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
        if (hero.position.y < node.position.y-200){
            [self gameOver];
        }
    }];
}
-(void)handleGeneration
{
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x) {
            node.name = @"obstacle_cancelled";
            [generator generate];
        }
    }];
}
-(void)handleCleanup
{
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x - self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"obstacle_cancelled" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x - self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    
}


-(void)centerOnNode:(SKNode *)node
{
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x-positionInScene.x, world.position.y-positionInScene.y);
    //world.position.y-positionInScene.y   camera will follow the hero
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if(!self.isStarted){
        [self start];
    }else if(self.isGameOver){
        [self clear];
    }else{
        [hero jump];
    }
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    NSLog(@"hero's (x,y): (%g,%g)",hero.position.x,hero.position.y);
}
-(void)didBeginContact:(SKPhysicsContact *)contact
{
//    if (([contact.bodyA.node.name isEqualToString: @"ground"] && [contact.bodyB.node.name isEqualToString:@"hero"]) || ([contact.bodyB.node.name isEqualToString:@"ground"]&& [contact.bodyA.node.name isEqualToString:@"hero"]))
    if ([contact.bodyA.node.name isEqualToString: @"ground"] || [contact.bodyB.node.name isEqualToString:@"ground"])
    {//$$
        
        [hero land];
        NSLog(@"%g", hero.position.x);//$$
    } else {//$$
        [hero land];
        NSLog(@"hero's x posintion %g", hero.position.x);
//        [self gameOver];
    }
    
    
}

// ** animation section **//
-(void)animationWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.6];
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end
