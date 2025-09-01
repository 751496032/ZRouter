
## 版本更新记录

### 1.8.0 / 2025-8-31

- **服务路由支持**: `entry`模块支持服务路由，可用于底层模块调用`entry`模块的方法或组件的场景，[#ICRLKS](https://gitee.com/common-apps/ZRouter/issues/ICRLKS)；
- **元服务支持**: 路由跳转支持元服务`hsp`模块动态加载 [#ICQ22O](https://gitee.com/common-apps/ZRouter/issues/ICQ22O)；
- **拦截器增强**: 拦截器方法支持获取页面`@Route`注解中的配置参数 [#ICSAC5](https://gitee.com/common-apps/ZRouter/issues/ICSAC5)；
- **路由预加载**: 支持路由表预加载，默认在工作线程执行，不影响启动速度；
- **返回处理优化**: 修复`hideNavbar`模式下的返回问题，支持自定义返回拦截 [#ICNNJF](https://gitee.com/common-apps/ZRouter/issues/ICNNJF)；
- **缓存优化**: 优化路由缓存的回收机制；
- [接口API变更](https://gitee.com/common-apps/ZRouter/blob/main/%E6%8E%A5%E5%8F%A3%E5%88%97%E8%A1%A8.md)
  - 新增初始化参数`isRoutePreloadEnabled`、`isRoutePreloadThreadEnabled`等参数；
  - 新增`routerMap`方法，获取已经注册的所有路由表信息；
  - 新增`getActiveRouteInfos`方法，获取已入路由栈的所有页面；
  - 新增`popToRoot`返回首页根视图方法；
  - 新增`navigateBack`返回聚合方法，支持所有返回场景；
  - `popWithResult`和`finishWithResult`方法合并 [#ICSZ6X](https://gitee.com/common-apps/ZRouter/issues/ICSZ6X)。
  
**注意：路由编译插件需要升级到1.8.0以上版本。**

### 1.6.1 / 2025-8-5

- 拦截器支持获取页面跳转配置，比如启动模式、动画开关等；
- 兼容支持`hideNavbar`模式；
- 修复`NavDestBuilder#popWithResult`携带参数为`false`时无法接收的问题；

### 1.6.0 / 2025-6-27

- 新增`@Builder`函数参数传递，支持页面组件参数直接传递 — 插件需要升级到1.6.0；
- 新增拦截器`pop`监听；
- 修复拦截器异步操作失效的问题。

### 1.5.0 / 2025-5-26

- 新增一镜到底动画；
- 修复路由注解类型提示问题；
- 路由插件1.5.0版本
  - 支持工程级(全局配置)和模块级(模块独立配置)两种方式配置；
  - 支持项目`clean`时自动删除编译产物；
  - 优化构建效率，减少不必要的场景扫描构建生成；新增配置项`ignoredModules`，工程级配置可设置忽略模块，避免扫描所有模块；新增配置项`enableUiPreviewBuild`，避免在ui预览构建时生成, 影响ui预览效率。



### 1.4.1 / 2025-4-27

- 适配审核，修改`agcit_`。

### 1.4.0 / 2025-4-24

- 修复升级1.3.9后的编译错误；
- 修复拦截器`onNavigateBefore()`方法`name`参数不生效问题；

### 1.3.9 / 2025-4-19

- 全局拦截器：新增 `onNavigateBefore()` 方法，用于在路由跳转前进行拦截操作；
- 新增`popToNameWithResult()` api，用于携带结果返回指定页面，中间页面会关闭；
- `@Route`注解可省略属性，生成的路由名为当前页面的类名；
- 修复跳转hsp页面出现闪退问题；
- `popNavWithResult` 、`enableCrossPageParamReturn` 已废弃。

### 1.3.6 / 2025-3-17

- 修复页面模板化时的生命周期函数不执行问题；

### 1.3.5 / 2025-3-11

- 优化获取`getParamByKey()`方法，支持设置默认参数；
- 优化生命周期管理，添加根页面判断逻辑；
- 新增`replaceWithDefaultAnim() `api，解决replace页面无动画的问题；
- 重定向新增REMOVE类型。

### 1.3.4 / 2025-2-12

- 修复`setParam`携带参数问题，处理Array等类型参数；
- 优化`ZRouter.getInstance()`、`popResult()`等api；

### 1.3.3 / 2025-2-6

- 修复`setParam`携带参数问题；

### 1.3.2 / 2025-1-23

- 修复`setParam`携带参数问题，默认不处理false和0;

### 1.3.1 / 2025-1-11

- 修复动画在ArkUI-X上的兼容问题；
- 修复`setParam`携带参数问题，支持false和0;
- 修复启动模式在api11上闪退问题。

### 1.3.0 / 2024-12-24

- `NavDestination`页面模板化支持V2状态管理，编译插件需要升级到1.3.0版本；
- `NavDestination`页面模板化的生命周期实现类属性支持全局和单个页面自定义命名；
- 新增如下api：
  - `removeInterceptor`：移除拦截器；
  - `withParam`：携带页面参数，key-value形式；
  - `getParamByKey`：获取页面参数，根据key获取；
  - `setModuleLoadedListener`：设置动态模块加载状态监听；
  - `isDynamicLoadedComplete`：判断动态模块是否加载完成；
- 修复普通拦截器在`replace`路由操作时不生效的问题；
- 修复全局拦截器页面首次跳转时`onPageWillShow()`方法不执行的问题；
- 修复路由重定向问题，新增了重定向的类型;

### 1.2.0 / 2024-12-8

- 新增`NavDestination`页面模板化能力，编译插件需要升级到1.2.0版本；
- 新增`@ZRoute`、`@ZService`、`@ZLifecycle`、`@ZAttribute`注解，其中`@ZLifecycle`和`@ZAttribute`用于辅助页面模板化能力；
- 转场动画新增高斯模糊效果；
- `ZRouter`的路由静态方法标记为过期状态，建议使用`NavDestBuilder`的方法进行路由操作。

### 1.1.1

- 新增转场动画（平移、旋转、渐变、缩放），支持自定义动画；
- 修复路由初始化的问题；

### 1.1.0

- 新增组生命周期函数管理；
- 修复`popWithResult()`不支持布尔类型值的问题；

### 1.0.10

- 修复在`hsp`模块跳转失败问题

### 1.0.9

- 新增服务路由，可用于相互独立的`Har/Hsp`模块之间的通信；路由插件必须在1.0.9以上才支持；


### 1.0.8

- 修复拦截器问题；
- 插件1.0.7版本支持`@Route`装饰器设置常量。

### 1.0.7

- 支持启动模式；
- 重构拦截器，支持拦截器的优先级设置，全局拦截器支持页面显示监听；
- 支持自定义URL路径跳转；
- 支持第三方`Navigation`系统路由表使用本库API。

### 1.0.6

- 支持混淆，插件必须是1.0.6版本后才支持混淆，之前版本不支持混淆。

### 1.0.4

- 修复`getParam`问题
- 新增`redirectForResult2`、`finishWithResult` api，两者是配对使用，通常用于登录成功后，继续跳转的场景。

### 1.0.3

- 新增日志开关，在`init()`初始化设置
- 新增`pushNavForResult`、`popNavWithResult`、`popToRootWithResult`等api，可用于跨页面携带数据返回。

### 1.0.2

- 修复#3

### 1.0.1

- 插件(1.0.2)支持一个ets文件定义多个子页面
- 新增api，`remove`、`move`、`getParam`、`replace`等api

### 1.0.0

- 核心功能实现：页面跳转与拦截器



