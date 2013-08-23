//
//  ScoreNode.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	楽譜データモデル

#import "ScoreNode.h"

@interface ScoreNodeModel : NSObject {
}

@property (readonly, assign) NSString *title;	//曲名
@property (readonly) int bpm;	//BPM
@property (readonly, assign) NSString *path;	//曲データのパス

+(void) addNode:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type;
+(NSMutableArray *) getFutureNodesAtBeat:(float)beat andDurationfrom:(float)durationBefore to:(float)durationAfter;

@end
