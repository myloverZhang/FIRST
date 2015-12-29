//
//  TRAddContactViewController.h
//  day75_CoreData_Auto
//
//  Created by hzxsdz0045 on 15/12/28.
//  Copyright © 2015年 SSF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@class TRAddContactViewController;
@protocol TRAddContactViewControllerDelegate <NSObject>

-(void)AddTheFrientByName:(NSString*)name andSign:(NSString*)sign;
-(void)TRAddContactViewController:(TRAddContactViewController*)self updateTheContact:(Contact*)contact WithName:(NSString*)name withSign:(NSString*)sign;
@end
@interface TRAddContactViewController : UIViewController
@property (weak,nonatomic) id<TRAddContactViewControllerDelegate> delegate;
@property (nonatomic,strong) Contact* info;
@end
