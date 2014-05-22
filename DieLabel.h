//
//  DieLabel.h
//  Frarkle
//
//  Created by Blake Mitchell on 5/21/14.
//  Copyright (c) 2014 Blake Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DieLabelDelegate
- (void)didChooseDie:(id)dieLabel;
@end

@interface DieLabel : UILabel
@property id <DieLabelDelegate> delegate;
@property NSInteger value;
@property BOOL isSelected;
- (void)roll;
@end
