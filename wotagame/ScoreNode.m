//
//  ScoreNode.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ScoreNode.h"

@implementation ScoreNode

+(ScoreNode *) node:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type {
	ScoreNode *node = [[ScoreNode alloc] init];
	node.value = value;
	node.beat = beat;
	node.type = type;
	node.isShowed = NO;
	return node;
}

@end
