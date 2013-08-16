//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Alex Pinsky on 8/2/13.
//  Copyright (c) 2013 Alex Pinsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clear;

@end
