//
//  ScoreNode.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

enum NODETYPE {
	ACTION = 0,
	BPM,
	END
};

@interface ScoreNode : NSObject {
}

@property (retain) NSString *value;
@property float beat;
@property enum NODETYPE type;
@property bool isShowed;

+(ScoreNode *) node:(NSString *)value atBeat:(float)beat withType:(enum NODETYPE)type;

@end
