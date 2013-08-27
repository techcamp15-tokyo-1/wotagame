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

AVAudioPlayer *player;
AVAudioPlayer *playerSE;
ScoreModel *scoreModel;

//コンストラクタ
+(PlayController *) getInstance {
	static PlayController *instance;
	if (!instance) {
		instance = [[PlayController alloc] init];
		[instance initialize];
	}
	return instance;
}
-(void) initialize {
	AVAudioSession *audioSession = [AVAudioSession sharedInstance]; [audioSession setDelegate:self];
	[audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
	[audioSession setActive:YES error:nil];
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"];
	NSURL *file = [[[NSURL alloc] initFileURLWithPath:soundPath] autorelease];
	playerSE = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
	[playerSE setDelegate:self];
	[playerSE prepareToPlay];
	
	scoreModel = [ScoreModel getInstance];
	[scoreModel loadScore:FILE_NAME];
	
	_isGameStarted = NO;
	_isPause = NO;
	_score = 0;
	
	[self loadMusic];
}

//音源データ読み込む
-(void) loadMusic {
    NSError *error = nil;
    NSURL *url = [NSURL fileURLWithPath:self.scoreMeta.musicPath];
	
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) LOG(@"読み込みエラー");
	
    [player setDelegate:self];
    [player prepareToPlay];
}

//----------------------------------------------------------------------------------------
//更新処理
-(void) update {
	if (self.isPause) return;
	
	//ラベルの更新
	[self.playLayer updateScoreLabel];
	
	//セル画像の更新
	for(int cellId = 0; cellId <= 8; cellId++) {
		[self.playLayer updateResultCell:cellId];
		[self.playLayer updateTapCell:cellId atValueOf:[self getCellState:cellId]];
	}
	
	//メタ情報の更新
	float beat_now = [self getBeat];
	ScoreNode *node;
	do {
		node = [scoreModel getNextNodes:CELLID_METACELL atBeat:beat_now];
		if (node.beat <= beat_now) {
			switch (node.type) {
				case NODETYPE_BPM:
					[scoreModel setBpm:node.value.intValue fromBeat:beat_now];
					break;
					
				case NODETYPE_BACKGROUND:
					LOG(@"背景変更 is 未実装 まだ");
					break;
					
				case NODETYPE_SPARK:
					[self.playLayer setEffectParticle:node.value.intValue];
					break;
					
				case NODETYPE_NODEDURATION:
					[scoreModel setNodeDuration: node.value.floatValue];
					break;
					
				case NODETYPE_END:
					[self finish];
					break;
					
				default:
					break;
			}
			[scoreModel deleteNode:CELLID_METACELL];
		}
	} while (node.beat <= beat_now);
}

//----------------------------------------------------------------------------------------
//ユーザーアクションのハンドラ

//タッチの基本メソッド　ボタンなどは個別のメソッドを使用
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	
	if (!self.isGameStarted) return YES;
	
	if (self.isPause) {
		[self pause];
		return YES;
	}
	
	int cellID = [self.playLayer pursueTappedCell:touch withEvent:event];
	float gap = [self getTouchGap:[self getBeat] ofCellID:cellID];
	if (gap < 0.0) return NO;
	
#ifdef ISDEBUG
	NSLog(@"%f", gap);
#endif
	
	[scoreModel deleteNode:cellID];
	
	enum RESULT result;
	if (gap < BORDERLINE_PERFECT) {
		result = RESULT_PERFECT;
		_score += 1000;
	} else if (gap < BORDERLINE_GREAT) {
		result = RESULT_GREAT;
		_score += 100;
	} else if (gap < BORDERLINE_GOOD) {
		result = RESULT_GOOD;
		_score += 50;
	} else if (gap < BORDERLINE_OK) {
		result = RESULT_OK;
		_score += 10;
	} else {
		result = RESULT_MISS;
	}
	[self.playLayer setSuccesEffect:cellID result:result];
	
	return YES;
}

//スタートボタンがタップされた
-(void) btnStartTapped:(id)sender {
	[self start];
}

//一時停止ボタンがタップされた
-(void) btnPauseTapped:(id)sender {
	[self pause];
}

//メニューへ戻るボタンがタップされた
-(void)btnBackToMenuTapped:(id)sender {
	exit(1);
}

//やり直すボタンがタップされた
-(void)btnRestartTapped:(id)sender {
	[player stop];
	[self.playLayer initialize];
	[self initialize];
}
//----------------------------------------------------------------------------------------

//現在のbeatを経過時間から算出する
-(float) getBeat {
	double time = (double) player.currentTime;
	float beat = (float)((time * self.scoreMeta.bpm / 60) - self.scoreMeta.beatOffset);
	return beat;
}

//メタ情報を取得する
-(ScoreMeta) getMeta {
	return [scoreModel getMeta];
}

//	指定されたセルの状況を取得する ex)戻り値 = 0.5　->　セルのゲージには50%の表示がなされている
-(float) getCellState:(int)cellID {
	
	float beat_now = [self getBeat];
	ScoreNode *node = [scoreModel getNextNodes:cellID atBeat:beat_now];
	if (!node) return 0;
	float val;
	switch (node.type) {
		case NODETYPE_MISS:
			[self.playLayer setMissEffect:cellID];
			return 0;
			break;
			
		case NODETYPE_TAP:
			val = min(0.99, 1.0f - (node.beat - beat_now)/self.scoreMeta.nodeDuration);
			break;
			
		default:
			break;
	}
	
	return val < 0 ? 0 : val;
}

//----------------------------------------------------------------------------------------

//ゲームをスタートする
-(void) start {
	[self.playLayer prepareStart];
	_score = 0;

	[player play];
	_isGameStarted = YES;
}

//ゲームを中止する
-(void) stop {
	[player stop];
	_isGameStarted = NO;
}

//一時停止する
-(void) pause {
	self.isPause ? [player play] : [player pause];
	_isPause = !self.isPause;
	[self.playLayer pause];
}

//ゲーム終了し、結果画面へいく
-(void) finish {
	player.volume *= 0.6;
	CCScene *scene = [ResultLayer scene];
	id transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:scene];
	[[CCDirector sharedDirector] replaceScene:transition];
}

//タッチされた際に、ズレを判定する
-(float)getTouchGap:(float)beat ofCellID:(int)cellID {
	ScoreNode *node = [scoreModel getNextNodes:cellID atBeat:beat];
	float gap = node.beat - beat;
	if (gap < 0) gap = -gap;
	if (gap > BORDERLINE_OK) gap = -1.0;
	return gap;
}

-(ScoreMeta) scoreMeta {
	return [scoreModel getMeta];
}
@end

