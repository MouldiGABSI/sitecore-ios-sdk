#import "SCAsyncTestCase.h"

@interface ZRemoveAllNegativeItemsExtended : SCAsyncTestCase
@end

@implementation ZRemoveAllNegativeItemsExtended

static NSString* master_path_   = @"/sitecore/content/Test Data/Create Edit Delete Tests/Negative";
static NSString* web_path_      = @"/sitecore/layout/Layouts/Test Data/Negative Tests";
static NSString* media_path_    = @"/sitecore/media library/Test Data/Negative Media";

-(void)testRemoveAllItems
{
    __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSString* deleteResponse_ = @"";

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiSession sessionWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: master_path_ ];
        request_.scope = SCReadItemChildrenScope;
        
        SCDidFinishAsyncOperationHandler doneHandler =^( id response_, NSError* error_ )
        {
            deleteResponse_ = [ NSString stringWithFormat:@"%@", response_ ];
            SCReadItemsRequest* item_request_ = [ SCReadItemsRequest requestWithItemPath: master_path_ ];
            item_request_.scope = SCReadItemChildrenScope;
            item_request_.flags = SCReadItemRequestIngnoreCache;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* read_items_, NSError* read_error_ )
            {
                items_ = read_items_;
                NSLog( @"items: %@", items_ );
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession readItemsOperationWithRequest: item_request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    void (^deleteSystemBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiSession sessionWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCReadItemsRequest* request_ = 
        [ SCReadItemsRequest requestWithItemPath: @"/sitecore/system/Settings/Workflow/Test Data/Create Edit Delete Tests" ];
        request_.scope = SCReadItemChildrenScope;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id response_, NSError* error_ )
        {
            apiContext_.defaultDatabase = @"web";
            request_.request = web_path_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( id response_, NSError* error_ )
             {
                 request_.request = media_path_;
                 
                 SCDidFinishAsyncOperationHandler doneHandler2 = ^( id response_, NSError* error_ )
                  {
                      apiContext_.defaultDatabase = @"core";
                      request_.request = web_path_;
                      
                      
                      SCDidFinishAsyncOperationHandler doneHandler3 = ^( id response_, NSError* error_ )
                      {
                          request_.request = media_path_;
                          
                          SCDidFinishAsyncOperationHandler doneHandler4 = ^( id response_, NSError* error_ )
                          {
                              didFinishCallback_();
                          };
                          
                          SCExtendedAsyncOp loader4 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                          loader4(nil, nil, doneHandler4);
                      };
                      
                      SCExtendedAsyncOp loader3 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                      loader3(nil, nil, doneHandler3);
                  };
                 
                 SCExtendedAsyncOp loader2 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                 loader2(nil, nil, doneHandler2);
             };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };

    [ self performAsyncRequestOnMainThreadWithBlock: deleteSystemBlock_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];
}

@end
