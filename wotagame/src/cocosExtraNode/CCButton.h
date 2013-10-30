//
//  CCButton.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/28.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#ifndef __CCButton_h__
#define __CCButton_h__

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface CCButton : CCMenuItemSprite {
}
//コンストラクタ
+(CCButton *) button:(NSString *)spriteFrameName selectedSprite:(NSString *)selectedSpriteFrameName;
+(CCButton *) buttonOfText:(NSString *)text;

//指定サイズに変形する
-(void)setSize:(CGSize)size;

//イベントをセットする
-(void) setTapEvent:(id)object toSelector:(SEL)sel;

@end

#endif