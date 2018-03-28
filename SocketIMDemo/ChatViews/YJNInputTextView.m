//
//  YJNInputTextView.m
//  SocketIMDemo
//
//  Created by Vanduza on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "YJNInputTextView.h"

@implementation YJNInputTextView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_initView];
    }
    return self;
}

-(void)p_initView {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
}
#pragma mark - 通知
-(void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

#pragma mark - Setter方法
-(void)setPlaceHolder:(NSString *)placeHolder {
    if ([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    
    NSUInteger maxCharsPerLine = [YJNInputTextView maxCharactersPerLine];
    
    if([placeHolder length] > maxCharsPerLine) {
        placeHolder = [placeHolder substringToIndex:maxCharsPerLine - 8];
        placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }
    
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}
#pragma mark - Getter方法
-(NSUInteger)numberOfLines {
    return [YJNInputTextView linesOfText:self.text];
}
#pragma mark - 类方法
+(NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+(NSUInteger)linesOfText:(NSString *)text {
    return (text.length / [YJNInputTextView maxCharactersPerLine]) + 1;
}

#pragma mark - 重写

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if([self.text length] == 0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(10.0f,7.0f,rect.size.width,rect.size.height);
        
        UIColor *placeHolderColor = [UIColor lightGrayColor];
        
        [placeHolderColor set];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        
        [self.placeHolder drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : placeHolderColor,
                                        NSParagraphStyleAttributeName : paragraphStyle }];
    }
}

-(void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

-(void)setContentOffset:(CGPoint)contentOffset {
    if(self.contentSize.height > self.frame.size.height)
        [super setContentOffset:contentOffset];
    else
        [super setContentOffset:CGPointMake(0, 0)];
}

@end
