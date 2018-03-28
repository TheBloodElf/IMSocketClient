//
//  YJNChatInputBar.m
//  SocketIMDemo
//
//  Created by Vanduza on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "YJNChatInputBar.h"

@interface YJNChatInputBar()
@property (nonatomic, strong) UIView *inputBarView;
@property (nonatomic, strong) UICollectionView *functionPadView;
@end
@implementation YJNChatInputBar

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
}

#pragma mark - ChatKeyBoardNotification
- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame     = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame   = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration    = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - private bottom view
- (void)_willShowBottomHeight:(CGFloat)bottomHeight
{
    [self _willShowBottomHeight:bottomHeight withAnimation:NO];
}

- (void)_willShowBottomHeight:(CGFloat)bottomHeight withAnimation:(BOOL)animation{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    [UIView animateWithDuration:animation ? 0.23 : 0 animations:^{
        self.frame = toFrame;
        if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
            [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
        }
    } completion:^(BOOL finished) {
        
    }];
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
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
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
    }
    return _inputBarView;
}

@end
