//
//  ScoreNode.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	楽譜のアクションノードモデル
#import "defines.h"

@interface ScoreNode : NSObject {
}

@property float beat;
@property int cellId;
@property enum NODETYPE type;
@property (strong) NSString *value;

+(ScoreNode *) node:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type;
+(ScoreNode *) node:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value;

@end