//
//  MusicSelectLayer
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/26.
//  Copyright 2013年 wotagineer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "cocos2d.h"
#import "defines.h"
#import "PlayController.h"
#import "PlayLayer.h"
#import "ScoreFileManager.h"
#import "ScoreModel.h"
#import "SEPlayer.h"
#import "TopMenuLayer.h"

@interface MusicSelectLayer : CCLayer <
	UITableViewDelegate
> {
}

+(CCScene *) scene;

@end
