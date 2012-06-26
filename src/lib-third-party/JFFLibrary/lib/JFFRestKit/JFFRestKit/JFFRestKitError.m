#import "JFFRestKitError.h"

@implementation JFFRestKitError

-(id)init
{
    return [ super initWithDescription: NSLocalizedString( @"REST_KIT_BASE_ERROR", nil ) ];
}

@end

@implementation JFFRestKitNoURLError

-(id)init
{
    return [ super initWithDescription: NSLocalizedString( @"REST_KIT_NO_URL_ERROR", nil ) ];
}

@end
