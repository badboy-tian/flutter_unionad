import { Any, BinaryMessenger, MethodChannel, PlatformView } from "@ohos/flutter_ohos";
import { common, UIAbility } from "@kit.AbilityKit";
import { ArrayList, HashMap } from "@kit.ArkTS";
import FlutterunionadViewConfig from "../FlutterunionadViewConfig";
import { SplashBuilder } from "./SplashNativeView";
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { window } from "@kit.ArkUI";
import SplashConstants from "./SplashConstants";

export default class SplashView extends PlatformView {
  mCodeId = "";
  viewWidth = 0.0
  viewHeight = 0.0
  timeout = 3000
  channel: MethodChannel

  constructor(context: common.Context, viewId: number, params: HashMap<string, Any>, messenger: BinaryMessenger, uIAbility: UIAbility) {
    super();

    console.log("SplashView ohosId: " + JSON.stringify(params))
    this.mCodeId = params["ohosId"] as string
    this.viewWidth = params["width"] as number
    this.viewHeight = params["height"] as number
    this.timeout = params["timeout"] as number
    this.channel = new MethodChannel(messenger, FlutterunionadViewConfig.view.splashAdView + "_" + viewId)

    SplashConstants.mCodeId = this.mCodeId
    SplashConstants.viewWidth = this.viewWidth
    SplashConstants.viewHeight = this.viewHeight
    SplashConstants.timeout = this.timeout
    SplashConstants.channel = this.channel
    SplashConstants.windowStage = uIAbility.context.windowStage
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(SplashBuilder)
  }

  dispose(): void {
  }
}