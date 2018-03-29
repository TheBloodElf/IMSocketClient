//
//  YJNChatInputBar.m
//  SocketIMDemo
//
//  Created by Vanduza on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "YJNChatInputBar.h"
#import "YJNInputTextView.h"

@interface YJNChatInputBar()<UITextViewDelegate>
@property (nonatomic, strong) UIView *inputBarView;
@property (nonatomic, strong) UICollectionView *functionPadView;
@property (nonatomic, strong) YJNInputTextView *inputTextView;
@property (nonatomic, assign) BOOL isShowBottomView;
@property (strong, nonatomic) UIView *activityButtomView;
@end
@implementation YJNChatInputBar {
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (frame.size.height < (_verticalPadding * 2 + _inputViewMinHeight)) {
        frame.size.height = _verticalPadding * 2 + _inputViewMinHeight;
    }
    
    if (self = [super initWithFrame:frame]) {
        [self p_initData];
        [self p_initNotification];
        [self p_setupSubViews];
    }
    
    return self;
}

-(void)p_initData {
    
}

-(void)p_initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)p_setupSubViews {
    [self addSubview:self.inputBarView];
    UIButton *styleChangeButton = [[UIButton alloc] init];
    styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [styleChangeButton setImage:[UIImage imageNamed:@"XmsgUIResource.bundle/chatBar_record"] forState:UIControlStateNormal];
    [styleChangeButton setImage:[UIImage imageNamed:@"XmsgUIResource.bundle/chatBar_keyboard"] forState:UIControlStateSelected];
    [styleChangeButton addTarget:self action:@selector(styleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat itemHeight = self.inputBarView.frame.size.height - self.verticalPadding * 2;
}

-(void)styleButtonAction:(UIButton *)sender {
    NSLog(@"changeStyle");
}

+ (CGFloat)defaultHeight {
    return 5 * 2 + 36;
}

#pragma mark - ChatKeyBoardNotification
- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame     = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame   = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration    = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)(void) = ^{
        [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - private bottom view
-(void)_willShowBottomHeight:(CGFloat)bottomHeight {
    [self _willShowBottomHeight:bottomHeight withAnimation:NO];
}

-(void)_willShowBottomHeight:(CGFloat)bottomHeight withAnimation:(BOOL)animation {
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.inputBarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.inputBarView.frame.size.height) {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowBottomView = NO;
    }
    else{
        self.isShowBottomView = YES;
    }
    [UIView animateWithDuration:animation ? 0.23 : 0 animations:^{
        self.frame = toFrame;
//        if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
//            [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
//        }
    } completion:nil];
}

- (void)_willShowBottomView:(UIView *)bottomView
{
    [self _willShowBottomView:bottomView withAniamtion:NO];
}

- (void)_willShowBottomView:(UIView *)bottomView withAniamtion:(BOOL)animation{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self _willShowBottomHeight:bottomHeight withAnimation:animation];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.inputBarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self _willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self _willShowBottomHeight:0];
    }else {
        [self _willShowBottomHeight:toFrame.size.height];
    }
}

+(void)initialize {
    YJNChatInputBar *bar = [YJNChatInputBar appearance];
    bar.verticalPadding    = 5;
    bar.horizontalPadding  = 8;
    bar.inputViewMinHeight = 36;
    bar.inputViewMaxHeight = 106;
}

#pragma mark - Getter
-(UIView *)inputBarView {
    if (!_inputBarView) {
        _inputBarView = [[UIView alloc] initWithFrame:self.bounds];
        [_inputBarView addSubview:self.inputTextView];
    }
    return _inputBarView;
}

-(YJNInputTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[YJNInputTextView alloc] initWithFrame:CGRectMake(self.horizontalPadding, self.verticalPadding, self.frame.size.width - self.verticalPadding * 2, self.frame.size.height - self.verticalPadding * 2)];
        _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _inputTextView.scrollEnabled = YES;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _inputTextView.placeHolder = @"在这里输入...";
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _inputTextView.layer.borderWidth = 0.65f;
        _inputTextView.layer.cornerRadius = 4.0f;
        _previousTextViewContentHeight = [self _getTextViewContentH:_inputTextView];
    }
    return _inputTextView;
}

#pragma mark - inputView相关私有方法
- (CGFloat)_getTextViewContentH:(UITextView *)textView {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

@end
