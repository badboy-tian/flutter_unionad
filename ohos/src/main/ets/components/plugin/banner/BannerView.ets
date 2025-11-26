import { Any, BinaryMessenger, MethodChannel, PlatformView } from "@ohos/flutter_ohos";
import { common, UIAbility } from "@kit.AbilityKit";
import { ArrayList, HashMap } from "@kit.ArkTS";
import FlutterunionadViewConfig from "../FlutterunionadViewConfig";
import { BannerBuilder } from "./BannerNativeView";
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import BannerConstants from "./BannerConstants";

export default class BannerView extends PlatformView {
  mCodeId = "";
  viewWidth = 0.0
  viewHeight = 0.0
  acceptWidth = 0.0
  acceptHeight = 0.0
  channel: MethodChannel

  constructor(context: common.Context, viewId: number, params: HashMap<string, Any>, messenger: BinaryMessenger, uIAbility: UIAbility) {
    super();

    console.log("BannerView ohosId: " + JSON.stringify(params))
    this.mCodeId = params["ohosId"] as string
    this.viewWidth = params["width"] as number
    this.viewHeight = params["height"] as number
    this.acceptWidth = params["acceptWidth"] as number
    this.acceptHeight = params["acceptHeight"] as number
    this.channel = new MethodChannel(messenger, FlutterunionadViewConfig.view.bannerAdView + "_" + viewId)

    BannerConstants.mCodeId = this.mCodeId
    BannerConstants.viewWidth = this.viewWidth
    BannerConstants.viewHeight = this.viewHeight
    BannerConstants.acceptWidth = this.acceptWidth
    BannerConstants.acceptHeight = this.acceptHeight
    BannerConstants.channel = this.channel
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(BannerBuilder)
  }

  dispose(): void {
  }
}
