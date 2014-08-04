//
//  SQLiteDatabase.m
//  RevisedProCharge
//
//  Created by Ganesh Kulpe on 05/11/12.
//  Copyright (c) 2012 Mayur Chakor. All rights reserved.
//

#import "SQLiteDatabase.h"

@implementation SQLiteDatabase
- (id)initWithFilename:(NSString *)filename deleteEditableCopy:(BOOL)deleteCopy
{
    self = [super init];
	if (self)
    {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		_writableDBPath = [documentsDirectory stringByAppendingPathComponent:filename];
		[self createEditableCopyOfDatabaseIfNeeded:filename sourcePath:NULL deleteEditableCopy:deleteCopy];
		
		//NSLog(@" initWithFileName:  %@",_writableDBPath);
	}
	
	return self;
}


- (id)initWithFilePath:(NSString *)sourcePath editableName:(NSString *)filename deleteEditableCopy:(BOOL)deleteCopy
{
	self = [super init];
	if (self)
        
    {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		_writableDBPath = [documentsDirectory stringByAppendingPathComponent:filename];
		
		//NSLog(@" initWithFilePath:  %@",_writableDBPath);
		[self createEditableCopyOfDatabaseIfNeeded:filename sourcePath:sourcePath deleteEditableCopy:deleteCopy];
	}
	return self;
}


// Convenience function to initialize any static "sqlite3_stmt"s.
- (BOOL)initializeStatement:(sqlite3_stmt **)statement withSQL:(const char*)sql
{
	if (*statement == nil)
	{
		if (sqlite3_prepare_v2(database, sql, -1, statement, NULL) != SQLITE_OK) //
        {
			
			//NSLog(@"Error while preparing statement %d ",sqlite3_prepare_v2(database, sql, -1, statement, NULL));
			return NO;
		}
	}
	return YES;
}

// Convenience function to execute DELETE, UPDATE, and INSERT statements.
- (BOOL)executeUpdate:(sqlite3_stmt *)statement
{
	BOOL resultCode = [self executeStatement:statement success:SQLITE_DONE];
	sqlite3_reset(statement);
	return resultCode;
}

// Convenience function to execute SELECT statements.
// You must call sqlite3_reset after you're done.
- (BOOL)executeSelect:(sqlite3_stmt *)statement
{
	return [self executeStatement:statement success:SQLITE_ROW];
}

// Convenience function to execute COUNT statements.
// You must call sqlite3_reset after you're done.
- (BOOL)executeCount:(sqlite3_stmt *)statement
{
	return [self executeStatement:statement success:SQLITE_ROW];
}

- (BOOL)executeStatement:(sqlite3_stmt *)statement success:(int)successConstant
{
	int success = sqlite3_step(statement);
    
	if (success != successConstant)
    {
		return NO;
	}
	return YES;
}

- (int)executeintQuery:(sqlite3_stmt *)statement
{
	int resultCode = [self executeStatement:statement success:SQLITE_DONE];
	sqlite3_reset(statement);
	return resultCode;
}

/*
 
 * Creates a writable copy of the bundled default database in the application Documents directory.
 * This makes sure that we can always write to the database if necessary.
 *
 * Source path is optional if the source file is not in the main bundle path
 */
- (void)createEditableCopyOfDatabaseIfNeeded:(NSString*)databaseFilename sourcePath:(NSString*)sourcePath deleteEditableCopy:(BOOL)deleteCopy
{
    // First, test for existence.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:_writableDBPath];
	////NSLog(" File path is  %@",fileManager);
    NSError *error;
    
    if (success)
    {
        // Delete the current copy if requested
        if (deleteCopy)
        {
            if (![fileManager removeItemAtPath:_writableDBPath error:&error])
			{
				
			}
        }
        else
        {
            return;
        }
    }
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = sourcePath;
    if (!sourcePath)
	{
        defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseFilename];
    }
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:_writableDBPath error:&error];
    if (!success)
	{
		
	}
}

//- (void)dealloc
//{
//    if (sqlite3_close(database) != SQLITE_OK)
//	{
//        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
//    }
//	[super dealloc];
//}


@end
