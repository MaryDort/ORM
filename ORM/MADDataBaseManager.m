//
//  MADDataBaseManager.m
//  ORM
//
//  Created by Mariia Cherniuk on 28.02.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADDataBaseManager.h"
#import "MADExceptions.h"

@implementation MADDataBaseManager

+ (MADDataBaseManager *)sharedManager {
    static MADDataBaseManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MADDataBaseManager alloc] initWithDatabaseFilename:@"dbORM"];
    });
    
    return _sharedManager;
}

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename {
    self = [super init];
    
    if (self) {
        _databaseFilename = dbFilename;
        conn = [self connect];
    }
    
    return self;
}

- (void)dealloc {
    PQfinish(conn);
}

- (PGconn *)connect {
    NSString *admin = @"admin";
    NSString *password = @"12345";
    
    conn = PQsetdbLogin(NULL, NULL, NULL, NULL, _databaseFilename.UTF8String, admin.UTF8String,
                                                                        password.UTF8String);
    if (PQstatus(conn) == CONNECTION_BAD) {
        @throw [[MADDatabaseException alloc] initWithName:@"DatabaseException"
                                                   reason:[NSString stringWithUTF8String:PQerrorMessage(conn)]
                                                 userInfo:nil];
    }
    
    return conn;
}

- (NSInteger)lastInsertedRowID:(NSString *)amount {
    NSString *query = [NSString stringWithFormat:@"SELECT CURRVAL('%@');", amount];
    NSDictionary *result = [[MADDataBaseManager sharedManager] executeSelectQuery:query].firstObject;
    
    return [result[@"currval"] integerValue];
}

- (PGresult *)executeQuery:(NSString *)query {
    PGresult *result = PQexec(conn, query.UTF8String);
    int status;
    
    if ((result == NULL) || ((status = PQresultStatus(result)) != PGRES_COMMAND_OK && (status != PGRES_TUPLES_OK))) {
        NSLog(@"%s", PQerrorMessage(conn));
    }
    
    return result;
}

- (NSArray *)executeSelectQuery:(NSString *)queryTable {
    NSMutableArray *rowsData = [NSMutableArray array];
    PGresult *result = [self executeQuery:queryTable];
    int status;
    
    if ((result != NULL) || ((status = PQresultStatus(result)) == PGRES_COMMAND_OK && (status == PGRES_TUPLES_OK))) {
        for (int row = 0; row < PQntuples(result); row++) {
            NSMutableDictionary *columnsData = [NSMutableDictionary dictionary];
            int totalColumns = PQnfields(result);
            
            for (int col = 0; col < totalColumns; col++) {
                char *dataAsText = PQgetvalue(result, row, col);
                char *columnName = PQfname(result, col);
                NSString *key = [NSString stringWithUTF8String:columnName];
                NSString *value = [NSString stringWithUTF8String:dataAsText];
                
                columnsData[key] = value;
            }
            [rowsData addObject:columnsData];
        }
    }
    PQclear(result);
    
    return rowsData;
}

@end
