/**
 * @author: HZWei
 * @date: 2025/4/19
 * @desc:
 */
import { LifecycleState, RouterInfo, ZRoute, ZRouter } from "routerapi";
import { RouterConst } from "../constants/RouterConst";
import { common, Want } from "@kit.AbilityKit";
import { BusinessError, deviceInfo } from "@kit.BasicServicesKit";
import { RouterConstants, ToastUtils } from "@hzw/common_library";
import { promptAction, router } from "@kit.ArkUI";

@Component
export struct MainView {
  private context = getContext(this) as common.UIAbilityContext;
  private sdkApiVer = deviceInfo.sdkApiVersion
  private isSdkApi12 = this.sdkApiVer >= 12

  desc(): string {
    if (this.isSdkApi12) {
      return "sdkApiVersion: " + this.sdkApiVer
    } else {
      return "sdkApiVersion: " + this.sdkApiVer + "  不支持启动模式"
    }
  }



  build() {
    this.MainBuilder()
  }

  @Builder
  MainBuilder() {
    Scroll() {
      Column({ space: 12 }) {
        Text(this.desc())
        Button('har-跳转到HarA模块').onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.HARA_MAIN_PAGE)

        })
        Button('har-跳转到HarB模块').onClick((event: ClickEvent) => {
          ZRouter.push(RouterConstants.HARB_MAIN_PAGE)
        })
        Button('hsp-跳转到Hsp模块').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .withParam("isRoot", true)
            .withParam("msg", "hello ZRouter")
            .setPopListener((info) => {
              let msg = `返回携带的数据：${JSON.stringify(info.data)}`
              ToastUtils.show(msg)
            })
            .navigation(RouterConstants.HSPC_INDEX_PAGE)
        })

        Button("hap-跳转到Hap模块").onClick((event: ClickEvent) => {
          let want: Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.harmony.router',
            abilityName: 'HapAAbility',
            moduleName: 'hapA', // moduleName非必选
            parameters: {
              // 自定义信息
              route: RouterConstants.ORDER_PAGE
            }
          };
          this.context.startAbility(want).then(() => {
            console.info("startAbility", '已启动Ability');
          }).catch((err: BusinessError) => {
            // https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs-V5/faqs-ability-7-V5
            console.error("startAbility", `启动Ability失败. Code: ${err.code}, message: ${err.message}`);
          })
        })


        Button('404页面').onClick((event: ClickEvent) => {
          // 页面不存在，重定向到提示页
          ZRouter.getInstance().navigation("PageNotFound111")
        })

        Button('跳转携带参数与监听pop携带的参数').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam("root data")
            .setLunchMode(LaunchMode.STANDARD)// 启动模式
            .listenPopResultOnRootView()// 跨页面携带参数返回根视图
            .setAnimate(true)
            .setPopListener((r) => {
              ToastUtils.show(`pop result: ${r.data}  from: ${r.from}`)
            })
            .navigation(RouterConstants.PAGE_PUSH_AND_POP_CASE)
        })

        Button("拦截器案例 跳转前拦截 - onNavigateBefore").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(" 正常数据 ")
            .navigation(RouterConstants.PAGE_BEFORE_PUSH)
        })


        Button("自定义URL跳转").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.CUSTOM_URL_PAGE)
        })

        Button("服务路由-实现模块通信").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.SERVICE_CASE_VIEW)
        })

        Button("生命周期函数管理").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE_CASE_VIEW)
        })



        Button("NavDestination页面模板化").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW)
        })

        Button("嵌套Navigation").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.NEST_PAGE)
        })



        Button("模拟第三方Navigation实例使用ZRouter库的Api").onClick((event: ClickEvent) => {
          router.pushUrl({ url: RouterConst.NAV_PAGE })
        }).margin({ top: 30 })
          .visibility(Visibility.None)

      }
    }
  }
}


