Name
====

Durap
It is lua web framework based on ngx-openresty.


Status
======

Now it just works!



A BLOG DEMO
======

http://blog.qinxunw.com




Description
===========
简要介绍
1. 基本实现了 MVC 的小框架，CodeIgniter（PHP） Like。支持多 APP，每个 APP 为一个目录，APP 之间相互独立

2. system 目录为框架代码

3. t 目录为测试集，由 test-nginx 驱动，测试 demo1 APP 的功能，需要完成 database，redis 初始化支持

4. blog 目录为相对完整 APP，在线地址： http://blog.qinxunw.com

5. router：自动路由，规则类似 CI，根据 ngx.var.router_uri 来映射 app/controller 目录下的 module，router_uri 类似 uri，在 nginx.conf 里赋值

6. model：在 system/database 下封装了 mysql, redis 的库，主要包含 connect，error log，以及 mysql 的 active record 封装
          每个 APP 有自己的 model 实现，在 app/model 目录下

7. controller：app/controller 目录下存放当前 APP 的 controller

9. loader：用来装在 APP 里的 module（controller，model，config，library，view），支持缓存

10. index.lua：框架的统一入口



License
====

This software is distributed under Apache License Version 2.0, see file LICENSE or http://www.apache.org/licenses/LICENSE-2.0
