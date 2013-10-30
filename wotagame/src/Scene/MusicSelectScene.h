//
//  MusicSelectScene.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __MusicSelectScene_h__
#define __MusicSelectScene_h__

#import "defines.h"
#import "cocos2d.h"
#import "CCSceneEx.h"
#import "CCButton.h"
#import "WaveLayer.h"
#import "ScoreFileManager.h"
#import "Score.h"

#import "TopMenuScene.h"
#import "PlayScene.h"

@interface MusicSelectScene : CCSceneEx <UITableViewDelegate> {
	WaveLayer *layerWave;
	CCMenu *menu;
	CCButton *btnStart;
	CCButton *btnBackToTop;
	CCSprite *spriteBgImg;
	CCSprite *spriteBgImgCover;
	CCLabelTTF *musicInfo;
	UITableView *myTableView;	// Score List View
	ScoreFileManager *scoreManager;
	AVAudioPlayer *player;
}
@end

#endif