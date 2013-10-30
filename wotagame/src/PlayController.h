//
//  PlayController.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/26.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//
#ifndef __PlayController_h__
#define __PlayController_h__

#import "defines.h"
#import <AVFoundation/AVFoundation.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "Score.h"
#import "PlayScene.h"

@class PlayScene;

@interface PlayController: NSObject {
	AVAudioPlayer* player;
}

@property (strong) PlayScene* scene;
@property (strong) Score* score;
@property (assign, readonly) enum GAMESTATE state;

@property (assign, readonly) int combo;

@property (assign, readonly) int resultScore;
@property (assign, readonly) int resultPerfect;
@property (assign, readonly) int resultGreat;
@property (assign, readonly) int resultGood;
@property (assign, readonly) int resultOk;
@property (assign, readonly) int resultMiss;
@property (assign, readonly) int resultMaxCombo;
@property (assign, readonly) enum SM_ACTION actionId;

+(id)initWithScene: (PlayScene*) scene;

-(void)update: (ccTime)dt;
-(void)tapCell: (int)cellId;

-(float)getBeat;
-(float)getBeat: (float)atTime;

-(void)startGame;
-(void)pauseGame;
-(void)restartGame;
-(void)retireGame;
-(void)resetGame;

-(void)returnTopMenu;
-(void)tweet;
@end

#endif