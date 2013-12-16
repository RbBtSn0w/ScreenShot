//
//  SWShareScreenShot.h
//  ShareScreenShot
//
//  Created by Snow on 12/16/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWShareScreenShot : NSObject

@property (readonly, nonatomic, strong) NSMutableDictionary *images;

+ (SWShareScreenShot*)shareManager;
- (void)keepImageByCurrentViewController:(UIViewController*)viewController withName:(NSString*)name;
- (void)removeImagesByName:(NSString*)name;

@end
