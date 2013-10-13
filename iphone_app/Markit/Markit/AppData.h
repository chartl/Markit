//
//  AppData.h
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

@property (strong) NSString *name;
@property (strong) UIImage *iconImage;
@property (strong) NSString *appUrl;

- (id)initWithTitle:(NSString*)name iconImage:(UIImage *)iconImage appUrl:(NSString *)appUrl;

@end
