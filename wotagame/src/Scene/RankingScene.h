//
//  RankingScene.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __RankingScene_h__
#define __RankingScene_h__

#import "defines.h"
#import "cocos2d.h"
#import "CCSceneEx.h"
#import "CCButton.h"
#import "WaveLayer.h"

#import "TopMenuScene.h"

@interface RankingScene : CCSceneEx {
	WaveLayer* layerWave;
}

@end

#endif