
## 介绍


ZRouter是一款轻量级的动态路由库，基于Navigation系统路由表和Hvigor插件实现的方案，可以解决多个业务模块（HAR/HSP）之间解耦问题，从而实现业务复用和功能扩展。主要特性：

- 对Navigation简化使用，封装一系列简单易用的API，支持链式调用，无需再关注路由表的配置，对Navigation组件保持着零侵入零耦合；
- 支持多个拦截器(支持优先级和中断拦截)和全局拦截器，可实现页面跳转和显示、埋点、登录等拦截处理；
- 支持自定义URL路径跳转配置，可以通过URL路径来跳转原生不同页面；
- 支持第三方Navigation的系统路由表使用本库API；
- 支持跨多级页面参数的回传监听；
- 支持启动模式、混淆、嵌套Navigation；
- @Route装饰器上的name属性支持使用静态常量；
- 后续会支持生命周期的监听、组件化通信（待实现）。


> ZRouter侧重于路由跳转与模块解耦，以及组件化的通信(待实现)；对Navigation组件没有任何耦合，不做任何的限制把自主权交给开发者。

**使用十分简单，没有繁琐的配置，两行代码就可以完成页面的跳转**，如下:

<center>

[![a1.png](https://www.z4a.net/images/2024/10/12/a1.png)](https://www.z4a.net/image/yUNrzw)

</center>

ZRouter已上架录入到[华为鸿蒙生态伙伴组件专区](https://developer.huawei.com/consumer/cn/market/landing/component)

![a2.png](https://www.z4a.net/images/2024/10/12/a2.png)

## router-register-plugin插件的使用

### 下载安装

在项目根目录的hvigor目录的hvigor-config.json5文件中配置安装

```
  "dependencies": {
//    "router-register-plugin":"file:../plugins/router-register-plugin-1.0.2.tgz"
    "router-register-plugin":"1.0.7"
  },
```

![Static Badge](https://img.shields.io/badge/router-register-plugin?link=https%3A%2F%2Fgithub.com%2F751496032%2FRouterRegisterPlugin)
[![npm](https://img.shields.io/npm/v/router-register-plugin)](https://www.npmjs.com/package/router-register-plugin)


最后记得Sync Now或重新build让插件安装生效。

或者使用hvigorw命令行工具执行任一命令，命令行工具会自动执行安装构建依赖。


```
hvigorw --sync
```

### 初始配置

在每个模块中的hvigorfile.ts文件导入router-register-plugin插件模块，如下：


```
// 1、导入
import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'

// 2、初始化配置
const config: PluginConfig = {
    scanDirs: ['src/main/ets/pages', 'src/main/ets/views'], // 扫描的目录，如果不设置，默认是扫描src/main/ets目录
    logEnabled: true, // 查看日志
    viewNodeInfo: false, // 查看节点信息
    isAutoDeleteHistoryFiles: true // 删除无用编译产物

}
export default {
    system: harTasks,  
    // 3、添加插件
    plugins:[routerRegisterPlugin(config)] 
}

```

常用的配置字段：

- scanDirs：扫描的目录，建议是页面目录，这样可以更精准扫描目标文件，如果不设置，默认是扫描src/main/ets目录
- logEnabled：日志记录开关。
- viewNodeInfo：查看节点信息的开关，只有logEnabled和viewNodeInfo同时开启才会生效
- isAutoDeleteHistoryFiles：是否删除无用编译产物。

PluginConfig配置对象还有其他属性，但不建议使用，使用默认值即可。如下:


```
export class PluginConfig {
    /**
     * 扫描的目录
     * 默认是 src/main/ets/
     */
    scanDirs: string[] = []
    /**
     * builder函数注册代码生成的目录
     * src/main/ets/_generated/
     */
    generatedDir: string = ''
    /**
     * Index.ets目录
     * 模块下目录下
     */
    indexDir: string = ''
    /**
     * module.json5文件路径
     * src/main/ets/module.json5
     */
    moduleJsonPath: string = ''
    /**
     * 路由表路径
     * src/main/ets/resources/base/profile/route_map.json
     */
    routerMapPath: string = ''
    /**
     * 是否打印日志
     */
    logEnabled: boolean = true

    /**
     * 查看节点信息，只有与logEnable同时为true才会打印输出
     */
    viewNodeInfo: boolean = false
    
    /**
     * 是否启用删除无用编译产物
     */
    isAutoDeleteHistoryFiles: Boolean = false
}

```
> 上面所有路径都是相对模块的src目录而言的，是相对路径。最后记得Sync Now或重新build让配置生效。

## ZRouter的基本使用

### 下载安装

在每个har/hsp模块中，通过ohpm工具下载安装库：


```
ohpm install @hzw/zrouter
```


### 页面跳转

新建三个模块分别是harA、harB、hspC，三者之间没有依赖关系，entry模块依赖了这三个模块，通过ZRouter可以在四个模块间相互跳转，从而达到模块解耦效果。模块关系图如下图：



<center>

![6a594e11394c60d93983297a1e5322db.png](https://www.z4a.net/images/2024/10/17/6a594e11394c60d93983297a1e5322db.png)
</center>


1、在EntryAbility的onCreate()方法中初始化ZRouter


```
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 如果项目中存在hsp模块则传入true
    ZRouter.init(true)
}

```


2、在Index页面使用Navigation作为根视图，通过ZRouter的getNavStack()方法获取NavPathStack实例。

> 如果在Index入口文件中启动Splash页面，建议放在Navigation的onAppear方法中进行启动，或者组件的onPageShow方法，具体可参考demo

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

        Button('toHarBMainPage').onClick((event: ClickEvent) => {
          ZRouter.push("harBMainPage")
        })

        Button('toHspCIndex').onClick((event: ClickEvent) => {
          ZRouter.push("hspCIndex")
        })
        
         Button('tohspCPage1').onClick((event: ClickEvent) => {
          ZRouter.push("hspCPage1")
        })

      }
    }
    .title('Main')
    .height('100%')
    .width('100%')
  }
}
```

通过ZRouter的pushXX()方法进行页面跳转，参数是@Route装饰器上的name属性值。或者用ZRouter的getNavStack()方法来执行页面跳转。

3、在子页的结构体上使用自定义@Route装饰器描述当前页面，其中name属性是必填的，页面跳转需要用到name值，建议使用驼峰式命名，还有另外三个可选属性分别是：

- description：页面描述，没有功能作用；
- needLogin：如果页面需要登录，可以将值设置为true，然后在拦截器中做页面重定向到登录页；
- extra：额外的值可以通过该属性设置

> 自定义@Route装饰器参数只支持字面量值，不支持表达式方式赋值。

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

        Button('toHarAPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage2")
        })

        Button('toHarBPage1').onClick((event: ClickEvent) => {
          ZRouter.push("harBPage1")
        })

        Button('toHarBPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harBPage2")
        })

        Button('toHspCPage1').onClick((event: ClickEvent) => {
          ZRouter.push("hspCPage1")
        })

        Button('toHspCPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harCPage2")
        })
      }

    }
    .title('hspCPage1')
    .width('100%')
    .height('100%')

  }
}

```

NavDestination是子页面的根容器，不需要在main_pages文件中注册页面路径。

**建议通过ZRouter.getInstance()方式来操作路由的跳转与关闭，使用会更灵活，之前的ZRouter的静态方法依然保留着。**

```typescript
 ZRouter.getInstance()
  .setParam("root data")
  .setLunchMode(LaunchMode.STANDARD) // 启动模式
  .enableCrossPageParamReturn() // 跨页面参数返回
  .setAnimate(false)
  .setPopListener((r) => {
    LogUtil.log("index result: ", r.data ," from: ", r.from);
  })
  .navigation("harAPage3")
```

### 拦截器

ZRouter支持多个拦截器和全局拦截器，在拦截器中可以做页面跳转的拦截，比如登录拦截，404拦截、埋点、自定义URL路径跳转等。

#### 全局拦截器

全局拦截器提供两种使用方式：

- 直接函数回调时的方式；
- 类实现接口的方式（建议使用，功能更全面），支持字面量对象和new创建的对象。

函数回调的方式，代码示例：

```
@Entry
@Component
struct Index {
  aboutToAppear(): void {
    ZRouter.setGlobalInterceptor((info) => {
      if (info.notRegistered) {
        return
      }
      let isLogin = AppStorage.get<Boolean>("isLogin")
      if (info.needLogin && !isLogin) {
        let param = ZRouter.getParamByName(info.data?.name ?? "")
        ZRouter.redirectForResult2("LoginPage", param, (data) => {
            if (data.result) {
              // 登录成功
              promptAction.showToast({ message: `登录成功` })
              return true // 返回true 则继续跳转登录前的页面
            }
            return false
          })
      }
    })

  }
    
}
  
```


类实现接口的方式，代码示例：

```typescript

export class GlobalNavigateInterceptor implements  IGlobalNavigateInterceptor{
  onRootWillShow?: ((fromContext: NavDestinationContext) => void) | undefined = (fromContext) => {
    console.log("IInterceptor Global onRootWillShow: ", fromContext.pathInfo.name)
  }
  onPageWillShow?: ((fromContext: NavDestinationContext, toContext: NavDestinationContext) => void) | undefined = (from ,to)=>{
    console.log("IInterceptor Global onPageWillShow: ", from, to.pathInfo.name, to.pathInfo.param)
  }

  onNavigate?: ((context: InterceptorInfo) => void) | undefined = (info)=>{
    if (info.notRegistered) return
    console.log("IInterceptor Global onNavigate: ", info.name)

    let isLogin = AppStorage.get<boolean>("isLogin")
    if (info.isNeedLogin && !isLogin) {
      let param = info.param
      ZRouter.redirectForResult2<boolean>("LoginPage", param, (data) => {
        if (data.data) {
          // 登录成功
          promptAction.showToast({ message: `登录成功` })
          return true // 返回true 则继续跳转登录前的页面
        }
        return false
      })
    }

  }
}

// 添加拦截器
ZRouter.setGlobalInterceptor(new GlobalNavigateInterceptor())       

// 或者字面量对象的方式
ZRouter.setGlobalInterceptor({
  onRootWillShow: (fromContext) => {
    console.log("IInterceptor Global onRootWillShow: ", fromContext.pathInfo.name)
  },
  onPageWillShow: (fromContext, toContext) => {
    console.log("IInterceptor Global onPageWillShow: ", fromContext.pathInfo.name, toContext.pathInfo.name)
  },
} as IGlobalNavigateInterceptor)

```

info.notRegistered()方法判断当前页面是否注册，如果没有注册，将使用ZRouter.redirect() 方法来重定向到404页面；通过ZRouter.redirectForResult() 方法来重定向到登录页面，这个方法接受一个回调函数，该回调函数会在用户登录成功或失败后被调用，在回调函数内部，使用 data.result判断是否登录 ，如果登录成功了给回调函数 return true 来指示继续执行登录前的页面跳转。如果登录失败，或者用户取消登录，回调函数将返回 false，表示不跳转。


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

在登录成功后通过ZRouter.finishWithResult()方法携带数据关闭页面，会将状态传递给redirectForResult2()方法的回调函数。


上面是全局拦截器，每个跳转都会触发，如果需要添加多个拦截器，则可以使用setInterceptor()方法。

#### 多个拦截器

单个拦截器的使用方式和全局拦截器是类似的，首先实现接口IInterceptor，然后使用setInterceptor()方法注册拦截器，，代码示例如下：

```typescript
export interface IInterceptor {
  process: ProcessCallback;
  // 优先级，数字越大优先级越高
  priority: number;
}
export type ProcessCallback = (context: InterceptorInfo) => InterceptorInfoOrNull;
```

**在IInterceptor的process()方法中进行页面跳转的拦截，process()方法返回null会中断后面的拦截器逻辑，返回context则继续执行后面的拦截器逻辑。**

代码示例：

```typescript

aboutToAppear(): void {
  // 第一种方式设置拦截器，字面量对象的形式
  ZRouter.setInterceptor({
    priority: 100,
    process: (context: InterceptorInfo) => {
      console.log("IInterceptor process: ", 100, context.name)
      return context
    }
  } as IInterceptor)
  // 第二种方式设置拦截器，类的实例对象的形式
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

关于其他API的使用请参考demo。


## 自定义URL路径跳转

在项目中一般设计一套统一的URL路径跳转规范，通过URL路径跳转到不同原生页面。比如下面的URL路径：

```typescript
hzw://hello?id=69&name=harAPage3
```
获取URL路径上的name参数进行跳转原生页面，可以设置一个拦截器来拦截URL路径跳转。代码示例：

跳转：

```typescript
Button('https://www.baidu.com?id=66&name=hspCIndex').onClick((event: ClickEvent) => {
       ZRouter.getInstance()
         .navigation("https://www.baidu.com?id=66&name=hspCIndex")
    })

Button('hzw://hello?id=69&name=harAPage3').onClick((event: ClickEvent) => {
  ZRouter.getInstance()
    .navigation("hzw://hello?id=69&name=harAPage3")
})
```


拦截器：

```typescript
export class UrlInterceptor implements IInterceptor {
  // 设置拦截器优先级，数值越大则优先执行
  priority: number = 10000;
  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    console.log("IInterceptor process: ", this.priority , context.name)
    // 自定义URL路径是没有注册的
    if (context.notRegistered) {
      // 如果是URL路径跳转
      if (this.isLink(context.name)) {
        // 拦截到URL路径跳转，进行处理
        const map = this.parseQueryString(context.name)
        const name = map.get('name')
        if (name) {
          // 跳转原生页面
          ZRouter.getInstance()
            .setParam(map.get("id"))
            .navigation(name)
        }
      } else {
        ZRouter.getInstance().redirect("PageNotFound2")
      }
      return null // 返回null则拦截掉
    }
    return context
  };

   isLink(str: string): boolean {
    const linkRegex = /^(hzw:\/\/|http:\/\/|https:\/\/|www\.).+/;
    return linkRegex.test(str);
  }


  parseQueryString(queryString: string) {
    let params = new HashMap<string, string>();
    let queryStringWithoutQuestionMark = queryString.split('?')[1];
    if (queryStringWithoutQuestionMark) {
      let keyValues = queryStringWithoutQuestionMark.split('&');
      keyValues.forEach((keyValue) => {
        let pair = keyValue.split('=');
        let key = decodeURIComponent(pair[0]);
        let value = decodeURIComponent(pair[1]);
        params.set(key, value)
      })
    }
    return params;
  }

}
```

## 第三方Navigation实例使用本库的API

如果第三方Navigation实例使用本库的API，需要将第三方Navigation的NavPathStack实例注册到ZRouter中，代码示例：

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

上面是模拟代码，具体注册的时机需要根据实际情况来定。NAV_STACK_NAME是一个自定义常量，用于标识导航栈的名称。

页面跳转：


```typescript
  Column({ space: 15 }) {
      Text(this.msg)
      Button("EmptyPage").onClick((event: ClickEvent) => {
        ZRouter.getInstance(NAV_STACK_NAME).push("PageNotFound")
      })

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
把标识导航栈的名称NAV_STACK_NAME，传入到ZRouter.getInstance()方法中，就可以使用ZRouter相关的API了。

## @Route装饰器上使用常量

router-register-plugin插件1.0.7版本起，@Route装饰器上的name属性支持使用静态常量，方便统一管理路由名称；静态常量支持当前模块或跨模块定义，常量的定义模版如下：

```typescript
export class RouterConstants {
  public static readonly URL_TEST_PAGE: string = "url_test";
  public static readonly HARA_MAIN_PAGE :string = "harAMainPage"
}
```
> 如果路由常量在一个公共模块定义，建议在模块的Index.ets文件导出，另外RouterConstants的文件必须是.ets后缀，不支持ts后缀文件。[具体可参考案例](https://gitee.com/common-apps/ZRouter/tree/master/library/common_library)



## 混淆

在混淆时需要在每个模块添加如下配置：

```
-keep-file-name
_generated
ZR*
```

**插件必须是1.0.6版本后才支持混淆，之前版本不支持混淆。**

## 原理

路由注册流程的代码自动化生成，其原理是不难的，就是通过自定义Hvigor插件扫描指定目录的ets文件，递归解析ets文件的语法树节点，查找出自定义装饰器@Route对应的文件，然后解析出装饰器和页面上的信息，最后将这些信息通过模板引擎在编译阶段生成Builder注册函数，路由表配置通过文件读写来写入数据。

> 这与Java 注解处理器APT原理是类似的

ZRouter库是对NavPathStack对进行高度封装的，提供了更加简单易用的API。

插件实现流程图：

<center>

![84fbcf502ec66b87981622eaf57499e4.png](https://www.z4a.net/images/2024/10/17/84fbcf502ec66b87981622eaf57499e4.png)

</center>


## 源码

- gitee：https://gitee.com/common-apps/ZRouter
- github：https://github.com/751496032/ZRouter

## 交流

使用有疑问或建议， **请在github或gitee上提交issues（可以有效收集大家的问题，会在第一时间处理）** ，或者在进群交流(+v: 751496032)。































