//
//  ScoreFileManager.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/27.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __ScoreFileManager_h__
#define __ScoreFileManager_h__

#import "defines.h"
#import "ZipArchive.h"

@interface ScoreFileManager : NSObject <
	UITableViewDataSource
>

+(ScoreFileManager *)manager;
-(void)installZipFile;
-(NSString *)getScorePathForIndex:(int)index;
@end

#endif