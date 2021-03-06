#import "SCAsyncTestCase.h"

static SCReadItemScopeType scope_ = SCReadItemParentScope;

@interface ReadItemsPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsPTestAuth

-(void)testReadItemPAllowedItemNotAllowedParentWithAllFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;

    NSString* path_ = @"/sitecore/content/Home/Not_Allowed_Parent/Allowed_Item";

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                            fieldsNames: nil ];
            request_.scope = scope_;
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                {
                    items_auth_ = result_items_;
                    didFinishCallback_();
                });
            } );
        };
        
         [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_auth_ = items_auth_[ 0 ];
    //test item
    {
        GHAssertTrue( item_auth_.parent == nil, @"OK" );
        GHAssertTrue( [ item_auth_.displayName isEqualToString: @"Not_Allowed_Parent" ], @"OK" );
        
        GHAssertTrue( item_auth_.allChildren == nil, @"OK" );
        GHAssertTrue( item_auth_.allFields != nil, @"OK" );
        GHAssertTrue( [ item_auth_.readFields count ] ==
                     [ item_auth_.allFields count ], @"OK" );
    }

}

-(void)testReadItemPNotAllowedItemAllowedParentWithNoFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Home/Allowed_Parent/Not_Allowed_Item";
    
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                            fieldsNames: nil ];
            request_.scope = scope_;
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_ = result_items_;
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword
                                                               version: SCWebApiV1 ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
                {
                    items_auth_ = result_items_;
                    didFinishCallback_();
                });
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_: %@", items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_auth_ = items_auth_[ 0 ];
    //test item
    {
        GHAssertTrue( item_auth_.parent == nil, @"OK" );
        GHAssertTrue( [ item_auth_.displayName isEqualToString: @"Allowed_Parent" ], @"OK" );
        GHAssertTrue( item_auth_.allChildren == nil, @"OK" );
        GHAssertTrue( item_auth_.allFields != nil, @"OK" );
    }

}

@end