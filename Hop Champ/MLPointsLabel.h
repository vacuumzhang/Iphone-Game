//
//  MLPointLabel.h
//  Hop Champ
//
//  Created by Yanbo Chen on 11/21/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLPointsLabel : SKLabelNode
@property int number;
+(id)pointsLabelWithFontNamed:(NSString *)fontName;
-(void)increment;
-(void)setPoints:(int)points;
-(void)reset;
@end
