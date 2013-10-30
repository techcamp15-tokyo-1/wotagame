//
//  WaveLayer.h
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/23.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __WaveLayerScene_h__
#define __WaveLayerScene_h__

#import "cocos2d.h"
#import "defines.h"
#import "CCLayer.h"

@interface WaveLayer : CCLayer

/*
 Update wave position
 It must be called in update method
 */
-(void) update;

@end

#endif