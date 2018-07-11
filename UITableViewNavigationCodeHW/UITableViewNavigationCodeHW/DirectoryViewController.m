//
//  DirectoryViewController.m
//  UITableViewNavigationCodeHW
//
//  Created by Ivan Kozaderov on 09.07.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "DirectoryViewController.h"
#import "FileManager.h"

@interface DirectoryViewController ()

@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) FileManager *fileManager;

@end

@implementation DirectoryViewController

- (id)initWithFolderPath:(NSString *) path{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        self.path = path;
        NSError *error = nil;
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];

        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.alertController = [self folderNameAlertController];
    self.navigationItem.rightBarButtonItems = [self makeItemsArray];
    
    
}

#pragma mark - Actions

- (NSArray *)makeItemsArray{
    
    UIBarButtonItem *itemRoot = [[UIBarButtonItem alloc]initWithTitle:@"Root"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionBackToRoot:)];
    
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionAddFolder:)];
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                             target:self
                                                                             action:@selector(actionEdit:)];
    
    
    return @[itemAdd,itemEdit,itemRoot];
}



- (void)actionBackToRoot:(UIBarButtonItem *)sender{
    
    if ([self.navigationController.viewControllers count] > 1){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)actionAddFolder:(UIBarButtonItem *)sender{

    [self presentViewController:self.alertController animated:YES completion:nil];
}
- (void)actionEdit:(UIBarButtonItem *)sender{
    
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    
}

- (UIAlertController *)folderNameAlertController{

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New folder name"
                                                                         message:@"Enter name"
                                                                  preferredStyle:UIAlertControllerStyleAlert];

[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    
    textField.placeholder = @"New folder name";
}];
UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
  UITextField *field = [alertController.textFields firstObject];
/*  FileManager *manager = [[FileManager alloc]init];
  [manager createFolderWithName:field.text];
  NSArray *currentContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:manager.path error:nil];
  manager.contents = [NSMutableArray arrayWithArray:currentContent];
  field.text = @"";
  [self.tableView reloadData];
                                                     */
 }];

UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];

[alertController addAction:actionCancel];
[alertController addAction:actionOK];

    return alertController;
}

- (BOOL)isDirectoryAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    BOOL isDidectory = NO;
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDidectory];
    return isDidectory;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.contents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    cell.textLabel.text = fileName;
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        cell.imageView.image = [UIImage imageNamed:@"folder"];
        //       cell.detailTextLabel.text = [self.fileManager sizeOfFile:filePath];
    }
   else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
   //     NSString *filePath = [self.fileManager.path stringByAppendingPathComponent:fileName];
    //    cell.detailTextLabel.text = [self.fileManager sizeOfFile:filePath];
    }
    
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        DirectoryViewController *vc = [[DirectoryViewController alloc]initWithFolderPath:path];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
  /*
        NSString* fileName = [self.fileManager.contents objectAtIndex:indexPath.row];
        NSString* filePath = [self.fileManager.path stringByAppendingPathComponent:fileName];
        [self.fileManager deleteFolderAtPath:filePath];
        NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.fileManager.path error:nil];
        self.fileManager.contents = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
  */
    }
}

@end
