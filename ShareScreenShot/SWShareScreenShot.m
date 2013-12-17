//
//  SWShareScreenShot.m
//  ShareScreenShot
//
//  Created by Snow on 12/16/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "SWShareScreenShot.h"
#import "SWAppDelegate.h"

@implementation SWShareScreenShot

@synthesize images = _images;

+ (SWShareScreenShot*)shareManager{
    /*
        GCD for ARC
     */
    static SWShareScreenShot *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}


- (UIImage*)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}





- (void)keepImageByCurrentViewController:(UIViewController*)viewController withName:(NSString*)name{
    
    if (self.images == nil) {
        _images = [NSMutableDictionary dictionary];
    }
    
    [_images setObject:[self screenshot] forKey:name];
    
}

- (void)removeImagesByName:(NSString *)name{
    if (self.images) {
        [self.images removeObjectForKey:name];
    }
}



- (UIViewController*)shareToSMSSheetByDelegate:(id)delegate withImage:(UIImage*)aImage{
    
    viewController = (UIViewController*)delegate;
    
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.messageComposeDelegate = delegate;
    
    //if ([messageVC respondsToSelector:@selector(canSendAttachments)]) {
        if ([MFMessageComposeViewController canSendAttachments]) {
            messageVC.subject = @"subject";
            messageVC.recipients = @[@"recipient"];
            messageVC.body = @"body";
            
            [messageVC addAttachmentData:UIImagePNGRepresentation(aImage)
                          typeIdentifier:@"public.data"
                                filename:@"fileName.png"];
      //  }
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device can't send MMS" delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return nil;
    }
    
    return messageVC;
}


- (UIViewController*)shareToEmailSheetByDelegate:(id)delegate withImage:(UIImage*)aImage{
    
    viewController = (UIViewController*)delegate;
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = delegate;
    
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device can't send email" delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return nil;
    }
    
    [picker setSubject:@"Hello from California!"];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"first@example.com",
                             nil];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com",
                             @"third@example.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com",
                              nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email.
    
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//    [picker addAttachmentData:myData mimeType:@"image/png"
//                     fileName:@"ipodnano"];
    UIImage *image = aImage;
    
    [picker addAttachmentData:UIImagePNGRepresentation(image)
                     mimeType:@"public.data"
                     fileName:@"fileName.png"];
    
    // Fill out the email body text.
    NSString *emailBody = @"It is raining in sunny California!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    
    return picker;
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    
    if (viewController) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    
    if (viewController) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
