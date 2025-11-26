import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { AdSlotBuilder, CSJAdSdk, CSJNativeExpressAd, ExpressAdInteractionListener, NativeExpressAdListener } from '@csj/openadsdk';
import { MethodChannel } from '@ohos/flutter_ohos';
import BannerConstants from './BannerConstants';
import { ArrayList } from '@kit.ArkTS';

@Component
export struct BannerNativeView {
  @Prop params: Params;

  @State bannerAd?: CSJNativeExpressAd = undefined

  mCodeId: string = '';
  viewWidth: number = 0;
  viewHeight: number = 0;
  acceptWidth: number = 0;
  acceptHeight: number = 0;
  channel?: MethodChannel

  mAdCreator = CSJAdSdk.getAdCreator()

  build() {
    Row() {
      if (this.bannerAd) {
        NodeContainer(this.bannerAd.getAdComponent())
          .width(this.acceptWidth)
          .height(this.acceptHeight)
          .alignSelf(ItemAlign.Center)
          .align(Alignment.Center)
      }
    }.width(this.viewWidth).height(this.viewHeight)
  }

  aboutToAppear(): void {
    this.mCodeId = BannerConstants.mCodeId;
    this.viewWidth = BannerConstants.viewWidth;
    this.viewHeight = BannerConstants.viewHeight;
    this.acceptWidth = BannerConstants.acceptWidth;
    this.acceptHeight = BannerConstants.acceptHeight;
    this.channel = BannerConstants.channel;

    this.loadAd()
  }

  private loadAd() {
    const adSlot = new AdSlotBuilder()
      .setCodeId(this.mCodeId)
      .setAcceptSize(this.acceptWidth, this.acceptHeight)
      .build()

    this.mAdCreator.loadBannerAd(adSlot, this.mLoadListener)
  }

  private showAd(bannerAd: CSJNativeExpressAd) {
    bannerAd.setExpressInteractionListener({
      onAdClicked: (type: number) => {
        console.log("BannerNativeView==onAdClicked......");
        this.channel?.invokeMethod("onClick", "Banner广告点击")
      },

      onAdShow: (type: number) => {
        console.log("BannerNativeView==onAdShow......");
        this.channel?.invokeMethod("onShow", "Banner广告展示")
      },

      onRenderFail: (code: number, msg: string) => {
        console.log("BannerNativeView==onRenderFail...code=" + code + ",msg=" + msg);
        this.channel?.invokeMethod("onFail", `${code}, ${msg}`)
      },

      onRenderSuccess: (width: number, height: number) => {
        console.log("BannerNativeView==onRenderSuccess......width=" + width + ",height=" + height);
        this.channel?.invokeMethod("onSuccess", `渲染成功: width=${width}, height=${height}`)
      }
    })

    // 渲染广告
    bannerAd.render(this.getUIContext())
  }

  private mLoadListener: NativeExpressAdListener = {
    onError: (code: number, message: string) => {
      console.error("加载广告失败，code=" + code + "，message=" + message);
      this.channel?.invokeMethod("onFail", `${code}, ${message}`);
    },

    onNativeExpressAdLoad: (ads: ArrayList<CSJNativeExpressAd>) => {
      console.log("BannerNativeView==onNativeExpressAdLoad......success");
      if (ads && ads.length > 0) {
        // 获取第一个广告
        this.bannerAd = ads[0]
        this.showAd(this.bannerAd)
      }
    }
  }
}

@Builder
export function BannerBuilder(params: Params) {
  BannerNativeView({
    params: params,
  })
}
