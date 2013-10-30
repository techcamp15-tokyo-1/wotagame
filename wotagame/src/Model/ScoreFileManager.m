
//
//  ScoreFileManager.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/27.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "ScoreFileManager.h"

@implementation ScoreFileManager

NSMutableArray *items;

+(ScoreFileManager *)manager {
	ScoreFileManager* instance = [[super alloc] init];
	items = [[NSMutableArray alloc] init];
	[instance loadScoreFileList];

	return instance;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [items count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
	cell.textLabel.text = [items objectAtIndex:indexPath.row];
	return cell;
}

-(NSString *)getScorePathForIndex:(int)index {
	return items[index];
}

//プリセットデータをインストールする
-(void) installZipFile {
	[self deleteScoreFile];

	ZipArchive *archiver = [[ZipArchive alloc] init];
	NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"scores" ofType:@"zip"];
	NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	toPath = [toPath stringByAppendingPathComponent:@"Cache"];
	
	NSFileManager* fman = [NSFileManager defaultManager];
	NSError *err;
	[fman createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:&err];
	
	if([archiver UnzipOpenFile:fromPath]) {
		if([archiver UnzipFileTo:toPath overWrite:YES]) {
			return;
		}
		[archiver UnzipCloseFile];
	} else {
		return;
	}
	[archiver release];
	[self loadScoreFileList];
	return;
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
		}
	}
	
	NSLog(@"%d", items.count);

	if (items.count == 0) {
		[self installZipFile];
		[self loadScoreFileList];
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
