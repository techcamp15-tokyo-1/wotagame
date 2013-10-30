//
//  PlayScene.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/26.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//
#ifndef __PlayScene_h__
#define __PlayScene_h__

#import "defines.h"
#import "cocos2d.h"
#import "CCSceneEx.h"
#import "CCButton.h"
#import "CCTouchDispatcher.h"
#import "Score.h"

#import "MusicSelectScene.h"
#import "PlayController.h"

@class PlayController;

@interface PlayScene : CCSceneEx <
	CCTouchOneByOneDelegate
> {
	NSMutableArray *tapActionFrames;
	NSMutableArray *cells;					//Array of tap cell nodes

	NSMutableArray *resultFrames;
	NSMutableArray *resultLabels;			//Array of result label nodes
	NSMutableArray *resultLabelLifeTime;
	
	NSArray *actionParamList;
	NSMutableArray *SMActionFrameList;
	
	CCSpriteFrameCache *cache;
	CCSprite *spriteBG;
	CCSprite *spriteSM;
	CCLayer *layerBeforeStart;
	CCLayer *layerPause;
	CCLayer *layerResult;
	CCLabelTTF *labelMusicInfo;
	CCLabelTTF *labelResult;
	PlayController* _controller;
}

@property (strong) PlayController  *controller;
@property (strong) Score *score;

-(void) update: (ccTime)dt;
-(void) updateCell: (int) cellId andValue: (float) value;
-(void) updateResultLabel:(int) cellId andBeat:(float) beat;
-(void) updateSMAction: (int)actionID;

-(void) setResultLabel:(int) cellId result:(enum RESULT)result andLifeTime:(float)beat;
-(void) setSpark:(int) cellId;

-(void) showLayerBeforeStart: (BOOL) isVisible;
-(void) showLayerPause: (BOOL) isVisible;
-(void) showLayerResult: (BOOL) isVisible;

-(void) backToMenu;

@end

#endif