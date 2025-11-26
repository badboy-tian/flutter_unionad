import { Any, FlutterPluginBinding, PlatformView, PlatformViewFactory, StandardMessageCodec } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import SplashView from './SplashView';
import { HashMap } from '@kit.ArkTS';
import { window } from '@kit.ArkUI';

export default class SplashAdViewFactory extends  PlatformViewFactory {
  binding?: FlutterPluginBinding;
  window?: window.WindowStage

  constructor(binding: FlutterPluginBinding, window: window.WindowStage) {
    super(StandardMessageCodec.INSTANCE);
    this.binding = binding;
    this.window = window;
  }

  public create(context: common.Context, viewId: number, args: Any): PlatformView {
    return new SplashView(context, viewId, args as HashMap<string, Any>, this.binding?.getBinaryMessenger()!, this.window!);
  }
}