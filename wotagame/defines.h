//
//  defines.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/25.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#ifndef defines_h
#define defines_h
//========================================================================================
//
//		マクロ集
//
//----------------------------------------------------------------------------------------
//
//		プログラマとは、楽をするための努力を惜しまない人間である。
//													--Yuichiro Kikura(1992 - )
//
//----------------------------------------------------------------------------------------

//デバッグモード切り替え
//#define ISDEBUG

//========================================================================================
//デバッグ関数
//----------------------------------------------------------------------------------------
#ifdef ISDEBUG

#define LOG(x) NSLog(@"%s(%03d) : %@", __PRETTY_FUNCTION__, __LINE__, x);

//========================================================================================
//リリース時用にデバッグ関数を消す
//----------------------------------------------------------------------------------------
#else

#define LOG(x)

#endif

//========================================================================================
//普通の定数
//----------------------------------------------------------------------------------------
#define FILENAME_SCORE @"score.wscore"
#define FONT_NAME @"Arial Rounded MT Bold"

#define CHARACODE_TYPE_COMMENT 35	// #
#define CHARACODE_TYPE_META 37		// %

#define GAP_OFFSET 0.20

#define BORDERLINE_PERFECT 0.15
#define BORDERLINE_GOOD 0.30
#define BORDERLINE_GREAT 0.55
#define BORDERLINE_OK 0.75

#define TRANSITION_DURATION_TIME 0.7f
#define CELLID_METACELL 9

#define USER_SETTING @"userSettings"

#define KEY_INSTALLED_PRESET_FILES @"installedPresetFiles"
#define KEY_USER_SELECTED_MUSIC @"userSelectedMusic"

typedef struct {
	int bpm;
	int difficulty;
	float beatOffset;
	float nodeDuration;
	NSString *title;
	NSString *scoreName;
	NSString *scorePath;
	NSString *musicPath;
	NSString *backgroundPath;
	NSString *artist;
} ScoreMeta;

enum NODETYPE {
	NODETYPE_TAP = 0,		//通常のタップノード
	NODETYPE_BPM,			//BPM変更ノード
	NODETYPE_END,			//終端ノード
	NODETYPE_SPARK,			//火花ノード
	NODETYPE_BACKGROUND,	//背景変更ノード
	NODETYPE_NODEDURATION,	//ノード間隔変更ノード
	NODETYPE_MISS,			//MISSノード（タップノードが時間切れになると生成されるノード）
	NODETYPE_DUMMY			//ダミーノード（ノードが空の時に返す　今考えてみるとnilで良かった気がする)
};

enum RESULT {
	RESULT_OK = 0,
	RESULT_GOOD,
	RESULT_GREAT,
	RESULT_PERFECT,
	RESULT_MISS
};

enum layerZindex {
	Z_BackGround,
	Z_Play,
	Z_Front,
	Z_Start,
	Z_Pause,
	Z_Result,
};

enum SE_TYPE {
	SE_TYPE_SELECT,
	SE_TYPE_OK,
	SE_TYPE_CANCEL
};


//----------------------------------------------------------------------------------------

#endif
