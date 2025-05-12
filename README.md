## 介绍

ZRouter 是一款轻量级且非侵入性的鸿蒙动态路由框架，可解决 HAR/HSP 业务模块间的耦合与通信问题。主要特性：

- 简化 Navigation 使用，无需关注路由表的配置，对 Navigation 及 NavDestination 组件保持零侵入；
- **支持 API 链式调用，让 API 更简洁直观；**
- **为了进一步简化使用，支持 NavDestination 页面模板化，是一个可选项；**
- 注解参数支持使用静态常量，可跨模块定义；
- 支持自定义与全局拦截器，可设优先级及中断逻辑，可实现页面重定向、登录验证等业务场景。
- **支持服务路由，可实现 Har/Hsp 模块间的通信；**
- 支持全局及单个页面的生命周期函数管理，可使任意类都能享有与组件相同的生命周期特性，可实现页面埋点统计等业务场景；
- **支持跨多级页面参数携带返回监听；**
- 支持自定义 URL 路径跳转，可在拦截器内自行解析 URL 实现业务逻辑；
- 内置多种转场动画效果（平移、旋转、渐变、缩放、高斯模糊），并支持自定义动画；
- 支持启动模式、混淆、嵌套 Navigation、Hap；
- 支持第三方 Navigation 的使用本库 API；
- **支持与您现有项目中的 Navigation 无缝融合，实现零成本向本库迁移；**
- 支持 ArkUI-X 跨平台上使用；
- 未来计划：支持共享元素动画、持续优化。

**使用十分简单，没有繁琐的配置，两行代码就可以完成页面的跳转**，如下:

<center>

[![a1.png](https://www.z4a.net/images/2024/10/12/a1.png)](https://www.z4a.net/image/yUNrzw)

</center>

ZRouter 已上架录入到[华为鸿蒙生态伙伴组件专区](https://developer.huawei.com/consumer/cn/market/landing/component)

## **router-register-plugin 编译插件 -- 很重要**

### 下载安装

**在项目根目录的 hvigor 目录下的`hvigor-config.json5`文件中配置安装**

[![pEovcrt.png](https://s21.ax1x.com/2025/04/26/pEovcrt.png)](https://imgse.com/i/pEovcrt)

```
  "dependencies": {
    "router-register-plugin":"x.x.x"
  },
```

**编译插件最新版本**: ![Static Badge](https://img.shields.io/badge/router-register-plugin?link=https%3A%2F%2Fgithub.com%2F751496032%2FRouterRegisterPlugin)
[![npm](https://img.shields.io/npm/v/router-register-plugin)](https://www.npmjs.com/package/router-register-plugin)

最后记得 Sync Now 或重新 build 让插件安装生效。

或者使用 hvigorw 命令行工具执行任一命令，命令行工具会自动执行安装构建依赖。

```
hvigorw --sync
```

### 初始配置

**在每个模块中的`hvigorfile.ts`文件导入 router-register-plugin 插件模块**，如下：

```
// 1、导入
import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'

// 2、初始化配置
const config: PluginConfig = {
    scanDirs: ['src/main/ets/pages', 'src/main/ets/views'], // 扫描的目录，如果不设置，默认是扫描src/main/ets目录
    logEnabled: true, // 查看日志
    viewNodeInfo: false, // 查看节点信息
    isAutoDeleteHistoryFiles: true, // 删除无用编译产物
    lifecycleObserverAttributeName: 'xxx' // 可选，设置全局的生命周期实现类在组件上的属性名，默认值是lifecycleObserver

}
export default {
    // 3、添加插件
    plugins:[routerRegisterPlugin(config)]
}

```

> **注意：hvigorfile.ts 文件中默认配置不要删除了。**

常用的配置字段：

- scanDirs：扫描的目录，建议设置可更精准、更快扫描生成文件，如果不设置，默认是扫描 src/main/ets 目录
- logEnabled：日志记录开关。
- viewNodeInfo：查看节点信息的开关，只有 logEnabled 和 viewNodeInfo 同时开启才会生效
- isAutoDeleteHistoryFiles：是否删除无用编译产物；
- lifecycleObserverAttributeName：设置全局的生命周期实现类在组件上的属性名，默认值是 lifecycleObserver，若要设置单个页面的名称，可在@ZRoute 注解中的 loAttributeName 属性上设置。

PluginConfig 配置对象还有其他属性，但不建议使用，使用默认值即可。

> 上面所有路径都是相对模块的 src 目录而言的，是相对路径。最后记得 Sync Now 或重新 build 让配置生效。

其中`_generated`目录和`route_map.json`文件在编译阶段自动生成的，建议在 git 的`.gitignore`忽略掉这两个文件。

```gitignore
_generated
route_map.json
```

## ZRouter 的基本使用

### 下载安装

在每个 har/hsp 模块中，通过 ohpm 工具下载安装库：

```
ohpm install @hzw/zrouter
```

### 页面跳转

新建三个模块分别是 harA、harB、hspC，三者之间没有依赖关系，entry 模块依赖了这三个模块，通过 ZRouter 可以在四个模块间相互跳转，从而达到模块解耦效果。模块关系图如下图：

<center>

![6a594e11394c60d93983297a1e5322db.png](https://www.z4a.net/images/2024/10/17/6a594e11394c60d93983297a1e5322db.png)

</center>

1、在 EntryAbility 的 onCreate()方法中初始化 ZRouter，**建议使用 initialize()方法进行初始化，init()方法已弃用**

```
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 如果项目中存在hsp模块则传入true
      ZRouter.initialize((config) => {
          config.isLoggingEnabled = BuildProfile.DEBUG
          config.isHSPModuleDependent = true
    })
}

```

**建议在 AbilityStage 的 onCreate()方法中完成初始化**

```typescript
export class AppAbilityStage extends AbilityStage {
  onCreate(): void {
    // 应用HAP首次加载时触发，可以在此执行该Module的初始化操作（例如资源预加载、线程创建等）。
    // 在module.json5配置文件中，通过配置 srcEntry 参数来指定模块对应的代码路径，以作为HAP加载的入口。
    // 初始化路由
    ZRouter.initialize((config) => {
      config.isLoggingEnabled = BuildProfile.DEBUG;
      config.isHSPModuleDependent = true;
      // 服务路由初始化配置，如果没有使用服务路由，可不设置
      config.loadDynamicModule = ["@hzw/hara", "harb", "hspc"];
      config.onDynamicLoadComplete = () => {
        console.log("已完成所有模块的加载");
      };
    });
  }
}
```

2、在 Index 页面**使用 Navigation 作为根视图，通过 ZRouter 的 getNavStack()方法获取 NavPathStack 实例，将其传入到 Navigation 的构造函数中。**

**如果在 Index 入口文件中启动 Splash 页面，建议放在 Navigation 的`onAppear`方法中进行启动，或者组件的`onPageShow`方法**，具体可参考 demo

```
// Index 中使用 aboutToAppear 生命周期函数会因为 Navigation 还没初始化完成导致无法有效跳转,可使用替换成 onPageShow
@Entry
@Component
struct Index {

  build() {
    // 获取NavPathStack实例对象
    Navigation(ZRouter.getNavStack()){
      Column({space:12}){
        Button('toHarAMainPage').onClick((event: ClickEvent) => {
        // 跳转页面
          ZRouter.push("harAMainPage")
        })
      }
    }
    .title('Main')
    .height('100%')
    .width('100%')
    .onAppear(() => {
      // 启动Splash页面
       ZRouter.push("SplashPage")
    })
  }
}
```

通过 ZRouter 的 pushXX()方法进行页面跳转，参数是@Route 装饰器上的 name 属性值；~~或者用 ZRouter 的 getNavStack()方法来执行页面跳转~~。

3、**在 NavDestination 子页的使用自定义`@Route`或`@ZRoute`注解标注页面**，其中 name 属性是必填的，页面跳转需要用到 name 值，还有另外三个可选属性分别是：

- description：页面描述，没有功能作用；
- needLogin：如果页面需要登录，可以将值设置为 true，然后在拦截器中做页面重定向到登录页；
- extra：额外的值可以通过该属性设置

> @Route/@Service/@ZAttribute/@ZLifecycle 等自定义注解上的 name 属性支持使用静态常量，在后面文档有详细介绍

代码如下：

```
@Route({ name: 'hspCPage1', needLogin:true ,extra: 'hsp'})
@Component
export struct Page1 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){
        Button('toHarAPage1').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage1")
        })
      }

    }
    .title('hspCPage1')
    .width('100%')
    .height('100%')

  }
}

```

> 如果觉得每个页面都要用 NavDestination 组件包裹太麻烦，可以使用[NavDestination 模板化功能](https://gitee.com/common-apps/ZRouter/wikis/NavDestination%E9%A1%B5%E9%9D%A2%E6%A8%A1%E6%9D%BF%E5%8C%96%E8%83%BD%E5%8A%9B)。

**建议通过 ZRouter.getInstance()方式来操作路由的跳转与关闭，使用会更灵活简洁，之前的 ZRouter 的静态方法依然保留着，在 1.2.0 版本起将标记为过期状态了。**

```typescript
ZRouter.getInstance()
  .setParam("root data")
  .setLunchMode(LaunchMode.STANDARD) // 启动模式
  .setAnimate(true)
  .setPopListener((r) => {
    LogUtil.log("index result: ", r.data, " from: ", r.from);
  })
  .navigation("harAPage3");
```

### 拦截器

ZRouter 支持多个拦截器和全局拦截器，在拦截器中可以做页面跳转的拦截，比如跳转前拦截、数据预取、登录拦截，404 拦截、埋点、自定义 URL 路径等等。

#### 全局拦截器

代码示例：

```typescript
export class GlobalNavigateInterceptor implements IGlobalNavigateInterceptor {
  static count = 0;
  onNavigateBefore: (destInfo: DestinationInfo) => Promise<DestinationInfo> = (
    destInfo
  ) => {
    console.log("IInterceptor Global onNavigateBefore -> ", destInfo.name);
    return new Promise((resolve, _) => {
      if (destInfo.name === RouterConstants.PAGE_BEFORE_PUSH) {
        // 拦截跳转到ParamPage页面
        if (GlobalNavigateInterceptor.count === 0) {
          destInfo.param = " 在拦截器onNavigateBefore中已替换参数 ";
          destInfo.next(); // 继续跳转 默认的 ，可以不写
        } else if (GlobalNavigateInterceptor.count === 1) {
          ToastUtils.show("拦截器onNavigateBefore中已拦截, 再点一次会继续执行");
          destInfo.block(); // 拦截跳转
        } else if (GlobalNavigateInterceptor.count === 2) {
          destInfo.name = RouterConstants.LIFECYCLE_CASE_VIEW;
        }
        GlobalNavigateInterceptor.count += 1;
      }
      resolve(destInfo);
    });
  };

  onRootWillShow: ((fromContext: NavDestinationContext) => void) | undefined = (
    fromContext
  ) => {
    console.log(
      "IInterceptor Global onRootWillShow: ",
      fromContext.pathInfo.name
    );
  };
  onPageWillShow:
    | ((
        fromContext: NavDestinationContext,
        toContext: NavDestinationContext
      ) => void)
    | undefined = (from, to) => {
    console.log(
      "IInterceptor Global onPageWillShow: ",
      from,
      to.pathInfo.name,
      to.pathInfo.param
    );
  };

  onNavigate: ((context: InterceptorInfo) => void) | undefined = (info) => {
    if (info.notRegistered) return;
    console.log("IInterceptor Global onNavigate -> ", info.name);
    let isLogin = AppStorage.get<boolean>("isLogin");
    if (info.isNeedLogin && !isLogin) {
      let param = info.param;
      ZRouter.getInstance()
        .setParam(param)
        .setAnimate(true)
        .setPopListener((result) => {
          if (result.data) {
            //  登录成功
            promptAction.showToast({ message: `登录成功` });
            return true; // 返回true 则继续跳转登录前的页面
          } else {
            return false;
          }
        })
        .redirect("LoginPage", RedirectType.REPLACE);
    }
  };
}

// 添加拦截器
ZRouter.setGlobalInterceptor(new GlobalNavigateInterceptor());
```

info.notRegistered()方法判断当前页面是否注册，如果没有注册，将使用 ZRouter.redirect() 方法来重定向到 404 页面； 也可以通过 redirect() 方法来重定向到登录页面，这个方法接受一个回调函数，该回调函数会在用户登录成功或失败后被调用，在回调函数内部，使用 data.result 判断是否登录 ，如果登录成功了给回调函数 return true 来指示继续执行登录前的页面跳转。如果登录失败，或者用户取消登录，回调函数将返回 false，表示不跳转。

登录页面代码示例：

```
@Route({ name: 'LoginPage'})
@Component
export struct LoginPage{

  build() {
    NavDestination(){
       Column({space:15}){
         Button('登录成功').onClick((event: ClickEvent) => {
            // 模拟登录
           AppStorage.setOrCreate<boolean>('isLogin', true)
           ZRouter.finishWithResult<boolean>(true)
         })
       }
       .width('100%')
       .height('100%')
    }
      .width('100%')
      .height('100%')
      .title('LoginPage')
  }
}
```

在登录成功后通过 ZRouter.finishWithResult()方法携带数据关闭页面，会将状态传递给 redirectForResult2()方法的回调函数。

上面是全局拦截器，每个跳转都会触发，如果需要添加多个拦截器，则可以使用 setInterceptor()方法，但不建议使用。

#### 自定义拦截器 - 不建议使用

自定义拦截器，首先实现接口 IInterceptor，然后使用 setInterceptor()方法注册拦截器，，代码示例如下：

```typescript
export interface IInterceptor {
  process: ProcessCallback;
  // 优先级，数字越大优先级越高
  priority: number;
}
export type ProcessCallback = (
  context: InterceptorInfo
) => InterceptorInfoOrNull;
```

**在 IInterceptor 的 process()方法中进行页面跳转的拦截，process()方法返回 null 会中断后面的拦截器逻辑，返回 context 则继续执行后面的拦截器逻辑。**

代码示例：

```typescript

aboutToAppear(): void {
  ZRouter.setInterceptor(new UrlInterceptor())
}

export class UrlInterceptor implements IInterceptor {
  // 设置拦截器优先级，数值越大则优先执行
  priority: number = 10000;
  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    return context
  }
}
```

关于其他 API 的使用请参考 demo。

## NavDestination 页面模板化

在介绍基本使用的流程中，我们知道每个页面都需要通过 NavDestination 来包裹，这样会造成代码的冗余，因此可通过 ZRouter 的模板化能力将 NavDestination 层去除。

具体使用见[详细文档](https://gitee.com/common-apps/ZRouter/wikis/NavDestination%E9%A1%B5%E9%9D%A2%E6%A8%A1%E6%9D%BF%E5%8C%96%E8%83%BD%E5%8A%9B)

## 自定义 URL 路径跳转

在项目中一般会设计一套统一的 URL 路径跳转规范，通过 URL 路径跳转到不同原生页面。比如下面的 URL 路径：

```typescript
hzw://hello?id=69&name=harAPage3
```

获取 URL 路径上的 name 参数进行跳转原生页面，可以设置一个拦截器来拦截 URL 路径跳转。代码示例：

跳转：

```typescript
Button("https://www.baidu.com?id=66&name=hspCIndex").onClick(
  (event: ClickEvent) => {
    ZRouter.getInstance().navigation(
      "https://www.baidu.com?id=66&name=hspCIndex"
    );
  }
);

Button("hzw://hello?id=69&name=harAPage3").onClick((event: ClickEvent) => {
  ZRouter.getInstance().navigation("hzw://hello?id=69&name=harAPage3");
});
```

拦截器：

```typescript
export class UrlInterceptor implements IInterceptor {
  // 设置拦截器优先级，数值越大则优先执行
  priority: number = 10000;
  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    console.log("IInterceptor process: ", this.priority, context.name);
    // 自定义URL路径是没有注册的
    if (context.notRegistered) {
      // 如果是URL路径跳转
      if (this.isLink(context.name)) {
        // 拦截到URL路径跳转，进行处理
        const map = this.parseQueryString(context.name);
        const name = map.get("name");
        if (name) {
          // 跳转原生页面
          ZRouter.getInstance().setParam(map.get("id")).navigation(name);
        }
      } else {
        ZRouter.getInstance().redirect("PageNotFound2");
      }
      return null; // 返回null则拦截掉
    }
    return context;
  };

  isLink(str: string): boolean {
    const linkRegex = /^(hzw:\/\/|http:\/\/|https:\/\/|www\.).+/;
    return linkRegex.test(str);
  }

  parseQueryString(queryString: string) {
    let params = new HashMap<string, string>();
    let queryStringWithoutQuestionMark = queryString.split("?")[1];
    if (queryStringWithoutQuestionMark) {
      let keyValues = queryStringWithoutQuestionMark.split("&");
      keyValues.forEach((keyValue) => {
        let pair = keyValue.split("=");
        let key = decodeURIComponent(pair[0]);
        let value = decodeURIComponent(pair[1]);
        params.set(key, value);
      });
    }
    return params;
  }
}
```

**上面的逻辑也可以放在全局拦截器的 onNavigateBefore()方法中处理。**

## 注解上使用静态常量，可跨模块定义

router-register-plugin 插件 1.0.7 版本起，@Route 与@Service 注解的 name 属性可使用静态常量，方便统一管理路由名称；静态常量支持当前模块或跨模块定义，常量的定义模版如下：

```typescript
export class RouterConstants {
  public static readonly URL_TEST_PAGE: string = "url_test";
  public static readonly HARA_MAIN_PAGE: string = "harAMainPage";
}
```

> 如果路由常量在一个公共模块定义，建议在模块的 Index.ets 文件导出，另外 RouterConstants 的文件必须是.ets 后缀，不支持 ts 后缀文件。[具体可参考案例](https://gitee.com/common-apps/ZRouter/tree/master/library/common)

## 服务路由-模块间通信

服务路由主要用于实现模块之间的通信，模块间是相互独立且不直接依赖于彼此。

> 1.0.9 版本开始支持，具体使用可见[详情文档](https://gitee.com/common-apps/ZRouter/wikis/%E6%9C%8D%E5%8A%A1%E8%B7%AF%E7%94%B1%E2%80%94%E6%A8%A1%E5%9D%97%E9%97%B4%E9%80%9A%E4%BF%A1) 或者参考 demo

## 生命周期函数管理

ZRouter 的组件生命周期管理能力，主要有两个特点：

- 不影响你原有的生命周期业务逻辑，对 NavDestination 页面保持着零侵入性，整合了组件通用生命周期函数和 NavDestination 生命周期函数
- 可以让任何一个类具备有与组件的生命周期能力；

具体使用见[详细文档](https://gitee.com/common-apps/ZRouter/wikis/%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E7%AE%A1%E7%90%86%E8%83%BD%E5%8A%9B)

## 路由转场动画

从 1.1.1 版本起内置了转场动画（平移、旋转、渐变、缩放、高斯模糊），也支持自定义转场动画；具体使用见[详细文档](https://gitee.com/common-apps/ZRouter/wikis/%E8%B7%AF%E7%94%B1%E8%BD%AC%E5%9C%BA%E5%8A%A8%E7%94%BB)

## 第三方 Navigation 实例使用本库的 API

如果第三方 Navigation 实例使用本库的 API，需要将第三方 Navigation 的 NavPathStack 实例注册到 ZRouter 中，代码示例：

```typescript
  aboutToAppear(): void {
    // 在合适的时机注册导航栈
    // let s = ZRouter.getNavStackByName(NAV_STACK_NAME)
    ZRouter.registerNavStack(NAV_STACK_NAME, this.stack)
  }

  aboutToDisappear(): void {
    ZRouter.unregisterNavStack(NAV_STACK_NAME)
  }

```

上面是模拟代码，具体注册的时机需要根据实际情况来定。NAV_STACK_NAME 是一个自定义常量，用于标识导航栈的名称。

页面跳转：

```typescript
  Column({ space: 15 }) {
      Text(this.msg)
      Button("harAMainPage").onClick((event: ClickEvent) => {
        ZRouter.getInstance(NAV_STACK_NAME)
          .setAnimate(true)
          .setPopListener((v) => {
            this.msg = v.data?.toString() + ' ' + v.from?.toString()
          })
          .navigation("harAMainPage")
      })
    }
```

把标识导航栈的名称 NAV_STACK_NAME，入参到 ZRouter.getInstance()方法中，就可使用 ZRouter 的 API。

## 在 ArkUI-X 项目上的使用

router-register 插件在 ArkUI-X 项目的配置有所不同，需要使用者自己手动修改下 hvigorfile.ts 文件，详细见[ArkuiX-ZRouter](https://gitee.com/common-apps/ArkuiX-ZRouter)，或者[issues IB35F5](https://gitee.com/common-apps/ZRouter/issues/IB35F5)

## 混淆

生产环境需要在每个模块的 obfuscation-rules.txt 文件添加混淆配置：

```
-keep-file-name
Index
_generated
ZR*
```

## 工作原理

路由注册流程代码是由插件在编译阶段自动化生成，其原理是不难的，通过 Hvigor 插件扫描指定目录的 ets 文件，递归解析 ets 文件的语法树节点，查找解析注解上的参数，然后将这些信息通过模板引擎生成对应的代码逻辑。

> 与 Java 注解处理器原理是类似的

ZRouter 库是对 NavPathStack 对进行高度封装的，包括了页面跳转、自定义拦截器、服务路由、生命周期回调、转场动画、NavDestination 模板化等功能，提供了更简洁易用的 API，其中部分思想参考了 Android [ARouter](https://github.com/alibaba/ARouter)路由框架。

编译插件的基本流程图：

<center>

![84fbcf502ec66b87981622eaf57499e4.png](https://www.z4a.net/images/2024/10/17/84fbcf502ec66b87981622eaf57499e4.png)

</center>

## 接口列表

[查看详细文档](https://gitee.com/common-apps/ZRouter/wikis/%E6%8E%A5%E5%8F%A3%E5%88%97%E8%A1%A8?sort_id=13047549)

## FQA

[查看详细文档](https://gitee.com/common-apps/ZRouter/wikis/FQA)

## 源码

- gitee：https://gitee.com/common-apps/ZRouter
- github：https://github.com/751496032/ZRouter

## 实战案例

这里推荐一个基于 ZRouter 搭建项目的实战案例，仅做参考具体可根据你项目来调整。

- [《探索 HarmonyOS NEXT (5.0)：开启构建模块化项目架构奇幻之旅 —— 动态路由 ZRouter：引领高效模块通信的智慧中枢》](https://blog.csdn.net/qq_40533422/article/details/143479759)
- [案例源码](https://github.com/JasonYinH/ExploreHarmonyNext)

## 参与贡献

- Fork 本仓库
- 新建分支
- 提交代码
- 新建 Pull Request

## 其他库

- 鸿蒙数据库工具：https://gitee.com/HW-Commons/ZDbUtil
- 鸿蒙 H5 与原生的通信库：https://github.com/751496032/DSBridge-HarmonyOS
- 鸿蒙日志库：https://gitee.com/common-apps/logger

## 下一个版本计划

- 拦截器：拦截器支持 pop 拦截
- 服务路由：动态注册支持应用入口模块 entry
- 编译插件：自动生成文件调整
- 转场动画：支持一镜到底动画

## 联系我们

**欢迎大家提交 issue、PR、需求与建议（可以统一收集问题，方便更多人查阅，会第一时间回复处理）** ，或进群交流(+v: 751496032)。

[![_cgi-bin_mmwebwx-bin_webwxgetmsgimg__MsgID7985482268088807228skeycrypt_4f9ae0b8_0271518ab0cb7cd42bc056451ad75554mmweb_appidwx_webfilehelper.md.jpg](https://www.z4a.net/images/2025/03/12/_cgi-bin_mmwebwx-bin_webwxgetmsgimg__MsgID7985482268088807228skeycrypt_4f9ae0b8_0271518ab0cb7cd42bc056451ad75554mmweb_appidwx_webfilehelper.md.jpg)](https://www.z4a.net/image/ywEHV0)
