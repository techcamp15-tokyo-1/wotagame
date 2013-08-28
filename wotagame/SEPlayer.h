//
//  SEPlayer.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/28.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "defines.h"

@interface SEPlayer : NSObject

+(void)play:(enum SE_TYPE)type;
+(void)initialize;
@end

