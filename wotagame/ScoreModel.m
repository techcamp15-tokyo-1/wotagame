//
//  ScoreNode.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ScoreNode.h"

@implementation ScoreNode

static NSMutableArray *AllNodeList;	//ノード一覧
static NSString *_title;	//曲名
static NSString *_url;	//ファイルパス
static int bpm;	//bpm

+(void) initialize {
	AllNodeList = [[NSMutableArray alloc] init];
}

//ノードを追加
+(void) addNode:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type {
	ScoreNode *node = [ScoreNode node:value atBeat:beat withType:type];
	[AllNodeList addObject:node];
}

//現在のノードから先を指定した拍分取得する。
+(NSMutableArray *) getFutureNodesAtBeat:(float)beat andDurationfrom:(float)durationBefore to:(float)durationAfter{
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

//楽譜データ読み込む
-(void) loadWmf:(NSString *)path {
	NSString *text;
	NSError *error;
	text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	
	nodeArray = [[NSMutableArray alloc] init];
	
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
				_beat_offset = val.doubleValue;
				NSLog(@"OFFSET = %f", _beat_offset);
			} else if ([key isEqualToString:@"%BPM"]) {
				_bpm = val.intValue;
				NSLog(@"BPM = %d", _bpm);
			}
		} else {
			//ノード
			NSArray *tags = [line componentsSeparatedByString:@" "];
			NSString *beat = tags[0];
			NSString *key = tags[1];
			NSString *value = tags[2];
			
			enum NODETYPE *nodetype;
			if ([key isEqualToString:@"ACTION"]) {
				nodetype = ACTION;
			}
			
			[ActionNode addNode:value atBeat:beat.floatValue withType:nodetype];
		}
	}
}

@end
