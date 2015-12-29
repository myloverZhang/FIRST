//
//  TRContactInfoViewController.m
//  day75_CoreData_Auto
//
//  Created by hzxsdz0045 on 15/12/29.
//  Copyright © 2015年 SSF. All rights reserved.
//

#import "TRContactInfoViewController.h"

@interface TRContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *SignLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInfoLabel;

@end

@implementation TRContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.contact.name;
    self.SignLabel.text = self.contact.signature;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
