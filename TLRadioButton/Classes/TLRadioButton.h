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

/**
 Radio button status
 */
@property (nonatomic) IBInspectable BOOL isChecked;
/**
 Speed of radio button animation
 */
@property (nonatomic) IBInspectable CGFloat animationDuration;

/**
  Toggle the radio button status
 */
- (void) toggleRadioButton;

/**
 Basic run animation ON
 */
- (void)addCheckAnimation;

/**
 Run animation ON with completion block
 
 @param completionBlock Block runs after animation
 */
- (void)addCheckAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock;

/**
 Run animation ON with completion block
 
 @param reverseAnimation Animation duration. If YES - runs animation ON
 @param totalDuration Animation duration
 @param completionBlock Block runs after animation
 */
- (void)addCheckAnimationReverse:(BOOL)reverseAnimation totalDuration:(CFTimeInterval)totalDuration completionBlock:(void (^)(BOOL finished))completionBlock;

/**
 Remove animation with Id
 
 @param identifier Identifier of removed animation
 */
- (void)removeAnimationsForAnimationId:(NSString *)identifier;

/**
 Remove all animations
 */
- (void)removeAllAnimations;


@end
