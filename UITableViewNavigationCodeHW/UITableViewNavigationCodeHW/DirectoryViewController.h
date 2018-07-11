//
//  DirectoryViewController.h
//  UITableViewNavigationCodeHW
//
//  Created by Ivan Kozaderov on 09.07.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryViewController : UITableViewController

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSArray *contents;

- (id)initWithFolderPath:(NSString *) path;

@end
