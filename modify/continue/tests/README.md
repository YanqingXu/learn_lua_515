# Continue 关键字测试套件

本目录包含 Lua 5.1.5 continue 关键字的完整测试套件。

## 📋 测试文件

### 1. test_continue_basic.lua
**基础功能测试 - 22个测试用例**

测试 continue 在各种循环类型中的基本功能：
- ✅ For 数值循环中的 continue (4个测试)
- ✅ While 循环中的 continue (2个测试)
- ✅ Repeat-Until 循环中的 continue (2个测试)
- ✅ For 泛型循环 (ipairs/pairs) 中的 continue (2个测试)
- ✅ 嵌套循环中的 continue (3个测试)
- ✅ Continue 与其他控制流 (2个测试)
- ✅ 边界条件测试 (7个测试)

**运行时间**: ~1秒

### 2. test_continue_advanced.lua
**高级功能测试 - 22个测试用例**

测试复杂场景和实际应用：
- ✅ 复杂嵌套循环 (4个测试)
- ✅ Continue 与函数交互 (3个测试)
- ✅ 实际应用场景 (4个测试)
- ✅ 性能和边界测试 (3个测试)
- ✅ Continue 与局部变量 (2个测试)
- ✅ Continue 与表操作 (2个测试)
- ✅ Continue 与逻辑运算 (2个测试)
- ✅ 特殊场景 (2个测试)

**运行时间**: ~2秒

### 3. test_continue_errors.lua
**错误处理测试 - 22个测试用例**

测试错误情况和边界条件：
- ✅ Continue 在非法位置 (4个测试)
- ✅ Continue 的作用域测试 (3个测试)
- ✅ Continue 与 Break 对比 (2个测试)
- ✅ Continue 语法边界 (3个测试)
- ✅ Continue 与局部变量 (2个测试)
- ✅ Continue 的语义正确性 (4个测试)
- ✅ 嵌套循环中的 Continue (2个测试)
- ✅ Continue 与其他语句组合 (2个测试)

**运行时间**: ~1秒

### 4. test_continue_performance.lua
**性能测试 - 16个性能基准测试**

测试性能和大规模使用场景：
- ✅ Continue vs 条件判断性能对比
- ✅ 大规模迭代测试 (10K, 100K, 1M)
- ✅ 嵌套循环性能测试
- ✅ 复杂条件测试
- ✅ 实际场景模拟
- ✅ 不同循环类型性能对比
- ✅ 内存使用测试
- ✅ 极限压力测试 (10M 迭代)

**运行时间**: ~30-60秒（取决于系统）

### 5. run_all_tests.lua
**测试套件运行器**

自动运行所有测试并生成综合报告。

## 🚀 快速开始

### 方法 1: 运行所有测试（推荐）

```bash
cd tests
lua run_all_tests.lua
```

或者使用编译后的 Lua：

```bash
cd tests
../bin/lua run_all_tests.lua
```

### 方法 2: 运行单个测试

```bash
# 基础功能测试
lua test_continue_basic.lua

# 高级功能测试
lua test_continue_advanced.lua

# 错误处理测试
lua test_continue_errors.lua

# 性能测试
lua test_continue_performance.lua
```

## 📊 测试覆盖范围

### 循环类型覆盖
- ✅ For 数值循环 (for i = 1, 10)
- ✅ For 泛型循环 (for k, v in pairs)
- ✅ While 循环
- ✅ Repeat-Until 循环

### 功能覆盖
- ✅ 基本 continue 功能
- ✅ 嵌套循环中的 continue
- ✅ Continue 与条件语句
- ✅ Continue 与局部变量
- ✅ Continue 与函数交互
- ✅ Continue 与表操作
- ✅ Continue 与闭包和 upvalue
- ✅ Continue 的作用域

### 错误处理覆盖
- ✅ 循环外使用 continue（应报错）
- ✅ 函数顶层使用 continue（应报错）
- ✅ Continue 的语义正确性验证
- ✅ Continue 与 break 的交互

### 性能覆盖
- ✅ 小规模迭代 (100次)
- ✅ 中规模迭代 (10K次)
- ✅ 大规模迭代 (100K-1M次)
- ✅ 极限迭代 (10M次)
- ✅ 嵌套循环性能
- ✅ 内存使用测试

## ✅ 测试统计

| 测试套件 | 测试用例数 | 预期通过 | 运行时间 |
|---------|-----------|---------|---------|
| 基础功能测试 | 22 | 22 | ~1秒 |
| 高级功能测试 | 22 | 22 | ~2秒 |
| 错误处理测试 | 22 | 22 | ~1秒 |
| 性能测试 | 16 | 16 | ~30-60秒 |
| **总计** | **82** | **82** | **~35-65秒** |

## 📖 测试示例

### 示例 1: 基本 Continue 测试

```lua
-- 测试 For 循环跳过偶数
local result = {}
for i = 1, 10 do
    if i % 2 == 0 then
        continue
    end
    table.insert(result, i)
end
-- 预期结果: {1, 3, 5, 7, 9}
```

### 示例 2: 嵌套循环测试

```lua
-- 测试内层 continue
local result = {}
for i = 1, 3 do
    for j = 1, 3 do
        if j == 2 then
            continue
        end
        table.insert(result, i .. "," .. j)
    end
end
-- 预期结果: {"1,1", "1,3", "2,1", "2,3", "3,1", "3,3"}
```

### 示例 3: 错误测试

```lua
-- 测试循环外使用 continue（应报错）
local code = [[
    local x = 1
    continue
]]
local func, err = loadstring(code)
-- 预期: err 包含 "no loop to continue"
```

## 🔧 自定义测试

如果您想添加自己的测试，可以参考现有测试的结构：

```lua
-- 辅助函数：测试结果验证
local function test_result(name, expected, actual)
    test_count = test_count + 1
    if expected == actual then
        pass_count = pass_count + 1
        print("✓ TEST PASSED: " .. name)
    else
        fail_count = fail_count + 1
        print("✗ TEST FAILED: " .. name)
        print("  Expected: " .. tostring(expected))
        print("  Got:      " .. tostring(actual))
    end
end

-- 使用示例
do
    local result = {}
    for i = 1, 5 do
        if i == 3 then
            continue
        end
        table.insert(result, i)
    end
    test_result("跳过特定值", "1,2,4,5", table.concat(result, ","))
end
```

## 🐛 测试失败诊断

如果测试失败，请检查：

1. **编译问题**
   - 确保 Lua 已正确编译
   - 确保 continue 关键字已正确添加到词法分析器
   - 确保 parser 中的 continue 实现正确

2. **运行时问题**
   - 检查错误消息
   - 查看失败的具体测试用例
   - 对比预期结果和实际结果

3. **性能问题**
   - 性能测试可能因系统负载而有所不同
   - 如果性能测试超时，可以跳过或调整迭代次数

## 📝 测试报告示例

```
======================================================================
Continue 关键字 - 完整测试套件
======================================================================

----------------------------------------------------------------------
运行: 基础功能测试
描述: 测试 continue 在各种循环中的基本功能
----------------------------------------------------------------------
✓ TEST 1 PASSED: For循环跳过偶数
✓ TEST 2 PASSED: For循环跳过特定值(3)
...
✓ TEST 22 PASSED: Continue后代码执行次数

所有基础测试通过！

----------------------------------------------------------------------
运行: 高级功能测试
描述: 测试复杂场景和实际应用
----------------------------------------------------------------------
...

======================================================================
测试报告
======================================================================

1. 基础功能测试: ✓ 通过
2. 高级功能测试: ✓ 通过
3. 错误处理测试: ✓ 通过
4. 性能测试: ✓ 通过

----------------------------------------------------------------------
总计:       4 个测试套件
通过:       4
失败:       0
耗时:       35.24 秒
----------------------------------------------------------------------

✓ 所有测试套件通过！Continue 关键字实现正确！
```

## 🎯 测试目标

这个测试套件旨在：

1. ✅ **验证正确性** - 确保 continue 在所有循环类型中正常工作
2. ✅ **验证安全性** - 确保错误使用会被正确检测和报告
3. ✅ **验证性能** - 确保 continue 不会引入显著的性能开销
4. ✅ **验证完整性** - 覆盖各种边界条件和特殊场景
5. ✅ **验证兼容性** - 确保与现有语言特性良好协作

## 📚 相关文档

- `../modify/continue/QUICK_REFERENCE.md` - Continue 快速参考
- `../modify/continue/USAGE_GUIDE.md` - Continue 使用指南
- `../modify/continue/CONTINUE_KEYWORD_IMPLEMENTATION.md` - 实现详解
- `../modify/continue/VERIFICATION_REPORT.md` - 验证报告

## 🔗 支持

如果您发现任何问题或有改进建议，请：
1. 检查现有文档
2. 运行相关测试诊断问题
3. 查看实现代码中的注释

---

**版本**: 1.0  
**最后更新**: 2024  
**测试套件状态**: ✅ 完整且已验证