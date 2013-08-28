//
//  PlayController.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	Scene:Playの管理を行う

#import "defines.h"
#import "cocos2d.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "ScoreModel.h"
#import "ResultLayer.h"
#import "MusicSelectLayer.h"

@class PlayLayer;

@interface PlayController : NSObject<
	AVAudioPlayerDelegate,
	AVAudioSessionDelegate,
	CCTouchOneByOneDelegate
> {
}

@property (retain) PlayLayer *playLayer;
@property (readonly) ScoreMeta scoreMeta;

@property (readonly) bool isPause;
@property (readonly) bool isGameStarted;

@property (readonly) int score;

//初期化
+(PlayController *) getInstance;
-(void) initialize;

//更新
-(void) update;

//----------------------------------------------------------------------------------------
//ユーザーアクションのハンドラ

//スタートボタンがタップされた
-(void)btnStartTapped:(id)sender;

//一時停止ボタンがタップされた
-(void)btnPauseTapped:(id)sender;

//メニューへ戻るボタンがタップされた
-(void)btnBackToMenuTapped:(id)sender;

//やり直すボタンがタップされた
-(void)btnRestartTapped:(id)sender;

//----------------------------------------------------------------------------------------
//ゲッター

-(float) getBeat;
-(ScoreMeta) getMeta;
-(float) getCellState:(int)cellID;

//----------------------------------------------------------------------------------------
//状態変更
-(void) stop;
@end
