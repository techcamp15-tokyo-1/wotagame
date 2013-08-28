
//
//  ScoreFileManager.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/27.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ScoreFileManager.h"

@implementation ScoreFileManager

NSMutableArray *items;

+(ScoreFileManager *)getInstance {
	static ScoreFileManager *instance;
	if (!instance) {
		instance = [[ScoreFileManager alloc] init];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:USER_SETTING ofType:@"plist"]];
		
		if (![dict objectForKey:KEY_INSTALLED_PRESET_FILES]) {
			[instance deleteScoreFile];
			if([instance installZipFile]){
				[dict setValue:YES forKey:KEY_INSTALLED_PRESET_FILES];
				[dict writeToFile:[[NSBundle mainBundle] pathForResource:USER_SETTING ofType:@"plist"] atomically:YES];
			}
		}
	}
	
	if (!items) {
		items = [[NSMutableArray alloc] init];
		[instance loadScoreFileList];
	}
	return instance;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [items count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	cell.textLabel.text = [items objectAtIndex:indexPath.row];
	return cell;
}

-(NSString *)getScorePathForIndex:(int)index {
	return items[index];
}

//プリセットデータをインストールする
-(BOOL) installZipFile {
	ZipArchive *za = [[ZipArchive alloc] init];
	NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"scores" ofType:@"zip"];
	NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	toPath = [toPath stringByAppendingPathComponent:@"Cache"];
	
	NSFileManager* fman = [NSFileManager defaultManager];
	NSError *err;
	[fman createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:&err];
	
	if([za UnzipOpenFile:fromPath]) {
		if([za UnzipFileTo:toPath overWrite:YES]) {
			return NO;
		}
		[za UnzipCloseFile];
	} else {
		return NO;
	}
	[za release];
	return YES;
}

//楽譜データを探索する
-(void) loadScoreFileList {
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	path = [path stringByAppendingPathComponent:@"Cache"];
	path = [path stringByAppendingPathComponent:@"scores"];
    NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	
	for (NSString *dir in dirs) {
		
		path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
		path = [path stringByAppendingPathComponent:@"Cache"];
		path = [path stringByAppendingPathComponent:@"scores"];
		path = [path stringByAppendingPathComponent:dir];
		path = [path stringByAppendingPathComponent:FILENAME_SCORE];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			[items addObject:dir];
		} else {
			NSLog(@"%@", dir);
		}
	}
}

//楽譜を全て消す
-(void) deleteScoreFile {
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	path = [path stringByAppendingPathComponent:@"Cache"];
	path = [path stringByAppendingPathComponent:@"scores"];
		
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}



@end
