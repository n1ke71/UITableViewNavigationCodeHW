//
//  FileManager.m
//  UITableViewNavigationCodeHW
//
//  Created by Ivan Kozaderov on 09.07.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (NSFileManager *)sharedManager{
    
    static NSFileManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [NSFileManager defaultManager];
    });
    return sharedManager;
}


- (void)setPath:(NSString *)path{
    
    NSError *error = nil;
    self.contents = [[FileManager sharedManager] contentsOfDirectoryAtPath:path error:&error];
    _path = path;
    
    if (error) {
        NSLog(@"Error:%@",[error localizedDescription]);
    }
    [self sortingContents];
}

- (BOOL)isDirectoryAtIndexPath:(NSUInteger)indexPath{
    
    NSString *fileName = [self.contents objectAtIndex:indexPath];
    BOOL isDidectory = NO;
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    [[FileManager sharedManager] fileExistsAtPath:filePath isDirectory:&isDidectory];
    return isDidectory;
}

- (void)createFolderWithName:(NSString *)folderName{
    
   
    [[FileManager sharedManager] createDirectoryAtPath:[self.path stringByAppendingPathComponent:folderName]
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:nil];
    
    [self setPath:self.path];
    
}

- (void)deleteFolderAtPath:(NSString *)filePath{
    
    [[FileManager sharedManager] removeItemAtPath:filePath  error:nil];
    [self setPath:self.path];
}

- (NSString *)sizeOfFile:(NSString *)fileName{
    
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    NSDictionary *fileAttributes = [[FileManager sharedManager] attributesOfItemAtPath:filePath error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] integerValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return fileSizeStr;
}

- (NSString *)sizeOfFolder:(NSString *)folderName{
    
    NSString *folderPath = [self.path stringByAppendingPathComponent:folderName];
    NSArray *contents = [[FileManager sharedManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long int folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[FileManager sharedManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }

    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}

- (BOOL)isHiddenFile:(NSString*)fileName {
    
    NSString* firstSymbol = [fileName substringToIndex:1];
    if ([firstSymbol isEqualToString:@"."]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)sortingContents{
 
    NSMutableArray* contents = [NSMutableArray array];
    for (NSString* fileName in self.contents) {
        if (![self isHiddenFile:fileName]) {
            [contents addObject:fileName];
        }
    }
    
    self.contents = contents;

    self.contents = [self.contents sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
        BOOL firstPath,secondPath;
        [[FileManager sharedManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:obj1] isDirectory:&firstPath];
        [[FileManager sharedManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:obj2] isDirectory:&secondPath];

        if ( firstPath && !secondPath) {
            return NSOrderedAscending;
        }else if ( !firstPath && secondPath){
            return NSOrderedDescending;
        }else {
           return [obj1 compare:obj2];
        }

    }];
    
}

@end
