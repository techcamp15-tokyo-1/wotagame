//
//  ScoreModel.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel

static ScoreMeta meta;	//曲情報
static NSMutableArray *AllNodeList;	//ノード一覧

//インスタンスを取得する
+(ScoreModel *) getInstance {
	static ScoreModel *instance;
	if (!instance) {
		instance = [[ScoreModel alloc] init];
	}
	return instance;
}

//曲情報を取得する
-(ScoreMeta) getMeta {
	return meta;
}

//ノードを追加する
-(void) addNode:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type {
	ScoreNode *node = [ScoreNode node:value atBeat:beat withType:type];
	[AllNodeList addObject:node];
}

//現在のノードから先を指定した拍分取得する。
-(NSMutableArray *) getFutureNodesAtBeat:(float)beat andDurationfrom:(float)durationBefore to:(float)durationAfter{
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	ScoreNode *node;
	
	for (int i = 0; i < [AllNodeList count]; i++) {
		node = AllNodeList[i];
		if (!node) continue;
		if (node.beat - beat > durationAfter) return arr;
		if (beat - node.beat < durationBefore) {
			[arr addObject:node];
		}
	}
	return arr;
}

//楽譜を初期状態（読み込んだ直後の状態）に戻す
-(void) initializeToRestart {
	for(ScoreNode *node in AllNodeList) {
		node.isShowed = NO;
	}
}

//楽譜を読み込む
-(void) loadScore:(NSString *)path {
	NSString *text;
	NSError *error;
	text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	
	AllNodeList = [[NSMutableArray alloc] init];
	
	NSArray *lines = [text componentsSeparatedByString:@"\n"];
	NSString *line;
	NSString *type;
	
	for (line in lines) {
		if (line.length == 0) continue;
		type = [line substringToIndex:1];
		
		if ([type isEqualToString:@"#"]) {
			//コメント情報
			//何も処理はしない
		} else if ([type isEqualToString:@"%"]) {
			//メタ情報
			NSArray *tags = [line componentsSeparatedByString:@" "];
			NSString *key = tags[0];
			NSString *val = tags[1];
			
			if ([key isEqualToString:@"%OFFSET"]) {
				meta.beatOffset = val.floatValue;
			} else if ([key isEqualToString:@"%BPM"]) {
				meta.bpm = val.intValue;
			}
		} else {
			//ノード
			NSArray *tags = [line componentsSeparatedByString:@" "];
			float beat = ((NSString *)tags[0]).floatValue;
			NSString *key = tags[1];
			NSString *value = tags[2];
			
			enum NODETYPE *nodetype;
			if ([key isEqualToString:@"TAP"]) {
				nodetype = TAP;
			}
			
			[self addNode:value atBeat:beat withType:nodetype];
		}
	}
}

@end
