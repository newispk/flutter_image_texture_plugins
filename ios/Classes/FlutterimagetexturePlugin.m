#import "FlutterimagetexturePlugin.h"
#import "DuiaflutterextexturePresenter.h"

NSObject<FlutterTextureRegistry> *textures;
NSMutableDictionary<NSNumber *, DuiaflutterextexturePresenter *> *renders;
@interface FlutterimagetexturePlugin()
@property (nonatomic, copy) FlutterResult result;
@property (nonatomic, assign) int64_t textureId;
@end
@implementation FlutterimagetexturePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterimagetexturePlugin *plugin = [[FlutterimagetexturePlugin alloc] init];
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"FlutterImageTexture" binaryMessenger:registrar.messenger];
    [registrar addMethodCallDelegate:plugin channel:channel];
    renders = [[NSMutableDictionary alloc] init];
    textures = registrar.textures;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if([call.method isEqualToString:@"load"]){
        self.result = result;
        NSString *imageUrl = call.arguments[@"url"];
        Boolean asGif = [call.arguments[@"asGif"] boolValue];
        DuiaflutterextexturePresenter *render = [[DuiaflutterextexturePresenter alloc] initWithImageStr:imageUrl asGif:asGif];
        int64_t textureId = [textures registerTexture:render];
        self.textureId = textureId;
        render.updateBlock = ^(CGSize size) {
            [textures textureFrameAvailable:textureId];
            if(size.width > 0 && size.height > 0)
            {
                self.result(@{@"textureId":@(self.textureId),@"width":@(size.width?:0),@"height":@(size.height?:0)});
            }
        };
        [renders setObject:render forKey:[NSString stringWithFormat:@"%@",@(textureId)]];
      
    }else if([call.method isEqualToString:@"release"]){
        if (call.arguments[@"id"]!=nil && ![call.arguments[@"id"] isKindOfClass:[NSNull class]]) {
            DuiaflutterextexturePresenter *render = [renders objectForKey:call.arguments[@"id"]];
            [renders removeObjectForKey:call.arguments[@"id"]];
            [render dispose];
            NSString *textureId =  call.arguments[@"id"];
        
            [textures unregisterTexture:@([call.arguments[@"id"] integerValue]).longValue];
        }
    }else {
        result(FlutterMethodNotImplemented);
      }
}
@end
