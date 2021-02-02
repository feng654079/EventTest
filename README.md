# EventTest
平时写的小Demo,都放在一起了.
每个测试都有一个viewcontroler在main.storyboard中,切换不同的测试请在main.storyboard中设置 initial view controller

## TelInput
微信登录页面 手机号输入的效果

## PerfectLock
封装了锁的获取,在 iOS10.0之前和之后分别获取性能较好的锁

### SafeTimer 

SafeTimer 是一个基于DispatchSourceTimer, 系统的DispatchSourceTimer有以下几个坑点:
1.多次连续调用resume 和 suspend  一次以上就会崩溃
2.在timer的状态为suspend状态时, 如果其作为属性释放,引起EXC_BAD_INSTRUCTION崩溃


SecondsCountDowner 是一个基于SafeTimer疯转的倒计时工具

RunloopMonitor 是一个runloop 监听工具,对其所有的delegete 对象弱引用,使调用者免去管理监听runloop的烦恼

MainThreadStuckMonitor是一个监听主线程runloop卡顿的工具,基于RunloopMonitor封装


## EvaluateExpressionParser
一个算数表达式解析器,可以解析加减乘除运算,不支持代数运算,使用了后缀表达式.但是感觉实现的方式不太对.

## AsyncRender 
测试异步渲染
