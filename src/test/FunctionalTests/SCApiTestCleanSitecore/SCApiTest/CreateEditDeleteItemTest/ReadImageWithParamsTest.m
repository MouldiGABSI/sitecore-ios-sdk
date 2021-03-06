#import "SCAsyncTestCase.h"

@interface ReadImageWithParamsTest : SCAsyncTestCase
@end

@implementation ReadImageWithParamsTest


-(void)testCreateAndReadImageWithPAramsAndCacheDapendFromParams
{
    __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
    apiContext_.defaultDatabase = @"web";

//    static NSString* const MEDIA_ITEM_PATH = @"/sitecore/media library/test data/create edit delete media/testmediaitem 4";

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];

        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;

        [ apiContext_ mediaItemCreatorWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
            media_item_ = item_;
            didFinishCallback_();
        } );

    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
    
    
    __block UIImage *readedImage = nil;
    
    if ( media_item_ )
    {
    
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCFieldImageParams *params = [ SCFieldImageParams new ];
            params.width = 10.f;
            params.height = 10.f;
            
            [ apiContext_ imageLoaderForSCMediaPath: /*MEDIA_ITEM_PATH*/ media_item_.path
                                        imageParams: params ]( ^( UIImage* image, NSError* read_error_ )
            {
                readedImage = image;
               
                didFinishCallback_();
                
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
        
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( readedImage.size.height == 10.f , @"OK" );
        GHAssertTrue( readedImage.size.width == 10.f , @"OK" );
        
        void (^read_block1_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCFieldImageParams *params = [ SCFieldImageParams new ];
            params.width = 15.f;
            params.height = 15.f;
            
            [ apiContext_ imageLoaderForSCMediaPath: media_item_.path
                                        imageParams: params ]( ^( UIImage* image, NSError* read_error_ )
            {
              readedImage = image;
              
              didFinishCallback_();
              
            } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block1_
                                               selector: _cmd ];
        
        GHAssertTrue( apiContext_ != nil, @"OK" );
        
        //first item:
        GHAssertTrue( readedImage.size.height == 15.f , @"OK" );
        GHAssertTrue( readedImage.size.width == 15.f , @"OK" );
    }
}

-(void)testCreateAndReadImageWithScale
{
    __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        
        [ apiContext_ mediaItemCreatorWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
        {
          media_item_ = item_;
          didFinishCallback_();
        } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
    
    
    __block UIImage *readedImage = nil;
    
    if ( media_item_ )
    {
    
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCFieldImageParams *params = [ SCFieldImageParams new ];
            params.scale = 2.f;
            
            [ apiContext_ imageLoaderForSCMediaPath: media_item_.path
                                        imageParams: params ]( ^( UIImage* image, NSError* read_error_ )
              {
                  readedImage = image;
                  didFinishCallback_();
              } );
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( readedImage.size.height == 114.f , @"OK" );
    GHAssertTrue( readedImage.size.width == 114.f , @"OK" );
    
}

-(void)testCreateAndReadImageAsThumbnail
{
    __block SCApiContext* apiContext_;
    __block SCItem* media_item_ = nil;
    apiContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                  login: SCWebApiAdminLogin
                                               password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    apiContext_.defaultSite = @"/sitecore/shell";
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        
        request_.fileName      = @"auto tests.png";
        request_.itemName      = @"TestMediaItem";
        request_.itemTemplate  = @"System/Media/Unversioned/Image";
        request_.mediaItemData = UIImagePNGRepresentation( [ UIImage imageNamed: request_.fileName ] );
        request_.fieldNames    = [ NSSet new ];
        request_.contentType   = @"image/png";
        request_.folder        = SCCreateMediaFolder;
        
        [ apiContext_ mediaItemCreatorWithRequest: request_ ]( ^( SCItem* item_, NSError* error_ )
          {
              media_item_ = item_;
              didFinishCallback_();
          } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    GHAssertTrue( media_item_ != nil, @"Item not created" );
    
    
    __block UIImage *readedImage = nil;
    
    if ( media_item_ )
    {
        void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            
            SCFieldImageParams *params = [ SCFieldImageParams new ];
            params.displayAsThumbnail = YES;
            
            [ apiContext_ imageLoaderForSCMediaPath: media_item_.path
                                        imageParams: params ]( ^( UIImage* image, NSError* read_error_ )
              {
                  readedImage = image;
                  didFinishCallback_();
              } );
        };
        
        
        
        [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //first item:
    GHAssertTrue( readedImage.size.height == 150.f , @"OK" );
    GHAssertTrue( readedImage.size.width == 150.f , @"OK" );
    
}

@end