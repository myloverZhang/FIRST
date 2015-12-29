//
//  TRAddContactViewController.m
//  day75_CoreData_Auto
//
//  Created by hzxsdz0045 on 15/12/28.
//  Copyright © 2015年 SSF. All rights reserved.
//

#import "TRAddContactViewController.h"

@interface TRAddContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (nonatomic,assign) BOOL isUpdate;
- (IBAction)CancelButton:(UIBarButtonItem *)sender;
- (IBAction)SaveButton:(UIBarButtonItem *)sender;

@end

@implementation TRAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.info != nil) {
        self.isUpdate = YES;
        self.nameTextField.text = self.info.name;
        self.signatureTextField.text = self.info.signature;
    }
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)CancelButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SaveButton:(UIBarButtonItem *)sender {
    if (self.isUpdate) {
        [self.delegate TRAddContactViewController:self updateTheContact:self.info WithName:self.nameTextField.text withSign:self.signatureTextField.text];
        self.info = nil;
        self.isUpdate = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self.delegate AddTheFrientByName:self.nameTextField.text andSign:self.signatureTextField.text];
    [self.navigationController popViewControllerAnimated:YES
     ];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
 }
@end
