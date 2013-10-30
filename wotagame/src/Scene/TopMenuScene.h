//
//  TopMenuScene.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __TopMenuScene_h__
#define __TopMenuScene_h__

#import "defines.h"
#import "cocos2d.h"
#import "CCSceneEx.h"
#import "WaveLayer.h"
#import "CCButton.h"

#import "MusicSelectScene.h"
#import "SettingScene.h"
#import "RankingScene.h"
#import "SkillCollectionScene.h"

@interface TopMenuScene : CCSceneEx{
	WaveLayer* layerWave;
}
@end

#endif