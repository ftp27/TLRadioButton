//
//  TLRadioButton.h
//  TLRadioButton
//
//  Created by Aleksey Cherepanov on 26.04.16.
//  Copyright © 2016 IndevGroup LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TLRadioButton : UIControl


@property (nonatomic) IBInspectable BOOL isChecked;
@property (nonatomic) IBInspectable CGFloat animationDuration;

@property (nonatomic) IBInspectable UIColor *selectedColor;
@property (nonatomic) IBInspectable UIColor *notSelectedColor;

- (void) toggleCheckBox;

- (void)addCheckAnimation;
- (void)addCheckAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock;
- (void)addCheckAnimationReverse:(BOOL)reverseAnimation totalDuration:(CFTimeInterval)totalDuration completionBlock:(void (^)(BOOL finished))completionBlock;
- (void)removeAnimationsForAnimationId:(NSString *)identifier;
- (void)removeAllAnimations;


@end
