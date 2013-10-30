//
//  SEPlayer.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/28.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __SEPlayer_h__
#define __SEPlayer_h__

#import "defines.h"
#import <AVFoundation/AVFoundation.h>

@interface SEPlayer : NSObject {
}

+(void)play:(enum SE_TYPE)type;
+(void)stop:(enum SE_TYPE)type;
+(void)initialize;

@end

#endif
