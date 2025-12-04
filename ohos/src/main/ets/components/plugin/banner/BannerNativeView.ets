import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { AdSlotBuilder, CSJAdSdk, CSJNativeExpressAd, ExpressAdInteractionListener, NativeExpressAdListener, AdSlot } from '@csj/openadsdk';
import { MethodChannel, Any } from '@ohos/flutter_ohos';
import BannerView from './BannerView';
import { ArrayList } from '@kit.ArkTS';

@Component
export struct BannerNativeView {
  @Prop params: Params;
  @State bannerAd?: CSJNativeExpressAd = undefined
  bannerView: BannerView = this.params.platformView as BannerView
  mCodeId: string = ''
  acceptWidth: number = 0;
  acceptHeight: number = 0;
  mAdSlot?: AdSlot

  build() {
    Row() {
      if (this.bannerAd && this.mAdSlot) {
        NodeContainer(this.bannerAd.getAdComponent())
          .width(this.mAdSlot.getAcceptWidth())
          .height(this.mAdSlot.getAcceptHeight())
          .alignSelf(ItemAlign.Center)
          .align(Alignment.Center);
      }
    }
  }

  aboutToAppear(): void {
    this.mCodeId = this.bannerView.getMCodeId();
    this.acceptWidth = this.bannerView.getAcceptWidth();
    this.acceptHeight = this.bannerView.getAcceptHeight();

    this.loadAd()
  }

  private loadAd() {
    this.mAdSlot = new AdSlotBuilder()
      .setCodeId(this.mCodeId)
      .setAdCount(1)
      .setAcceptSize(this.acceptWidth, this.acceptHeight)
      .build()

    let mLoadListener: NativeExpressAdListener = {
      onError: (code: number, message: string) => {
        //console.error("BannerView->加载广告失败，code=" + code + "，message=" + message);
        this.bannerView.sendMsg("onFail", `${code}, ${message}`)
      },

      onNativeExpressAdLoad: (ads: ArrayList<CSJNativeExpressAd>) => {
        //console.log("BannerView==onNativeExpressAdLoad......success");
        if (ads && ads.length > 0) {
          // 获取第一个广告
          this.showAd(ads[0])
        }
      }
    }

    let mAdCreator = CSJAdSdk.getAdCreator()
    mAdCreator.loadBannerAd(this.mAdSlot, mLoadListener)
  }

  private showAd(bannerAd: CSJNativeExpressAd) {
    bannerAd.setExpressInteractionListener({
      onAdClicked: (type: number) => {
        console.log("BannerView==onAdClicked......");
        //this.channel?.invokeMethod("onClick", "Banner广告点击")
        this.bannerView.sendMsg("onClick", "Banner广告点击")
      },

      onAdShow: (type: number) => {

      },

      onRenderFail: (code: number, msg: string) => {
        console.log("BannerView==onRenderFail...code=" + code + ",msg=" + msg);
        //this.channel?.invokeMethod("onFail", `${code}, ${msg}`)
        this.bannerView.sendMsg("onFail", `${code}, ${msg}`)
        this.bannerAd = undefined;
      },

      onRenderSuccess: (width: number, height: number) => {
        //console.log("BannerView==onRenderSuccess......width=" + width + ",height=" + height);
        this.bannerAd = bannerAd;
        //console.log("BannerView==onAdShow......");
        let map: Record<string, Any> = {
          "width": width, "height": height
        };
        //this.channel?.invokeMethod("onShow", map)
        this.bannerView.sendMsg("onShow", map)
      }
    })

    this.setDislikeCallback(bannerAd);
    bannerAd.setSlideIntervalTime(30 * 1000)
    // 渲染广告
    bannerAd.render(this.getUIContext())
  }

  private setDislikeCallback(ad: CSJNativeExpressAd) {
    ad.setDislikeCallback({
      /**
       * dislike show
       */
      onShow: () => {
        //console.log("BannerExpressAdPage==dislike......show");
      },

      /**
       * @param position 选择的位置
       * @param value 选择的内容
       * @param enforceRemove 是否强制关闭广告
       */
      onSelected: (position: number, value: string, enforceRemove: boolean) => {
        //console.log("BannerView==dislike......onSelected:position=" + position + ",value:" + value + ",enforce=" + enforceRemove);
        //this.channel?.invokeMethod("onDislike", value);
        this.bannerView.sendMsg("onDislike", value);
        this.bannerAd = undefined;
      },

      /**
       * 点击取消
       */
      onCancel: () => {
        //console.log("BannerView==dislike......onCancel");
      }
    })
  }
}

@Builder
export function BannerBuilder(params: Params) {
  BannerNativeView({
    params: params,
  })
}
