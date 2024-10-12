
## 版本更新记录

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



