//
//  ScoreNode.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ScoreNode.h"

@implementation ScoreNode

+(ScoreNode *) node:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type {
	return [self node:cellId atBeat:beat withType:type andValue:nil];
}

+(ScoreNode *) node:(int)cellId atBeat:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value {
	ScoreNode *node = [[ScoreNode alloc] init];
	node.cellId = cellId;
	node.beat = beat;
	node.type = type;
	node.value = [value retain];
	return node;
}


@end
