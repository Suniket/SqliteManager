//
//  SQLiteDatabase.h
//  RevisedProCharge
//
//  Created by Ganesh Kulpe on 05/11/12.
//  Copyright (c) 2012 Mayur Chakor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SQLiteDatabase : NSObject
{
	NSString *_writableDBPath;
	
	sqlite3 *database;
}
-(id)initWithFilename:(NSString *)filename deleteEditableCopy:(BOOL)deleteCopy;
-(id)initWithFilePath:(NSString *)sourcePath editableName:(NSString *)filename deleteEditableCopy:(BOOL)deleteCopy;
-(BOOL)initializeStatement:(sqlite3_stmt **)statement withSQL:(const char*)sql;
- (void)createEditableCopyOfDatabaseIfNeeded:(NSString*)databaseFilename sourcePath:(NSString*)sourcePath deleteEditableCopy:(BOOL)deleteCopy;
- (BOOL)executeUpdate:(sqlite3_stmt *)statement;
- (BOOL)executeSelect:(sqlite3_stmt *)statement;
- (BOOL)executeCount:(sqlite3_stmt *)statement;
- (BOOL)executeStatement:(sqlite3_stmt *)statement success:(int)successConstant;
- (int)executeintQuery:(sqlite3_stmt *)statement;

@end
