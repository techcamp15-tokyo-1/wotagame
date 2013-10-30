//
//  ScoreNode.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//
#ifndef __ScoreNode_h__
#define __ScoreNode_h__

#import "defines.h"

@interface ScoreNode : NSObject {
}

@property float beat;
@property int channel;
@property enum NODETYPE type;
@property (strong) NSString *value;
@property BOOL valid;

//constructor
+(ScoreNode *) node:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value;

@end

#endif