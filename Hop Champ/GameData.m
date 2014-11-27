//
//  GameData.m
//  Hop Champ
//
//  Created by Yanbo Chen on 11/23/14.
//  Copyright (c) 2014 Knation. All rights reserved.
//

#import "GameData.h"

@interface GameData()
@property NSString *filePath;
@end

@implementation GameData
+(id)data
{
    /*  codes from tutorial */
    GameData *data = [GameData new];//= [[GameData alloc]init]
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName =@"archive.data";
    data.filePath = [path stringByAppendingPathComponent:fileName];
    return data;
    
}
-(void)save
{
    NSNumber *highScoreObject = [NSNumber numberWithInteger:self.highScore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highScoreObject];
    [data writeToFile:self.filePath atomically:YES];
}
-(void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSNumber *highScoreObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highScore = highScoreObject.intValue;
}
@end
