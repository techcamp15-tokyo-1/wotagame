//
//  PlayLayer.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/21.
//  Copyright 2013年 wotagineer. All rights reserved.
//
//	Scene:Playのビュー

#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "PlayController.h"

@interface PlayLayer : CCLayer {
}

+(CCScene *) scene;

//ゲームを最初からやり直す準備
-(void)initializeToRestart;
	
//一時停止
-(void)pause;
		
//ゲーム開始準備
-(void)initializeToStart;
-(void)initializeToStartWithPath:(NSString *)path_bg;

@end
