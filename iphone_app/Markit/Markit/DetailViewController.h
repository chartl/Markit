//
//  DetailViewController.h
//  Markit
//
//  Created by Christopher Hartl on 10/11/13.
//  Copyright (c) 2013 Markit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
