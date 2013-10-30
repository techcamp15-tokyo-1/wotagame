//
//  defines.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/25.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __defines_h__
#define __defines_h__

//System font name
#define FONT_NAME @"Arial Rounded MT Bold"

//The filename of scoredate in score zipfile.
#define FILENAME_SCORE @"score.wscore"

//The characode of symbol of scoredate type
#define CHARACODE_TYPE_COMMENT 35	// # :Symbol of comment type
#define CHARACODE_TYPE_META 37		// % :Symbol of metadata type

//The border line when touch timing gap is joudged (unit: beat)
#define BORDERLINE_PERFECT 0.14f
#define BORDERLINE_GREAT 0.30f
#define BORDERLINE_GOOD 0.40f
#define BORDERLINE_OK 0.50f

//Transition duration of each scene
#define TRANSITION_DURATION_TIME 0.4f

//Score metadata default value
#define SCOREMETA_DEFAULT_DURATION 0.75f
#define SCOREMETA_DEFAULT_LOCK false
#define SCOREMETA_DEFAULT_DIFFICULTY 3
#define SCOREMETA_DEFAULT_OFFSET 0.00f
#define SCOREMETA_DEFAULT_TITLE @"Unknown"
#define SCOREMETA_DEFAULT_ARTIST @"Unknown"

//The score value you can get when you successed to tap the node
#define RESULTSCORE_DIF_PERFECT 500
#define RESULTSCORE_DIF_GREAT 100
#define RESULTSCORE_DIF_GOOD 50
#define RESULTSCORE_DIF_OK 10

//Score node type
enum NODETYPE {
	NODETYPE_TAP = 0,		//tap node
	NODETYPE_BPM,			//change bpm node
	NODETYPE_END,			//end node
	NODETYPE_SPARK,			//spark effect node
	NODETYPE_ACTION,		//stick-man action change node
	NODETYPE_BACKGROUND,	//background image change node
	NODETYPE_NODEDURATION,	//node duration change node
	NODETYPE_MISS,			//miss node
	NODETYPE_DUMMY			//dummy node
};

//The type of judgement of tap timing
enum RESULT {
	RESULT_OK = 0,
	RESULT_GOOD,
	RESULT_GREAT,
	RESULT_PERFECT,
	RESULT_MISS
};

//Sound effect type
enum SE_TYPE {
	SE_TYPE_BGM_MENU,
	SE_TYPE_SELECT,
	SE_TYPE_OK,
	SE_TYPE_CANCEL
};

//Stick-Man action type
enum SM_ACTION {
	SM_ACTION_KECHA,
	SM_ACTION_PPPH,
	SM_ACTION_HACHINOJI,
	SM_ACTION_ROMANCE,
	SM_ACTION_THUNDERSNAKE
};

//Game state type
enum GAMESTATE {
	GAMESTATE_PLAY = 0,
	GAMESTATE_BEFORE_PLAY,
	GAMESTATE_PAUSE,
	GAMESTATE_FINISHED
};

#endif
