//
//  PopOverView.m
//  popOverAppValley
//
//  Created by Justin on 10/15/18.
//  Copyright © 2018 Justin. All rights reserved.
//

#import "PopOverView.h"

#define kPopOverRemoteURL @"https://examp.le/config.json"
//Example remote JSON file format
//{
//"displayTime": 10.0,
//"linkContents": {
//        "1": {
//            "name": "Example",
//            "link": "https://examp.le",
//            "iconLink": "https://examp.le/example.png",
//            "color": "orange"
//        },
//        "2": {
//            "name": "Twitter",
//            "link": "https://twitter.com/appvalley_vip",
//            "iconLink": "https://examp.le/twitterTransparent.png",
//            "color": "blue"
//        }
//    }
//}

@implementation UIViewController (UIViewController)
+ (UIViewController*)topMostController { //topMostController
    return [UIViewController topMostControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topMostControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topMostControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topMostControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topMostControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
@end

@implementation PopOverView

bool popOverOut = FALSE;

@synthesize remotePopOverInfo = _remotePopOverInfo;

- (void)getRemote {
    NSError *error;
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kPopOverRemoteURL]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"popOverInfo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        _remotePopOverInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    if (error) {
        NSLog(@"%@", error);
    }
}



- (void)prePopOver {
    NSInteger viewTime = [_remotePopOverInfo[@"displayTime"] integerValue];
    if (viewTime != 0.0 && [_remotePopOverInfo[@"linkContents"] isKindOfClass:[NSDictionary class]]) {
        UIButton *preButton = [[UIButton alloc] initWithFrame:CGRectMake([UIViewController topMostController].view.frame.size.width - 60, [UIViewController topMostController].view.frame.size.height - 60, 40, 40)];
        UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake([UIViewController topMostController].view.frame.size.width - 60, [UIViewController topMostController].view.frame.size.height - 60, 40, 40)];
        
        UIImage *btnImage = [UIImage imageNamed:@"plus"];
        
        [postButton setImage:btnImage forState:0];
        postButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        [preButton setBackgroundColor:[UIColor colorWithRed:0.61 green:0.81 blue:0.99 alpha:1.0]]; //#9BCEFD
        
        preButton.layer.cornerRadius = 20;
        
        preButton.layer.shadowColor = [UIColor blackColor].CGColor;
        preButton.layer.shadowOffset = CGSizeMake(0, 3);
        preButton.layer.shadowOpacity = 0.25;
        preButton.layer.shadowRadius = 1.0;
        preButton.layer.masksToBounds = NO;
        
        [postButton addTarget:self action:@selector(showHidePopover:) forControlEvents:(UIControlEventTouchUpInside)];
        [[UIViewController topMostController].view addSubview:preButton];
        [[UIViewController topMostController].view addSubview:postButton];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * viewTime), dispatch_get_main_queue(), ^(void){
            [self hidePopOver];
            [UIView animateWithDuration:0.5f animations:^{
                [preButton setAlpha:0.0f];
                [postButton setAlpha:0.0f];
            } completion:^(BOOL finished){
                [preButton removeFromSuperview];
                [postButton removeFromSuperview];
            }];
        });
    }
}

- (void)showPopOver {
    if ([_remotePopOverInfo[@"linkContents"] isKindOfClass:[NSDictionary class]]) {
        for (id key in _remotePopOverInfo[@"linkContents"]) {
            if ([[self.remotePopOverInfo[@"linkContents"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                NSInteger i = [key integerValue];
                UIButton *linkButton = [[UIButton alloc] initWithFrame:CGRectMake([UIViewController topMostController].view.frame.size.width - 45, [UIViewController topMostController].view.frame.size.height - (30 * i) - 50, 10, 10)];
                
                NSURL *url = [NSURL URLWithString:[self.remotePopOverInfo[@"linkContents"] objectForKey:key][@"iconLink"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                [linkButton setImage:image forState:0];
                
                linkButton.imageView.clipsToBounds = YES;
                linkButton.imageView.layer.masksToBounds = YES;
                linkButton.imageView.layer.cornerRadius = 5;
                
                linkButton.tag = i;
                linkButton.layer.cornerRadius = 5;
                
                linkButton.layer.shadowColor = [UIColor blackColor].CGColor;
                linkButton.layer.shadowOffset = CGSizeMake(0, 3);
                linkButton.layer.shadowOpacity = 0.25;
                linkButton.layer.shadowRadius = 1.0;
                linkButton.layer.masksToBounds = NO;
                
                [linkButton addTarget:self action:@selector(openURL:) forControlEvents:(UIControlEventTouchUpInside)];
                [[UIViewController topMostController].view addSubview:linkButton];
                
                [linkButton setAlpha:0.0f];
                [UIView animateWithDuration:(0.25f * i) animations:^{
                    [linkButton setAlpha:1.0f];
                    linkButton.layer.cornerRadius = 15;
                    linkButton.imageView.layer.cornerRadius = 15;
                    linkButton.frame = CGRectMake([UIViewController topMostController].view.frame.size.width - 55, [UIViewController topMostController].view.frame.size.height - (40 * i) - 60, 30, 30);
                } completion:^(BOOL finished){
                    
                }];
            }
        }
    }
}

- (void)hidePopOver {
    for (id key in _remotePopOverInfo[@"linkContents"]) {
        NSInteger i = [key integerValue];
        UIButton *tmpButton = (UIButton *)[[UIViewController topMostController].view viewWithTag:i];
        
        [UIView animateWithDuration:(1.0f - (i * 0.25f)) animations:^{
            [tmpButton setAlpha:0.0f];
            tmpButton.layer.cornerRadius = 5;
            tmpButton.imageView.layer.cornerRadius = 5;
            tmpButton.frame = CGRectMake([UIViewController topMostController].view.frame.size.width - 45, [UIViewController topMostController].view.frame.size.height - (30 * i) - 50, 10, 10);
        } completion:^(BOOL finished){
            [tmpButton removeFromSuperview];
        }];
    }
}

- (IBAction)openURL:(UIButton*)sender {
    NSString *urlString = [_remotePopOverInfo[@"linkContents"] objectForKey:[NSString stringWithFormat:@"%li", (long)sender.tag]][@"link"];
    NSURL *currLink = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:currLink options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%@ opened", currLink);
    }];
}

- (IBAction)showHidePopover:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    
    if (popOverOut) {
        tempButton.userInteractionEnabled = false;
        [UIView animateWithDuration:0.50f animations:^{
            [tempButton setTransform:CGAffineTransformMakeRotation(M_PI * 4)];
        } completion:^(BOOL finished){
            tempButton.userInteractionEnabled = true;
        }];
        [self hidePopOver];
        popOverOut = false;
    } else if (!popOverOut) {
        tempButton.userInteractionEnabled = false;
        [UIView animateWithDuration:0.50f animations:^{
            [tempButton setTransform:CGAffineTransformMakeRotation(M_PI / 4)];
        } completion:^(BOOL finished){
            tempButton.userInteractionEnabled = true;
        }];
        [self showPopOver];
        popOverOut = true;
    }
}

@end
