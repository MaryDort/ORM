//
//  MADDataBaseManager.h
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libpq-fe.h"

@interface MADDataBaseManager : NSObject {
    PGconn *conn;
}

@property (copy, nonatomic, readonly) NSString *databaseFilename;

+ (MADDataBaseManager *)sharedManager;

- (NSInteger)lastInsertedRowID:(NSString *)amount;
- (PGresult *)executeQuery:(NSString *)query;
- (NSArray *)executeSelectQuery:(NSString *)query;

@end