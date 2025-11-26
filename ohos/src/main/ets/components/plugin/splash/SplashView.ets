import { Any, BinaryMessenger, MethodChannel, PlatformView } from "@ohos/flutter_ohos";
import { common } from "@kit.AbilityKit";
import { ArrayList, HashMap } from "@kit.ArkTS";
import FlutterunionadViewConfig from "../FlutterunionadViewConfig";
import { SplashBuilder } from "./SplashNativeView";
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { window } from "@kit.ArkUI";

export default class SplashView extends PlatformView {
  mCodeId = "";
  viewWidth = 0.0
  viewHeight = 0.0
  channel: MethodChannel
  window: window.WindowStage

  constructor(context: common.Context, viewId: number, params: HashMap<string, Any>, messenger: BinaryMessenger, window: window.WindowStage) {
    super();

    this.mCodeId = params["ohosId"] as string
    this.viewWidth = params["width"] as number
    this.viewHeight = params["height"] as number
    this.window = window
    this.channel = new MethodChannel(messenger, FlutterunionadViewConfig.view.splashAdView + "_" + viewId)
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder<[Params]>((params) => {
      return SplashBuilder(params, this.mCodeId, this.viewWidth, this.viewHeight, this.channel, this.window)
    })
  }


  dispose(): void {
  }
}