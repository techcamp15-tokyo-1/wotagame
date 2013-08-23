//
//  PlayController.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "PlayController.h"

@implementation PlayController

//初期化子 meがすでに作られていた場合はmeを返す
+(PlayController *) initialize {
	static PlayController *me;
	if (me) return me;
	me = [[self alloc] init];
	return me;
}
-(PlayController *) init {
	[super init];
	_isLoaded = false;
	return self;
}

//タッチされた
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

//現在の拍を経過時間から算出する
-(float) getBeat {
	double time = (double) self.player.currentTime;
	float beat = (float)((time / (60.0 / _bpm)) - _beat_offset);
	return beat;
}

//曲ファイルを読み込む
-(void) loadFile:(NSString *) path_music withScorePath:(NSString *)path_score  {
	//音源読み込む
	[self loadMusic:path_music];
	
	//楽譜データ読み込む
	[self loadWmf:path_score];
	
	_isLoaded = true;
}

//表示すべきノードを判定する
-(NSMutableArray *) getShowNodeList {
	const float DURATION_BEFORE = 0.000f;
	const float DURATION_AFTER = 1.000f;
	float b = [self getBeat];
	return [ActionNode getFutureNodesAtBeat:b andDurationfrom: DURATION_BEFORE to:DURATION_AFTER];
}

//再生する
-(void) playMusic {
	if (!self.isLoaded) NSLog(@"File isn't loaded.");
	[self.player play];
	_score = 0;
}

//停止する
-(void) stopMusic {
	[self.player stop];
	_isLoaded = NO;
}

//一時停止する
-(void) pauseMusic {
	[self.player pause];
	_isLoaded = NO;
}

//再開する
-(void) restartMusic {
	[ActionNode resetNodeIsShowed];
	[self.player playAtTime:self.player.currentTime];
	_isLoaded = NO;
}

//音源データ読み込む
-(void) loadMusic:(NSString *)path {
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error != nil) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    [_player setDelegate:self];
    [_player prepareToPlay];
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

//再生されているか
-(BOOL) isPlaying {
	return _player.isPlaying;
}

//タッチされた際に、ズレを判定する
-(float)getTouchGap:(float)beat ofCellID:(int)cellID {
	const float MAX_GAP = 2.0;
	float gap = MAX_GAP + 1.0;
	ActionNode *node_tapped;
	NSMutableArray *nlist = [ActionNode getFutureNodesAtBeat:beat andDurationfrom: MAX_GAP to:MAX_GAP];
	
	for (ActionNode *node in nlist) {
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

//タッチされた
-(void) onTouchBegan:(float)beat ofCellID:(int)cellID {
	float gap = [self getTouchGap:beat ofCellID:cellID];
	if (gap >= 0.0) {
		_score += (int) 100*(1.0 - gap/2.0);
	}
}

@end

