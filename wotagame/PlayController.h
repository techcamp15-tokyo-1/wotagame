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

//----------------------------------------------------------------------------------------
//ユーザーアクションのハンドラ

//スタートボタンがタップされた
-(void)btnStartTapped:(id)sender;

//一時停止ボタンがタップされた
-(void)btnPauseTapped:(id)sender;
//----------------------------------------------------------------------------------------

-(float) getBeat;
-(NSMutableArray *) getShowNodeList;

@end