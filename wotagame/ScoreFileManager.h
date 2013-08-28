//
//  ScoreFileManager.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/27.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"
#import "defines.h"

@interface ScoreFileManager : NSObject <
	UITableViewDataSource
>

+(ScoreFileManager *)getInstance;

-(NSString *)getScorePathForIndex:(int)index;
@end
