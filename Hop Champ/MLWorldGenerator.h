//
//  MLWorldGenerator.h
//  Hop Champ
//
//  Created by Yanbo Chen on 11/20/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLWorldGenerator : SKNode
+(id)generatorWithWorld:(SKNode *)world;
-(void)populate;
-(void)generate;
-(void)generateGround;

@end
