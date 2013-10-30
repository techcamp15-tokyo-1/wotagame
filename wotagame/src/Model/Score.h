//
//  Score.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/22.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __Score_h__
#define __Score_h__

#import "defines.h"
#import "ScoreNode.h"

@interface Score : NSObject {
}

//constructor
+(Score *) score:(NSString *)path;

@property int bpm;
@property int difficulty;
@property bool isLocked;
@property float beatOffset;
@property float nodeDuration;
@property (strong) NSString *title;
@property (strong) NSString *scoreName;
@property (strong) NSString *scorePath;
@property (strong) NSString *musicPath;
@property (strong) NSString *backgroundPath;
@property (strong) NSString *artist;

-(void) loadScore:(NSString *)name;

-(void) addNode:(float)beat withType:(enum NODETYPE)type andValue:(NSString *)value;
-(NSArray *) getNodesFromBeat:(float)from toBeat:(float)to;

@end

#endif