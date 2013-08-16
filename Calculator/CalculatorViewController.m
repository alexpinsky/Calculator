//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Alex Pinsky on 8/2/13.
//  Copyright (c) 2013 Alex Pinsky. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import <Foundation/NSRegularExpression.h>


@interface CalculatorViewController ()
@property (nonatomic) Boolean isUserTyping;
@property (nonatomic, strong) CalculatorBrain *brain;

- (Boolean)isValidNumber:(NSString *)number;
- (void)updateBackTrace:(NSString *)input;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize backTrace;
@synthesize isUserTyping;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    NSString *newDisplay;
    if (self.isUserTyping) {
        // if in the middle of typing append the new digit to the existing input
        newDisplay = [self.display.text stringByAppendingString:digit];
    } else {
        // if it's the beginnig of a new input, replace the existing       
        newDisplay = digit;
    }
    if (![self isValidNumber:newDisplay]) return; // not a float
    if (self.isUserTyping) {
        self.display.text = newDisplay;
    } else {
        self.display.text = digit;
        self.isUserTyping = true;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.isUserTyping) [self enterPressed];
    [self updateBackTrace:sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateBackTrace:self.display.text];
    self.isUserTyping = false;
}

- (IBAction)clearPressed:(id)sender
{
    self.isUserTyping = false;
    self.display.text = @"";
    self.backTrace.text = @"";
    [self.brain clear];
}

- (Boolean)isValidNumber:(NSString *)numberStr
{
    // it's not a valid number if it starts with '.'
    return [numberStr isEqualToString:@"."] ? false : true;
    NSError *error = nil;
    // define the regex
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\." options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:numberStr options:0 range:NSMakeRange(0, [numberStr length])];
    return numberOfMatches > 1 ? false : true;
}

- (void)updateBackTrace:(NSString *)input
{
    NSString *newBackTrace = [self.backTrace.text stringByAppendingString:[input stringByAppendingString:@" "]];
    if (newBackTrace.length > 50) {
        // clean the back trace          
        self.backTrace.text = input;
    } else {
        self.backTrace.text = newBackTrace;
    }
}

@end
