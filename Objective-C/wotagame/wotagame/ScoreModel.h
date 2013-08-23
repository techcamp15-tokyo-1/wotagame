//
//  ScoreNode.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ScoreNode.h"

@interface ScoreNodeModel : NSObject {
}

+(void) addNode:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type;
+(NSMutableArray *) getFutureNodesAtBeat:(float)beat andDurationfrom:(float)durationBefore to:(float)durationAfter;

@end
