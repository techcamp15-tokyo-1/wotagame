//
//  PlayController.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "PlayController.h"
#import "PlayLayer.h"

@implementation PlayController

NSString *FILE_NAME = @"bgm2";
NSString *FILE_EXT_MUSIC = @"m4a";
NSString *FILE_EXT_SCORE = @"wmf";

AVAudioPlayer *player;
ScoreModel *scoreModel;
ScoreMeta scoreMeta;

//コンストラクタ
+(PlayController *) getInstance {
	static PlayController *instance;
	if (!instance) {
		instance = [[PlayController alloc] init];
		[instance initialize];
		scoreModel = [ScoreModel getInstance];
	}
	
	return instance;
}
-(void) initialize {
	_isLoaded = NO;
	LOG(@"HELLO");
}

//----------------------------------------------------------------------------------------
//ユーザーアクションのハンドラ

//タッチの基本メソッド　ボタンなどは個別のメソッドを使用
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	NSLog(@"!");
//	float gap = [self getTouchGap:[self getBeat] ofCellID:cellID];
//	if (gap >= 0.0) {
//		_score += (int) 100*(1.0 - gap/2.0);
//	}
    return YES;
}

//スタートボタンがタップされた
-(void) btnStartTapped:(id)sender {
	[self prepareStart];
	[self start];
}

//一時停止ボタンがタップされた
-(void) btnPauseTapped:(id)sender {
	if (!self.isPlaying) return;
	[self pause];
}

//----------------------------------------------------------------------------------------

//現在のbeatを経過時間から算出する
-(float) getBeat {
	double time = (double) player.currentTime;
	float beat = (float)((time / (60.0 / scoreMeta.bpm)) - scoreMeta.beatOffset);
	return beat;
}

//表示すべきノードを判定する
-(NSMutableArray *) getShowNodeList {
	const float DURATION_BEFORE = 0.000f;
	const float DURATION_AFTER = 1.000f;
	float b = [self getBeat];
	return [scoreModel getFutureNodesAtBeat:b andDurationfrom: DURATION_BEFORE to:DURATION_AFTER];
}

//ゲームをスタートするための準備を行う
-(void) prepareStart {
	//ScoreMetaの更新
	scoreMeta = [scoreModel getMeta];
	
	//音源読み込む
	NSString *path_music = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:FILE_EXT_MUSIC];
	[self loadMusic:path_music];
	
	//楽譜データ読み込む
	NSString *path_score = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:FILE_EXT_SCORE];
	[scoreModel loadScore:path_score];
	
	_isLoaded = YES;
	
	[self.playLayer prepareStart:[scoreModel getMeta]];
	[self start];
}

//ゲームをスタートする
-(void) start {
	_score = 0;
	[player play];
}

//ゲームを中止する
-(void) stop {
	[player stop];
	_isLoaded = NO;
}

//一時停止する
-(void) pause {
	[player pause];
	[self.playLayer pause];
}

//最初からやりなおす
-(void) restart {
	[scoreModel initializeToRestart];
	[self start];
}

//音源データ読み込む
-(void) loadMusic:(NSString *)path {
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error != nil) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
	
    [player setDelegate:self];
    [player prepareToPlay];
}

//再生されているか
-(bool) isPlaying {
	return player.isPlaying;
}

//タッチされた際に、ズレを判定する
-(float)getTouchGap:(float)beat ofCellID:(int)cellID {
	const float MAX_GAP = 2.0;
	float gap = MAX_GAP + 1.0;
	ScoreNode *node_tapped;
	NSMutableArray *nlist = [scoreModel getFutureNodesAtBeat:beat andDurationfrom: MAX_GAP to:MAX_GAP];
	
	for (ScoreNode *node in nlist) {
		NSArray *tags = [node.value componentsSeparatedByString:@","];
		NSString *cell_id_str = tags[0];
		int cell_id = cell_id_str.intValue;
		if (cell_id == cellID) {
			if (node.beat > beat) {
				if (node.beat - beat < gap) {
					gap = node.beat - beat;
					node_tapped = node;
				}
			} else {
				if (beat - node.beat < gap) {
					gap =beat - node.beat;
					node_tapped = node;
				}
			}
		}
	}
	
	if (gap > MAX_GAP) {
		return -1.0;
	}
	return gap;
}

@end

