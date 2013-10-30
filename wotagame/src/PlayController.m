//
//  PlayController.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/26.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "PlayController.h"

@implementation PlayController

+(id) initWithScene: (PlayScene*)s{
	PlayController* instance = [[self alloc] init:s];
	return instance;
}

-(id) init:(PlayScene*)s {
	[super init];
	self.scene = s;
	_state = GAMESTATE_BEFORE_PLAY;
	return self;
}

/*----------------------------------------------------------------------------
 Update
 ----------------------------------------------------------------------------*/

-(void) update:(ccTime)dt {
	float now = [self getBeat];
	float duration = self.score.nodeDuration;
	NSArray *nodes = [self.score getNodesFromBeat:now-BORDERLINE_OK-0.5f toBeat:now+duration];
	
	//reset cell state
	for (int channelId = 0; channelId < 9; channelId++) {
		[self.scene updateCell:channelId andValue:0.0f];
		[self.scene updateResultLabel:channelId andBeat:now];
	}
	
	//process each node
	float value;
	for (ScoreNode *node in nodes) {
		switch (node.type) {
			case NODETYPE_TAP:
				if (now - node.beat > BORDERLINE_OK) {
					[self tapCell:node.value.intValue];
				} else {
					value = 1.0f - (node.beat - now) / duration;
					[self.scene updateCell:node.value.intValue andValue:value];
				}
				break;
				
			case NODETYPE_SPARK:
				if (node.beat < now) {
					[self.scene setSpark:node.value.intValue];
					node.valid = NO;
				}
				break;
			
			case NODETYPE_ACTION:
				if (node.beat < now) {
					_actionId  = node.value.intValue;
					node.valid = NO;
				}
				break;
				
			case NODETYPE_END:
				if (node.beat < now) {
					if (self.combo > self.resultMaxCombo) _resultMaxCombo = self.combo;
					_state = GAMESTATE_FINISHED;
					[self.scene showLayerResult:YES];
					node.valid = NO;
				}
				break;
				
			default:
				break;
		}
	}
	
	//Update SMAction
	[self.scene updateSMAction:self.actionId];	//実際には適切なアクションをスコアから読み出す
}

/*----------------------------------------------------------------------------
 Event Listeners
 ----------------------------------------------------------------------------*/

-(void) tapCell:(int)cellId {
	float now = [self getBeat];
	float duration = self.score.nodeDuration;
	NSArray *nodes = [self.score getNodesFromBeat:now-BORDERLINE_OK-0.5f toBeat:now+duration];
	
	//search target tapped node
	for (ScoreNode *node in nodes) {
		
		if (node.type == NODETYPE_TAP && node.value.intValue == cellId) {
			float gap = node.beat - now;
			if (gap < 0) gap = -gap;

			if (gap < BORDERLINE_PERFECT) {
				node.valid = NO;
				_resultPerfect++;
				_resultScore += RESULTSCORE_DIF_PERFECT;
				_combo++;
				[self.scene setSpark:cellId];
				[self.scene setResultLabel:cellId result:RESULT_PERFECT andLifeTime:now];
				break;
				
			} else if (gap < BORDERLINE_GREAT) {
				node.valid = NO;
				_resultGreat++;
				_resultScore += RESULTSCORE_DIF_GREAT;
				_combo++;
				[self.scene setSpark:cellId];
				[self.scene setResultLabel:cellId result:RESULT_GREAT andLifeTime:now];
				break;
				
			} else if (gap < BORDERLINE_GOOD) {
				node.valid = NO;
				_resultGood++;
				_resultScore += RESULTSCORE_DIF_GOOD;
				_combo++;
				[self.scene setSpark:cellId];
				[self.scene setResultLabel:cellId result:RESULT_GOOD andLifeTime:now];
				break;
				
			} else if (gap < BORDERLINE_OK) {
				node.valid = NO;
				_resultOk++;
				_resultScore += RESULTSCORE_DIF_OK;
				_combo++;
				[self.scene setSpark:cellId];
				[self.scene setResultLabel:cellId result:RESULT_OK andLifeTime:now];
				break;
				
			} else {
				node.valid = NO;
				_resultMiss++;
				if (self.combo > self.resultMaxCombo) _resultMaxCombo = self.combo;
				_combo = 0;
				
				[self.scene setResultLabel:cellId result:RESULT_MISS andLifeTime:now];
				break;
				
			}
		}
	}
}

/*----------------------------------------------------------------------------
 Convert Beat <-> DutaionTime
 ----------------------------------------------------------------------------*/

-(float) getBeat {
	return [self getBeat:(float)player.currentTime];
}

-(float) getBeat:(float)atTime {
	float beat = ((atTime * self.score.bpm / 60.0f) - self.score.beatOffset);
	return beat;
}

/*----------------------------------------------------------------------------
 Game state change
 ----------------------------------------------------------------------------*/

-(void) setStateForBeforeStart {
	_state = GAMESTATE_BEFORE_PLAY;

	//Stop update
	[self.scene unscheduleUpdate];
	
	//Set objects
	[self.scene showLayerBeforeStart:YES];
	[self.scene showLayerPause:NO];
	
	//Initialize score
	_combo = 0;
	_resultPerfect = 0;
	_resultGreat = 0;
	_resultGood = 0;
	_resultOk = 0;
	_resultMiss = 0;
	_resultScore = 0;
	_resultMaxCombo = 0;
}

-(void) startGame {
	_state = GAMESTATE_PLAY;

	//Play song
    NSURL *url = [NSURL fileURLWithPath:self.score.musicPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player prepareToPlay];
	[player setVolume:1.0];
	[player play];

	//Start update
	[self.scene scheduleUpdate];

	//Set objects
	[self.scene showLayerBeforeStart:NO];
	[self.scene showLayerPause:NO];
}

-(void) pauseGame {
	if (self.state == GAMESTATE_PLAY) {
		_state = GAMESTATE_PAUSE;

		//Puase song
		[player pause];
		
		//Set objects
		[self.scene unscheduleUpdate];
		[self.scene showLayerPause:YES];
	}
}

-(void) restartGame {
	if (self.state == GAMESTATE_PAUSE) {
		_state = GAMESTATE_PLAY;

		//Play song
		[player play];
		
		//Set objects
		[self.scene scheduleUpdate];
		[self.scene showLayerPause:NO];
	}
}

-(void) resetGame {
	if (self.state == GAMESTATE_PAUSE) {
		//reload score data
		[self.score loadScore: self.score.scoreName];
		self.scene.score = self.score;
		
		//Destroy player
		[player dealloc];
		
		[SEPlayer play:SE_TYPE_OK];
		[self setStateForBeforeStart];
	}
}

-(void) retireGame {
	if (self.state == GAMESTATE_PAUSE) {
		
		//Destroy player
		[player dealloc];

		[SEPlayer play:SE_TYPE_CANCEL];
		[self.scene backToMenu];
	}
}

/*----------------------------------------------------------------------------
 Other functions
 ----------------------------------------------------------------------------*/

-(void) returnTopMenu {
	[self.scene unscheduleUpdate];
	[player dealloc];
	
	[SEPlayer play:SE_TYPE_CANCEL];
	[self.scene backToMenu];
}

-(void) tweet {
	TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
	NSString *text = [NSString stringWithFormat:@"%@でスコア：%dでした！みんなもチャレンジ！ #wotagame", self.score.title, self.resultScore];
	[tweetViewController setInitialText:text];
	tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult res) {
//		if (res == TWTweetComposeViewControllerResultCancelled) {
//		}
//		else if (res == TWTweetComposeViewControllerResultDone) {
//		}
		[[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
	};	
	[[CCDirector sharedDirector] presentModalViewController:tweetViewController animated:YES];
}

@end
