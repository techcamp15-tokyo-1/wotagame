//
//  ScoreModel.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	楽譜データモデル
#import "defines.h"
#import "ScoreNode.h"

@interface ScoreModel : NSObject {
}

//インスタンスを取得する
+(ScoreModel *) getInstance;

//曲情報を取得する
-(ScoreMeta) getMeta;

//ノードを追加する
-(void) addNode:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type;
-(void) addNode:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value;

//ノードを削除する
-(void) deleteNode:(int)cellID;

//各セルが次に行うアクションノードを返す
-(ScoreNode *) getNextNodes:(int)cellID atBeat:(float)beat_now;

//楽譜を読み込む
-(BOOL) loadScore:(NSString *)path;

//METAを変更
-(void) setBpm:(int)value fromBeat:(float)fromBeat;
-(void) setNodeDuration:(float)value;

@end
