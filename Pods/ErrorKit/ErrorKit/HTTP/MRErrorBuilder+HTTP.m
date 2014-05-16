// MRErrorBuilder+HTTP.m
//
// Copyright (c) 2013 Héctor Marqués
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MRErrorBuilder+HTTP.h"
#import "ErrorKitImports.h"

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#ifdef ERROR_KIT_HTTP

@implementation MRErrorBuilder (ErrorKit_HTTP)

- (NSURL *)failingURL
{
    return self.userInfo[NSURLErrorFailingURLErrorKey];
}

- (void)setFailingURL:(NSURL *)failingURL
{
    [self setUserInfoValue:failingURL.copy forKey:NSURLErrorFailingURLErrorKey];
}

- (SecTrustRef)failingURLPeerTrust
{
    return (__bridge SecTrustRef)(self.userInfo[NSURLErrorFailingURLPeerTrustErrorKey]);
}

- (void)setFailingURLPeerTrust:(SecTrustRef)failingURLPeerTrust
{
    [self setUserInfoValue:(__bridge id)failingURLPeerTrust forKey:NSURLErrorFailingURLPeerTrustErrorKey];
}

- (NSString *)failingURLString
{
    return self.userInfo[NSURLErrorFailingURLStringErrorKey];
}

- (void)setFailingURLString:(NSString *)failingURLString
{
    [self setUserInfoValue:failingURLString.copy forKey:NSURLErrorFailingURLStringErrorKey];
}

@end


#pragma mark -
#pragma mark -


@implementation MRErrorBuilder (ErrorKit_HTTP_Helper)

- (BOOL)isHTTPError
{
#ifdef ERROR_KIT_AFNETWORKING
    if ([self.domain isEqualToString:AFNetworkingErrorDomain]) {
        return YES;
    }
#endif
    return [self.domain isEqualToString:NSURLErrorDomain];
}

@end

#endif
