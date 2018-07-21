//
//  FileManager.h
//  UITableViewNavigationCodeHW
//
//  Created by Ivan Kozaderov on 09.07.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSArray *contents;

- (BOOL)isDirectoryAtIndexPath:(NSUInteger)indexPath;
- (void)createFolderWithName:(NSString *)folderName;
- (void)deleteFolderAtPath:(NSString *)path;
- (NSString *)sizeOfFile:(NSString *)fileName;
- (NSString *)sizeOfFolder:(NSString *)folderName;
@end
