//
//  ScoreModel.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//ノードは2次元配列で管理
//	AllNodeList[x][y] = cellID:x の y番目 のノード

#import "ScoreModel.h"

@implementation ScoreModel

static ScoreMeta meta;	//曲情報
static NSMutableArray *AllNodeList;	//ノード一覧
static NSMutableArray *nodeList_forScore;	//採点用ノード

//インスタンスを取得する
+(ScoreModel *) getInstance {
	static ScoreModel *instance;
	if (!instance) instance = [[ScoreModel alloc] init];
	return instance;
}

//曲情報を取得する
-(ScoreMeta) getMeta {
	return meta;
}

//BPMを変更する
-(void) setBpm:(int)value fromBeat:(float)fromBeat {
	meta.beatOffset = fromBeat - (fromBeat - meta.beatOffset) * value / meta.bpm;
	meta.bpm = value;
}

//ノード間隔を変更する
-(void) setNodeDuration:(float)value {
	meta.nodeDuration = value;
}

//ノードを追加する
-(void) addNode:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type {
	ScoreNode *node = [ScoreNode node:cellId atBeat:beat withType:type];
	[AllNodeList[cellId] addObject:node];
}
-(void) addNode:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value {
	ScoreNode *node = [ScoreNode node:cellId atBeat:beat withType:type andValue:value];
	[AllNodeList[cellId] addObject:node];
}

//ノードを削除する
-(void) deleteNode:(int)cellID {
	NSMutableArray *array = AllNodeList[cellID];
	[array removeObjectAtIndex:0];
}

//セルが次に行うアクションノードを返す
-(ScoreNode *) getNextNodes:(int)cellID atBeat:(float)beat_now {
	NSMutableArray *array = AllNodeList[cellID];
#ifdef ISDEBUG
	NSLog(@"A_count = %d", [array count]);
#endif
	if ([array count] == 0) return nil;

	//過去のノードが残っている -> タップし忘れた・ミス
	ScoreNode *node;
	if (((ScoreNode *)array[0]).beat <= beat_now - GAP_OFFSET) {
		[array removeObjectAtIndex:0];
		node = [ScoreNode node:cellID atBeat:beat_now withType:NODETYPE_MISS];
	} else {
		node = array[0];
		nodeList_forScore[cellID] = array[0];
	}
	
	return node;
}

//楽譜を読み込む
-(BOOL) loadScore:(NSString *)scoreName {
	NSString *text;

	LOG(@"DEBUG ONLY");
	NSString *scorePath = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"wscore"];
	//NSString *scorePath = [NSString stringWithFormat:@"%@/scores/%@/%@", NSHomeDirectory(), scoreName, FILENAME_SCORE];
	
	text = [NSString stringWithContentsOfFile:scorePath encoding:NSUTF8StringEncoding error:nil];

	meta.scorePath = [scorePath retain];
	meta.nodeDuration = 0.75f;
	
	//配列初期化
	ScoreNode *nodeDummy = [ScoreNode node:0 atBeat:-999.99 withType:NODETYPE_DUMMY];
	AllNodeList = [[NSMutableArray alloc] init];
	nodeList_forScore = [[NSMutableArray alloc] init];
	for (int i = 0; i<=CELLID_METACELL; i++) {
		NSMutableArray *array = [NSMutableArray array];
		[AllNodeList addObject:array];
		[nodeList_forScore addObject:nodeDummy];
	}
	
	//一行ずつ読み込み
	NSArray *lines = [text componentsSeparatedByString:@"\n"];
	for (NSString *line in lines) {
		switch ([line characterAtIndex:0]) {
			case CHARACODE_TYPE_COMMENT:	//コメント情報
				break;
				
			case CHARACODE_TYPE_META:	//メタ情報
				[self loadMetaFromLine:line];
				break;
				
			default: //ノード
				[self loadNodeFromLine:line];
				break;
		}
	}
	return YES;
}

-(void) loadMetaFromLine:(NSString *)line {
	NSArray *tags = [line componentsSeparatedByString:@" "];
	NSString *key = tags[0];
	NSString *val = tags[1];
	
	if ([key isEqualToString:@"%OFFSET"]) {
		meta.beatOffset = val.floatValue;
		return;
	}
	if ([key isEqualToString:@"%BPM"]) {
		meta.bpm = val.intValue;
		return;
	}
	if ([key isEqualToString:@"%TITLE"]) {
		meta.title = [val retain];
		return;
	}
	if ([key isEqualToString:@"%ARTIST"]) {
		meta.artist = [val retain];
		return;
	}
	if ([key isEqualToString:@"%DIFFICULTY"]) {
		meta.difficulty = val.intValue;
		return;
	}
	if ([key isEqualToString:@"%NODEDURATION"]) {
		meta.nodeDuration = val.floatValue;
		return;
	}
	if ([key isEqualToString:@"%MUSIC"]) {
		
		LOG(@"DEBUG ONLY");
		NSArray *val_str = [val componentsSeparatedByString:@"."];
		meta.musicPath = [[[NSBundle mainBundle] pathForResource:val_str[0] ofType:val_str[1]] retain];
		//meta.musicPath = [[NSString stringWithFormat:@"%@/scores/%@/%@", NSHomeDirectory(), scoreName, val] retain];
		
		LOG(meta.musicPath);
		return;
	}
	if ([key isEqualToString:@"%BACKGROUND"]) {
		
		LOG(@"DEBUG ONLY");
		NSArray *val_str = [val componentsSeparatedByString:@"."];
		meta.backgroundPath = [[[NSBundle mainBundle] pathForResource:val_str[0] ofType:val_str[1]] retain];
		//meta.backgroundPath = [[NSString stringWithFormat:@"%@/scores/%@/%@", NSHomeDirectory(), scoreName, val] retain];
		
		LOG(meta.backgroundPath);
		return;
	}
}

-(void) loadNodeFromLine:(NSString *)line {
	NSArray *tags = [line componentsSeparatedByString:@" "];
	float beat = ((NSString *)tags[0]).floatValue;
	NSString *key = tags[1];
	int cellId;
	
	enum NODETYPE *nodetype;
	if ([key isEqualToString:@"TAP"]) {
		nodetype = NODETYPE_TAP;
		cellId = ((NSString *)tags[2]).intValue;
		[self addNode:cellId atBeat:beat withType:nodetype];
		
	} else if ([key isEqualToString:@"BPM"]) {
		nodetype = NODETYPE_BPM;
		cellId = CELLID_METACELL;
		[self addNode:cellId atBeat:beat withType:nodetype andValue:tags[2]];
			
	} else if ([key isEqualToString:@"SPARK"]) {
		nodetype = NODETYPE_SPARK;
		cellId = CELLID_METACELL;
		[self addNode:cellId atBeat:beat withType:nodetype andValue:tags[2]];

	} else if ([key isEqualToString:@"BACKGROUND"]) {
		nodetype = NODETYPE_BACKGROUND;
		cellId = CELLID_METACELL;
		[self addNode:cellId atBeat:beat withType:nodetype andValue:tags[2]];
		
	} else if ([key isEqualToString:@"NODEDURATION"]) {
		nodetype = NODETYPE_NODEDURATION;
		cellId = CELLID_METACELL;
		[self addNode:cellId atBeat:beat withType:nodetype andValue:tags[2]];
		
	} else if ([key isEqualToString:@"END"]) {
		nodetype = NODETYPE_END;
		cellId = CELLID_METACELL;
		[self addNode:cellId atBeat:beat withType:nodetype andValue:tags[2]];
		
	}
	
}

@end
