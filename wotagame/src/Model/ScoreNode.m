//
//  ScoreNode.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "ScoreNode.h"

@implementation ScoreNode 

+(instancetype) node:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value {
	ScoreNode *node = [[ScoreNode alloc] init];
	node.beat = beat;
	node.type = type;
	node.value = value;
	node.valid = true;
	return node;
}


@end
