//
//  GameData.h
//  Hop Champ
//
//  Created by Yanbo Chen on 11/23/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
@property int highScore;
+(id)data;
-(void)save;
-(void)load;

@end
