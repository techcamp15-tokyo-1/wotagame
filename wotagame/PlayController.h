//
//  PlayController.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//
//	Scene:Playの管理を行う

#import <AVFoundation/AVFoundation.h>
#import "ScoreModel.h"

@interface PlayController : NSObject<
	AVAudioPlayerDelegate,
	CCTouchOneByOneDelegate
> {
	NSMutableArray *nodeArray;
	int _bpm;
	float _beat_offset;
}

@property (atomic, readonly) AVAudioPlayer *player;
@property (atomic, readonly) BOOL isLoaded;
@property (atomic, readonly) BOOL isPlaying;
@property (atomic, readonly) int score;

+(PlayController *) initialize;
-(void) loadFile: (NSString *)path_music withScorePath:(NSString *)path_score;

-(void) playMusic;
-(void) stopMusic;
-(void) pauseMusic;
-(void) restartMusic;

-(float) getBeat;
-(NSMutableArray *) getShowNodeList;
-(float)getTouchGap:(float)beat ofCellID:(int)cellID;
-(void)onTouchBegan:(float)beat ofCellID:(int)cellID;
@end