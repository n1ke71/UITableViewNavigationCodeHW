//
//  FileManager.m
//  UITableViewNavigationCodeHW
//
//  Created by Ivan Kozaderov on 09.07.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (NSFileManager *) sharedManager{
    
    static NSFileManager * sharedManager;    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [NSFileManager defaultManager];
    });
    return sharedManager;
    
}


- (void)contentsAtPath:(NSString *)path{
    
    NSError *error = nil;
    self.contents = [[FileManager sharedManager] contentsOfDirectoryAtPath:path error:&error];
    self.path = path;
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
}
- (BOOL)createFolderWithName:(NSString *)folderName{
    
    NSError *error = nil;
    BOOL   isAdded = NO;
    
    isAdded = [[FileManager sharedManager] createDirectoryAtPath:[self.path stringByAppendingPathComponent:folderName]
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        isAdded = NO;
    }
    
    
    return isAdded;
}

- (BOOL)deleteFolderAtPath:(NSString *)path{
    
    NSError* error = nil;
    BOOL   isRemoved = NO;
    isRemoved = [[FileManager sharedManager] removeItemAtPath:path  error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        isRemoved = NO;
    }
    
    return isRemoved;
    
}

- (BOOL)isDirectoryAtIndexPath:(NSUInteger)indexPath{
    
    NSString *fileName = [self.contents objectAtIndex:indexPath];
    BOOL isDidectory = NO;
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    NSLog(@"filePath%@",filePath);
    
    [[FileManager sharedManager] fileExistsAtPath:filePath isDirectory:&isDidectory];
    return isDidectory;
}

- (NSString *)sizeOfFile:(NSString *)filePath{
    
    NSDictionary *fileAttributes = [[FileManager sharedManager] attributesOfItemAtPath:filePath error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] integerValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return fileSizeStr;
}

- (NSString *)typeOfFile:(NSString *)filePath{
    
    NSDictionary *fileAttributes = [[FileManager sharedManager] attributesOfItemAtPath:filePath error:nil];
    BOOL isHidden = [[fileAttributes objectForKey:NSFileTypeBlockSpecial] boolValue];
    NSString *fileType = [NSString stringWithFormat:@"%d",isHidden? YES:NO];
    return fileType;
}
@end
