//
//  ZooResponseImageModel.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooResponseImageModel : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *size;

- (instancetype)initWithResponse: (NSURLResponse *)response data:(NSData *) data;
@end

NS_ASSUME_NONNULL_END
