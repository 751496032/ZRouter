
## 版本更新记录

### 1.3.3 / 2025-2-6

- 修复setParam携带参数问题；

### 1.3.2 / 2025-1-23

- 修复setParam携带参数问题，默认不处理false和0;

### 1.3.1 / 2025-1-11

- 修复动画在ArkUI-X上的兼容问题；
- 修复setParam携带参数问题，支持false和0;
- 修复启动模式在api11上闪退问题。

### 1.3.0 / 2024-12-24

- NavDestination页面模板化支持V2状态管理，编译插件需要升级到1.3.0版本；
- NavDestination页面模板化的生命周期实现类属性支持全局和单个页面自定义命名；
- 新增如下api：
  - removeInterceptor：移除拦截器；
  - withParam：携带页面参数，key-value形式；
  - getParamByKey：获取页面参数，根据key获取；
  - setModuleLoadedListener：设置动态模块加载状态监听；
  - isDynamicLoadedComplete：判断动态模块是否加载完成；
- 修复普通拦截器在replace路由操作时不生效的问题；
- 修复全局拦截器页面首次跳转时onPageWillShow()方法不执行的问题；
- 修复路由重定向问题，新增了重定向的类型;

### 1.2.0 / 2024-12-8

- 新增NavDestination页面模板化能力，编译插件需要升级到1.2.0版本；
- 新增@ZRoute、@ZService、@ZLifecycle、@ZAttribute注解，其中@ZLifecycle和@ZAttribute用于辅助页面模板化能力；
- 转场动画新增高斯模糊效果；
- ZRouter的路由静态方法标记为过期状态，建议使用NavDestBuilder的方法进行路由操作。

### 1.1.1

- 新增转场动画（平移、旋转、渐变、缩放），支持自定义动画；
- 修复路由初始化的问题；

### 1.1.0

- 新增组生命周期函数管理；
- 修复popWithResult()不支持布尔类型值的问题；

### 1.0.10

- 修复在hsp模块跳转失败问题

### 1.0.9

- 新增服务路由，可用于相互独立的Har/Hsp模块之间的通信；路由插件必须在1.0.9以上才支持；


### 1.0.8

- 修复拦截器问题；
- 插件1.0.7版本支持@Route装饰器设置常量。

### 1.0.7

- 支持启动模式；
- 重构拦截器，支持拦截器的优先级设置，全局拦截器支持页面显示监听；
- 支持自定义URL路径跳转；
- 支持第三方Navigation系统路由表使用本库API。

### 1.0.6

- 支持混淆，插件必须是1.0.6版本后才支持混淆，之前版本不支持混淆。

### 1.0.4

- 修复getParam问题
- 新增redirectForResult2、finishWithResult api，两者是配对使用，通常用于登录成功后，继续跳转的场景。

### 1.0.3

- 新增日志开关，在init()初始化设置
- 新增pushNavForResult、popNavWithResult、popToRootWithResult等api，可用于跨页面携带数据返回。

### 1.0.2

- 修复#3

### 1.0.1

- 插件(1.0.2)支持一个ets文件定义多个子页面
- 新增api，remove、move、getParam、replace等api

### 1.0.0

- 核心功能实现：页面跳转与拦截器



