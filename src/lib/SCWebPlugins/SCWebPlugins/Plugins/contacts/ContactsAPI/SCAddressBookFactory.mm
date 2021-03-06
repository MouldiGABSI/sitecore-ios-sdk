#import "SCAddressBookFactory.h"

#import "SCAddressBook.h"

using namespace ::Utils;

@implementation SCAddressBookFactory

+(void)asyncAddressBookWithOnCreatedBlock:( SCAddressBookOnCreated )callback_
{
    NSParameterAssert( nil != callback_ );
    
    CFErrorRef error_ = NULL;
    ABAddressBookRef result_ = ABAddressBookCreateWithOptions( 0, &error_ );
    ObjcScopedGuard rawBookGuard_( ^()
    {
        callback_( nil, ::ABAddressBookGetAuthorizationStatus(), (__bridge NSError*)error_ );

        if ( NULL != result_ )
        {
            CFRelease( result_ );
        }
    } );

    
    if ( NULL != error_ )
    {
        NSLog( @"[!!!ERROR!!!] - ABAddressBookCreateWithOptions : %@", (__bridge NSError*)error_ );
        return;
    }
    

    SCAddressBook* bookWrapper_ = [ [ SCAddressBook alloc ] initWithRawBook: result_ ];
    ABAddressBookRequestAccessCompletionHandler onAddressBookAccess_ =
        ^( bool blockGranted_, CFErrorRef blockError_ )
        {
            NSError* retError_ = (__bridge NSError* )(blockError_);

            callback_( bookWrapper_, ::ABAddressBookGetAuthorizationStatus(), retError_ );
        };

    rawBookGuard_.Release();
    ABAddressBookRequestAccessWithCompletion( result_, onAddressBookAccess_ );
}

+(NSString*)bookStatusToString:( ABAuthorizationStatus) status_
{
    static NSArray* const errors_ =
    @[
        @"kABAuthorizationStatusNotDetermined",
        @"kABAuthorizationStatusRestricted",
        @"kABAuthorizationStatusDenied",
        @"kABAuthorizationStatusAuthorized"
    ];

    if ( status_ > kABAuthorizationStatusAuthorized )
    {
        return nil;
    }

    return errors_[ static_cast<NSUInteger>( status_ ) ];
}

+(void)asyncAddressBookWithSuccessBlock:( SCAddressBookSuccessCallback )onSuccess_
                          errorCallback:( SCAddressBookErrorCallback )onFailure_
{
    NSParameterAssert( nil != onSuccess_ );
    NSParameterAssert( nil != onFailure_ );
    
    [ self asyncAddressBookWithOnCreatedBlock:
     ^void(SCAddressBook* book_, ABAuthorizationStatus status_, NSError* error_)
     {
         if ( kABAuthorizationStatusAuthorized != status_ )
         {
             onFailure_( status_, error_ );
         }
         else
         {
             onSuccess_( book_ );
         }
     } ];
}


@end
