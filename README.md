# Learn Lua 5.1.5

这是一个用于学习 Lua 5.1.5 解释器源码的仓库。

## 项目结构

- `lua/src/` - Lua 5.1.5 C 源代码
- `lua/` - Visual Studio 项目文件，用于构建 lua.exe
- `luac/` - Visual Studio 项目文件，用于构建 luac.exe（Lua 编译器）
- `bin/` - 编译后的可执行文件（在本地构建后）

## 编译说明

使用 Visual Studio 打开 `lua/lua.sln` 解决方案文件，然后构建项目即可。

构建完成后：
- `lua.exe` - Lua 解释器
- `luac.exe` - Lua 字节码编译器

## 学习目标

通过阅读和分析 Lua 5.1.5 的源代码来：
- 理解解释器的工作原理
- 学习虚拟机的实现
- 掌握垃圾回收机制
- 了解编程语言的设计思想

## Lua 5.1.5 特性

- 轻量级脚本语言
- 高效的虚拟机
- 强大的元表机制
- 协程支持
- 简洁的 C API

---

*基于 Lua 5.1.5 官方源码*