//
//  Score.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "Score.h"

@implementation Score

NSMutableArray *nodeArray;
NSMutableArray *nodeList_forScore;

+(instancetype) score:(NSString *)name {
	Score* score = [[Score alloc] init];
	[score loadScore:name];
	return score;
}

-(void) addNode:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value {
	ScoreNode *node = [ScoreNode node:beat withType:type andValue:value];
	[nodeArray addObject:node];
}

-(NSArray *) getNodesFromBeat:(float)from toBeat:(float)to {
	NSMutableArray *array = [[NSMutableArray alloc] init];

	for (ScoreNode *node in nodeArray) {
		if (node.valid && node.beat > from && node.beat < to) {
			[array addObject:node];
		}
	}
	
	return array;
}

-(void) loadScore:(NSString *)name {
	
	NSString *scorePath = [NSString stringWithFormat:@"%@/Library/Cache/scores/%@/%@", NSHomeDirectory(), name, FILENAME_SCORE];
	NSString *text = [NSString stringWithContentsOfFile:scorePath encoding:NSUTF8StringEncoding error:nil];
	
	//Set score metadata
	self.scorePath = scorePath;
	self.scoreName = name;
	self.nodeDuration = SCOREMETA_DEFAULT_DURATION;
	self.isLocked = SCOREMETA_DEFAULT_LOCK;
	self.difficulty = SCOREMETA_DEFAULT_DIFFICULTY;
	self.beatOffset = SCOREMETA_DEFAULT_OFFSET;
	self.title = SCOREMETA_DEFAULT_TITLE;
	self.artist = SCOREMETA_DEFAULT_ARTIST;

	nodeArray = [[NSMutableArray alloc] init];

	NSArray *lines = [text componentsSeparatedByString:@"\n"];
	for (NSString *line in lines) {
		if (line.length > 0) {
			switch ([line characterAtIndex:0]) {
				case CHARACODE_TYPE_COMMENT:
					break;
					
				case CHARACODE_TYPE_META:
					[self parseMetaFromLine:line];
					break;
					
				default:
					[self parseNodeFromLine:line];
					break;
			}
		}
	}
}

-(void) parseMetaFromLine:(NSString *)line {
	NSArray *tags = [line componentsSeparatedByString:@" "];
	NSString *key = tags[0];
	NSString *val = tags[1];
	
	if ([key isEqualToString:@"%UNLOCK"]) {
		self.isLocked = NO;
		return;
	}
	if ([key isEqualToString:@"%OFFSET"]) {
		self.beatOffset = val.floatValue;
		return;
	}
	if ([key isEqualToString:@"%BPM"]) {
		self.bpm = val.intValue;
		return;
	}
	if ([key isEqualToString:@"%TITLE"]) {
		self.title = [val retain];
		return;
	}
	if ([key isEqualToString:@"%ARTIST"]) {
		self.artist = [val retain];
		return;
	}
	if ([key isEqualToString:@"%DIFFICULTY"]) {
		self.difficulty = val.intValue;
		return;
	}
	if ([key isEqualToString:@"%NODEDURATION"]) {
		self.nodeDuration = val.floatValue;
		return;
	}
	if ([key isEqualToString:@"%MUSIC"]) {
		self.musicPath = [[NSString stringWithFormat:@"%@/Library/Cache/scores/%@/%@", NSHomeDirectory(), self.scoreName, val] retain];
		return;
	}
	if ([key isEqualToString:@"%BACKGROUND"]) {
		self.backgroundPath = [[NSString stringWithFormat:@"%@/Library/Cache/scores/%@/%@", NSHomeDirectory(), self.scoreName, val] retain];
		return;
	}
}

-(void) parseNodeFromLine:(NSString *)line {
	NSArray *tags = [line componentsSeparatedByString:@" "];
	float beat = ((NSString *)tags[0]).floatValue;
	NSString *key = tags[1];
	
	if ([key isEqualToString:@"TAP"]) {
		[self addNode:beat withType:NODETYPE_TAP andValue:((NSString *)tags[2])];
		
	} else if ([key isEqualToString:@"ACTION"]) {	//Stick-man action
		[self addNode:beat withType:NODETYPE_ACTION andValue:tags[2]];
		
	} else if ([key isEqualToString:@"SPARK"]) {	//Spark
		[self addNode:beat withType:NODETYPE_SPARK andValue:tags[2]];

	} else if ([key isEqualToString:@"BACKGROUND"]) {	//Back-ground image
		[self addNode:beat withType:NODETYPE_BACKGROUND andValue:tags[2]];
		
	} else if ([key isEqualToString:@"END"]) {
		[self addNode:beat withType:NODETYPE_END andValue:tags[2]];
		
	}
	
}

@end
