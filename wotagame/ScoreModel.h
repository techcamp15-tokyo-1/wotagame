//
//  ScoreNode.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	楽譜データモデル
#import "defines.h"
#import "ScoreNode.h"

typedef struct {
	int bpm;
	float beatOffset;
	NSString *title;
	NSString *path;
} ScoreMeta;

@interface ScoreModel : NSObject {
}

//インスタンスを取得する
+(ScoreModel *) getInstance;

//曲情報を取得する
-(ScoreMeta) getMeta;

//ノードを追加する
-(void) addNode:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type;

//現在のノードから先を指定した拍分取得する。
-(NSMutableArray *) getFutureNodesAtBeat:(float)beat andDurationfrom:(float)durationBefore to:(float)durationAfter;

//楽譜を初期状態（読み込んだ直後の状態）に戻す
-(void) initializeToRestart;

//楽譜を読み込む
-(void) loadScore:(NSString *)path;

@end

