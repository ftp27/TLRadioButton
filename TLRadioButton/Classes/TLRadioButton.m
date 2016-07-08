//
//  TLRadioButton.m
//  TLRadioButton
//
//  Created by Aleksey Cherepanov on 26.04.16.
//  Copyright © 2016 IndevGroup LTD. All rights reserved.
//

#import "TLRadioButton.h"
#import "QCMethod.h"

@interface TLRadioButton ()

@property (nonatomic, strong) NSMutableDictionary * layers;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;
@property (nonatomic) CGFloat radioSize;
@property (nonatomic) CGFloat centerSize;
@property (nonatomic) CGFloat strokeWidth;

@end

@implementation TLRadioButton

- (void)drawRect:(CGRect)rect {
    [self setupProperties];
    [self setupLayers];
    
#if TARGET_INTERFACE_BUILDER
    if (!self.isChecked) {
        ((CAShapeLayer *) self.layers[@"oval2"]).fillColor = [UIColor clearColor].CGColor;
    }
#else
    self.isChecked = _isChecked;
#endif
    
};

- (void) setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    if (isChecked) {
        [self addCheckAnimationReverse:NO
                         totalDuration:self.animationDuration/1000.0f
                       completionBlock:nil];
    } else {
        [self addCheckAnimationReverse:YES
                         totalDuration:self.animationDuration/1000.0f
                       completionBlock:nil];
    }
}

- (void) toggleRadioButton {
    self.isChecked = !self.isChecked;
}

- (void) inspectableDefaults {
    self.animationDuration = 500.0f;
    self.isChecked = false;
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self) {
        [self inspectableDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
    if (self) {
        [self inspectableDefaults];
    }
    return self;
}

- (void)setupProperties{
	self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
	self.layers = [NSMutableDictionary dictionary];
	
}

- (CGFloat)radioSize {
    return self.frame.size.width;
}

- (CGFloat)centerSize {
    return self.radioSize * 7/11;
}

- (CGFloat)strokeWidth {
    return 2.0f;
}

- (void)setupLayers{
	CAShapeLayer * oval = [CAShapeLayer layer];
	oval.frame = CGRectMake(0, 0, self.radioSize-self.strokeWidth, self.radioSize-self.strokeWidth);
	oval.path = [self ovalPath].CGPath;
	[self.layer addSublayer:oval];
	self.layers[@"oval"] = oval;
	
	CAShapeLayer * oval2 = [CAShapeLayer layer];
    CGFloat frameX = (self.radioSize - self.centerSize)/2;
	oval2.frame = CGRectMake(frameX, frameX, self.centerSize, self.centerSize);
	oval2.path = [self oval2Path].CGPath;
	[self.layer addSublayer:oval2];
	self.layers[@"oval2"] = oval2;
	
	[self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	if(!layerIds || [layerIds containsObject:@"oval"]){
		CAShapeLayer * oval = self.layers[@"oval"];
		oval.fillColor   = nil;
		oval.strokeColor = self.tintColor.CGColor;
		oval.lineWidth   = self.strokeWidth;
	}
	if(!layerIds || [layerIds containsObject:@"oval2"]){
		CAShapeLayer * oval2 = self.layers[@"oval2"];
		oval2.fillColor = self.tintColor.CGColor;
		oval2.lineWidth = 0;
	}
	
	[CATransaction commit];
}

#pragma mark - Animation Setup

- (void)addCheckAnimation{
	[self addCheckAnimationCompletionBlock:nil];
}

- (void)addCheckAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
	[self addCheckAnimationReverse:NO totalDuration:1 completionBlock:completionBlock];
}

- (void)addCheckAnimationReverse:(BOOL)reverseAnimation totalDuration:(CFTimeInterval)totalDuration completionBlock:(void (^)(BOOL finished))completionBlock{
	if (completionBlock){
		CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
		completionAnim.duration = totalDuration;
		completionAnim.delegate = self;
		[completionAnim setValue:@"check" forKey:@"animId"];
		[completionAnim setValue:@(NO) forKey:@"needEndAnim"];
		[self.layer addAnimation:completionAnim forKey:@"check"];
		[self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"check"]];
	}
	
	NSString * fillMode = reverseAnimation ? kCAFillModeBoth : kCAFillModeForwards;
	
	////Oval2 animation
	CAKeyframeAnimation * oval2TransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	oval2TransformAnim.values   = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)], 
		 [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.radioSize/self.centerSize, self.radioSize/self.centerSize, 1)],
		 [NSValue valueWithCATransform3D:CATransform3DIdentity]];
	oval2TransformAnim.keyTimes = @[@0, @0.6, @1];
	oval2TransformAnim.duration = totalDuration;
	
	CAAnimationGroup * oval2CheckAnim = [QCMethod groupAnimations:@[oval2TransformAnim] fillMode:fillMode];
	if (reverseAnimation) oval2CheckAnim = (CAAnimationGroup *)[QCMethod reverseAnimation:oval2CheckAnim totalDuration:totalDuration];
	[self.layers[@"oval2"] addAnimation:oval2CheckAnim forKey:@"oval2CheckAnim"];
}

#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
	if (completionBlock){
		[self.completionBlocks removeObjectForKey:anim];
		if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
			[self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
			[self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
		}
		completionBlock(flag);
	}
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"check"]){
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"oval2"] animationForKey:@"oval2CheckAnim"] theLayer:self.layers[@"oval2"]];
	}
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"check"]){
		[self.layers[@"oval2"] removeAnimationForKey:@"oval2CheckAnim"];
	}
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
}

#pragma mark - Bezier Path

- (UIBezierPath*)ovalPath{
	UIBezierPath * ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.radioSize, self.radioSize)];
	return ovalPath;
}

- (UIBezierPath*)oval2Path{
	UIBezierPath * oval2Path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.centerSize, self.centerSize)];
	return oval2Path;
}

#pragma mark - UIControl overrides

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [super sendAction:action to:target forEvent:event];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    return  YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self toggleRadioButton];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
}


@end
