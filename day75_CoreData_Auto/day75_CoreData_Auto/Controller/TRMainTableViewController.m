//
//  TRMainTableViewController.m
//  day75_CoreData_Auto
//
//  Created by hzxsdz0045 on 15/12/28.
//  Copyright © 2015年 SSF. All rights reserved.
//

#import "TRMainTableViewController.h"
#import  <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "TRAddContactViewController.h"
#import "Contact.h"
#import "TRContactInfoViewController.h"
#define kDocumentDirectory NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
@interface TRMainTableViewController ()<NSFetchedResultsControllerDelegate,TRAddContactViewControllerDelegate,NSFetchedResultsControllerDelegate>
//上下文对象
@property (nonatomic,strong) NSManagedObjectContext* context;
//结果控制器
@property (nonatomic,strong) NSFetchedResultsController* resultController;

- (IBAction)addContact:(UIBarButtonItem *)sender;
- (IBAction)EditButton:(UIBarButtonItem *)sender;

@end

@implementation TRMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //验证
//    NSLog(@"%@",self.resultController);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.resultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.resultController.sections objectAtIndex:section];
    return  sectionInfo.numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FrientsCell" forIndexPath:indexPath];
    [self configCell:cell withIndexPath:indexPath];

    
    return cell;
}
-(void)configCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    Contact* contactFrient = [self.resultController objectAtIndexPath:indexPath];
    cell.textLabel.text = contactFrient.name;
    cell.detailTextLabel.text = contactFrient.signature;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Contact* contact = [self.resultController objectAtIndexPath:indexPath];
        NSError* error = nil;
        [self.context deleteObject:contact];
        if(![self.context save:&error]){
            NSLog(@"%@",error.userInfo);
        }
        
   }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Contact* theContact = [self.resultController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ToContactInfo" sender:theContact];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"....");
    TRAddContactViewController* update = [[TRAddContactViewController alloc]init];
    Contact* c = [self.resultController objectAtIndexPath:indexPath];
    update.info = c;
    [self performSegueWithIdentifier:@"add" sender:c];
}
- (IBAction)addContact:(UIBarButtonItem *)sender {
}

- (IBAction)EditButton:(UIBarButtonItem *)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}
#pragma mark - 懒加载
//获取
- (NSManagedObjectContext *) context {
	if(_context == nil) {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        _context = delegate.managedObjectContext;
	 	
    }
	return _context;
}
//创建
- (NSFetchedResultsController *) resultController {
	if(_resultController != nil) {
        return _resultController;
    }
    //结果控制器为空的创建逻辑
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    /**
     参数一：请求的对象
     参数二：上下文
     参数三：指定分区 section的原则（那一列的；名字一样  同一分区）
     参数四：缓存文件夹的名字
     */
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sort];
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"name" cacheName:@"CacheName"];
    _resultController.delegate = self;
    //执行request
    NSError* error = nil;
    if(![_resultController performFetch:&error]){
        NSLog(@"执行监听请求失败: %@",error.userInfo);
    }
    
	return _resultController;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"add"]) {
           TRAddContactViewController* add = segue.destinationViewController;
    add.delegate = self;
        if([sender isKindOfClass:[Contact class]]){
            add.info = (Contact*)sender;
        }
    }
    if ([segue.identifier isEqual:@"ToContactInfo"]) {
        Contact* info = (Contact*)sender;
        TRContactInfoViewController* info1 = [[TRContactInfoViewController alloc]init];
        info1.contact = info;
    }
 }
#pragma mark - TRAddContactViewControllerDelegate
-(void)AddTheFrientByName:(NSString *)name andSign:(NSString *)sign{
    Contact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.context];
    contact.name = name;
    contact.signature = sign;
    NSError* error = nil;
    if (![self.context save:&error]) {
        NSLog(@"插入失败：%@",error.userInfo);
    }
    
}
-(void)TRAddContactViewController:(TRAddContactViewController *)self updateTheContact:(Contact *)contact WithName:(NSString *)name withSign:(NSString *)sign{
      NSFetchRequest* requset = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name=%@ and signature=%@",contact.name,contact.signature];
    requset.predicate = predicate;
    NSError* error = nil;
    NSArray* results = [_context executeFetchRequest:requset error:&error];
    if(!error){
        for (Contact* result in results){
            result.name = name;
            result.signature = sign;
        }

    }else{
        NSLog(@"look error%@",error.userInfo);
        
    }
    if(![_context save:&error]){
        NSLog(@"%@",error.userInfo);
    }
}
#pragma mark - NSFetchedResultsControllerDelegate
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            //tableView调用插入方法
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove: {
            
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadData];
            break;
        }
        default: {
            break;
        }
    }
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  //          [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            
            [self configCell:[self.tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath];
            break;
        }
        default: {
            break;
        }
    }
}
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
    
}
@end
