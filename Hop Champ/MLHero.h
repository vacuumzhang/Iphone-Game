//
//  MLHero.h
//  Hop Champ
//
//  Created by Yanbo Chen on 11/20/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLHero : SKSpriteNode
+(id)hero;
//-(void)walkRight;
-(void)jump;
-(void)land;
-(void)start;
-(void)stop;
//-(void)heroDie;
@end
