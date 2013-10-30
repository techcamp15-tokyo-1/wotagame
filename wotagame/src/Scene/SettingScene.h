//
//  SettingScene.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __SettingScene_h__
#define __SettingScene_h__

#import "defines.h"
#import "cocos2d.h"
#import "CCSceneEx.h"
#import "CCButton.h"
#import "WaveLayer.h"
#import "ScoreFileManager.h"

#import "TopMenuScene.h"

@interface SettingScene : CCSceneEx {
	WaveLayer* layerWave;
	CCLabelTTF* label2;
}

@end

#endif