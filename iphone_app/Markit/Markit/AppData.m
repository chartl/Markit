//
//  AppData.h
//

#import "AppData.h"

@implementation AppData

@synthesize name = _name;
@synthesize iconImage = _iconImage;
@synthesize appUrl = _appUrl;

- (id)initWithTitle:(NSString*)name iconImage:(UIImage *)iconImage appUrl:(NSString *)appUrl {
    if ((self = [super init])) {
        self.name = name;
        self.iconImage = iconImage;
        self.appUrl = appUrl;
    }
    return self;
}

@end
