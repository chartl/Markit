//
//  Data.h
//  Weather
//
//  Created by Ilias Beshimov on 10/11/13.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (strong) NSString *title;

- (id)initWithTitle:(NSString*)title;

@end