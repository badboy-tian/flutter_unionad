import { Any, EventChannel, FlutterPlugin, FlutterPluginBinding, StandardMessageCodec } from '@ohos/flutter_ohos';

import { EventSink, StreamHandler, } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import FlutterunionadViewConfig from './FlutterunionadViewConfig';

import SplashAdViewFactory from './splash/SplashAdViewFactory';
import { window } from '@kit.ArkUI';

export default class FlutterUnionadViewPlugin {
  static register(binding: FlutterPluginBinding, window: window.WindowStage) {
    //spalsh广告
    let splashAdViewFactory = new SplashAdViewFactory(binding, window);
    binding.getPlatformViewRegistry().registerViewFactory(FlutterunionadViewConfig.view.splashAdView, splashAdViewFactory)
  }
}