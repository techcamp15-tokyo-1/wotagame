//
//  PlayController.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	Scene:Playの管理を行う

#import "cocos2d.h"
#import <AVFoundation/AVFoundation.h>
#import "ScoreModel.h"
@class PlayLayer;

@interface PlayController : NSObject<
	AVAudioPlayerDelegate,
	CCTouchOneByOneDelegate
> {
}

@property (retain) PlayLayer *playLayer;
@property (readonly) bool isPlaying;
@property (readonly) bool isLoaded;
@property (readonly) int score;

//初期化
+(PlayController *) getInstance;

//スタートボタンがタップされた
-(void)btnStartTapped:(id)sender;

//一時停止ボタンがタップされた
-(void)btnPauseTapped:(id)sender;

//ゲームをスタートするための準備を行う
-(void) initializeToStart;

//ゲームをスタートする
-(void) start;

//ゲームを中止する
-(void) stop;

//一時停止する
-(void) pause;

//最初からやりなおす
-(void) restart;

-(float) getBeat;
-(NSMutableArray *) getShowNodeList;

@end