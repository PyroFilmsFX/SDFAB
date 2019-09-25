//
//  PopOverView.h
//  popOverAppValley
//
//  Created by Justin on 10/15/18.
//  Copyright © 2018 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverView : UIView {
    NSDictionary *_remotePopOverInfo;
}

@property (nonatomic, retain) NSDictionary *remotePopOverInfo;

-(void)getRemote;
-(void)prePopOver;

@end
