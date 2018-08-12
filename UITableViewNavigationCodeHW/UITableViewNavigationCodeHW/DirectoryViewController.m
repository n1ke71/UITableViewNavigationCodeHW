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

@property (strong, nonatomic) FileManager *fileManager;

@end

@implementation DirectoryViewController

- (id)initWithFolderPath:(NSString *) path{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        self.fileManager = [[FileManager alloc]init];
        self.fileManager.path = path;
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItems = [self makeItemsArray];
    
}

#pragma mark - Actions

- (NSArray *)makeItemsArray{
    
    UIBarButtonItem *itemRoot = [[UIBarButtonItem alloc]initWithTitle:@"Root"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionBackToRoot:)];
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc]initWithTitle:@"Add"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionAddFolder:)];
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                               style:UIBarButtonItemStylePlain
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

    [self presentViewController:[self folderNameAlertController] animated:YES completion:nil];
}

- (void)actionEdit:(UIBarButtonItem *)sender{
    
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    sender.title = isEditing? @"Edit":@"Done";

}

- (UIAlertController *)folderNameAlertController{

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New folder name"
                                                                         message:@"Enter name"
                                                                  preferredStyle:UIAlertControllerStyleAlert];

[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    
    textField.placeholder = @"New folder name";
    [textField becomeFirstResponder];
}];
UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
  UITextField *field = [alertController.textFields firstObject];

  [self.fileManager createFolderWithName:field.text];
  [self.tableView reloadData];
  field.text = @"";
  [field resignFirstResponder];

 }];

UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                      
 UITextField *field = [alertController.textFields firstObject];
 field.text = @"";
}];

[alertController addAction:actionCancel];
[alertController addAction:actionOK];

    return alertController;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fileManager.contents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSString *fileName = [self.fileManager.contents objectAtIndex:indexPath.row];
    cell.textLabel.text = fileName;
    
    if ([self.fileManager isDirectoryAtIndexPath:indexPath.row]) {
        
        cell.imageView.image = [UIImage imageNamed:@"folder"];
        cell.detailTextLabel.text = [self.fileManager sizeOfFolder:fileName];
    }
   else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
        cell.detailTextLabel.text = [self.fileManager sizeOfFile:fileName];
    }
    
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.fileManager isDirectoryAtIndexPath:indexPath.row]) {
        
        NSString *fileName = [self.fileManager.contents objectAtIndex:indexPath.row];
        NSString *path = [self.fileManager.path stringByAppendingPathComponent:fileName];
        DirectoryViewController *vc = [[DirectoryViewController alloc]initWithFolderPath:path];
        [self.navigationController pushViewController:vc animated:YES];
    }
 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
          NSString *fileName = [self.fileManager.contents objectAtIndex:indexPath.row];
          NSString *filePath = [self.fileManager.path stringByAppendingPathComponent:fileName];
          [self.fileManager deleteFolderAtPath:filePath];
          [self.tableView reloadData];
    }
}

@end
