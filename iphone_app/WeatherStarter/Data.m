//
//  Data.m
//  Weather
//
//  Created by Ilias Beshimov on 10/11/13.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "Data.h"

@implementation Data

@synthesize title = _title;

- (id)initWithTitle:(NSString*)title {
    if ((self = [super init])) {
        self.title = title;
    }
    return self;
}

@end