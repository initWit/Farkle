//
//  DieLabel.m
//  Frarkle
//
//  Created by Blake Mitchell on 5/21/14.
//  Copyright (c) 2014 Blake Mitchell. All rights reserved.
//

#import "DieLabel.h"


@implementation DieLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (IBAction)onTapped:(id)sender
{
    [self.delegate didChooseDie:self];
    self.backgroundColor = [UIColor blueColor];
}

- (void)roll
{
    self.text = [NSString stringWithFormat:@"%i", arc4random_uniform(6) + 1];
    self.value = [self.text intValue];
}


@end
