//
//  PlayLayer.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/21.
//  Copyright 2013年 wotagineer. All rights reserved.
//
//	Scene:Playのビュー

#import "defines.h"
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "PlayController.h"

@interface PlayLayer : CCLayer {
}

+(CCScene *) scene;

//初期化
-(void)initialize;

//ゲーム開始準備
-(void)prepareStart;
-(void)setBackGround:(NSString *)path;

//一時停止する
-(void)pause;

//終了する
-(void)finish;

//タッチ成功エフェクト
-(void)setSuccesEffect:(int)cellId result:(enum RESULT)result;
-(void)setEffectParticle:(int) cellId;
-(void)setEffectSuccess:(int) cellId result:(enum RESULT)result;

//タッチ失敗エフェクト
-(void)setMissEffect:(int)cellID;

//タップされたセルを求める
-(int)pursueTappedCell:(UITouch *)touch withEvent:(UIEvent *)event;

//---------------------------------
//	更新系
-(void)updateScoreLabel;
-(void)updateResultCell:(int)cellId;
-(void)updateTapCell:(int)cellId atValueOf:(float)stateValue;

@end

