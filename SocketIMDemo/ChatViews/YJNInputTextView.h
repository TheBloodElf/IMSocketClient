//
//  YJNInputTextView.h
//  SocketIMDemo
//
//  Created by Vanduza on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJNInputTextView : UITextView
@property (nonatomic, copy) NSString *placeHolder;
-(NSUInteger)numberOfLines;
+(NSUInteger)maxCharactersPerLine;
+(NSUInteger)linesOfText:(NSString *)text;
@end
