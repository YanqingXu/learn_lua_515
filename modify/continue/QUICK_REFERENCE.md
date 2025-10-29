# Continue 关键字 - 快速参考卡

## 📌 一页速查

### 基本语法
```lua
for i = 1, 10 do
    if condition then
        continue  -- 跳过剩余代码，进入下一迭代
    end
    -- 处理代码
end
```

### 支持的循环
- ✅ while 循环
- ✅ for 数值循环  
- ✅ for 泛型循环 (ipairs/pairs)
- ✅ repeat-until 循环

### 不支持的位置
- ❌ 循环外
- ❌ 函数内（没有循环的情况）

---

## 🎯 常见用法

### 用法 1: 跳过不符合条件的项
```lua
for i = 1, 10 do
    if i % 2 == 0 then
        continue  -- 跳过偶数
    end
    print(i)  -- 输出: 1, 3, 5, 7, 9
end
```

### 用法 2: 数据验证和过滤
```lua
for _, user in ipairs(users) do
    if not user.active then
        continue
    end
    if not user.email then
        continue
    end
    process(user)  -- 只处理有效用户
end
```

### 用法 3: 跳过异常值
```lua
while stream:has_data() do
    local val = stream:read()
    if val < 0 or val > 100 then
        continue  -- 跳过异常值
    end
    sum = sum + val
end
```

---

## 📊 Continue vs Break

| 特性 | Continue | Break |
|------|----------|-------|
| 效果 | 进入下一迭代 | 退出循环 |
| 循环继续 | 是 | 否 |
| 剩余代码 | 被跳过 | 都被跳过 |

```lua
for i = 1, 5 do
    if i == 3 then
        continue
    end
    print(i)
end
-- 输出: 1 2 4 5

for i = 1, 5 do
    if i == 3 then
        break
    end
    print(i)
end
-- 输出: 1 2
```

---

## ⚠️ 常见错误

### ❌ 在循环外使用
```lua
continue  -- Error: no loop to continue
```

### ❌ Continue 后的代码不执行
```lua
if x > 10 then
    continue
    print("Never prints")  -- 永不执行
end
```

### ⚠️ 嵌套循环中的 Continue
```lua
for i = 1, 3 do
    for j = 1, 3 do
        if j == 2 then
            continue  -- 只影响内层循环
        end
        print(i, j)
    end
end
-- Continue 只跳过内层循环
```

---

## ✅ 最佳实践

### ✅ DO: 用于跳过异常情况
```lua
for item in items do
    if not valid(item) then
        continue
    end
    process(item)
end
```

### ✅ DO: 保持条件简单
```lua
if should_skip(value) then
    continue
end
```

### ❌ DON'T: 过度嵌套的 Continue
```lua
if cond1 then
    continue
elseif cond2 then
    continue
elseif cond3 then
    continue
end
-- 改为: if cond1 or cond2 or cond3 then continue end
```

### ❌ DON'T: 复杂条件
```lua
if (x > 10 and y < 5) or (z == nil) then
    continue
end
-- 提取到函数: if should_skip(x, y, z) then continue end
```

---

## 🔄 控制流

### While 循环
```
条件检查 ← [Continue 跳转目标]
    ↓
循环体
    ↓ (continue)
[回到条件检查]
```

### For 循环
```
循环初始化
循环控制 ← [Continue 跳转目标]
    ↓
循环体
    ↓ (continue)
[回到循环控制]
```

### Repeat 循环
```
循环体 ← [Continue 跳转目标]
    ↓ (continue)
[回到循环体]
    ↓
条件检查
```

---

## 📝 实际例子

### 例子 1: 列表过滤
```lua
local result = {}
for i, v in ipairs(data) do
    if v < 0 then continue end      -- 跳过负数
    if v > 100 then continue end    -- 跳过超过 100 的
    table.insert(result, v)
end
```

### 例子 2: 文件处理
```lua
for line in io.lines("file.txt") do
    if line == "" then continue end           -- 跳过空行
    if line:match("^%s*#") then continue end -- 跳过注释
    process(line)
end
```

### 例子 3: 嵌套循环
```lua
for i = 1, 10 do
    for j = 1, 10 do
        if i + j == 10 then continue end
        print(i, j)
    end
end
```

### 例子 4: While 循环
```lua
local i = 0
while i < 100 do
    i = i + 1
    if i % 2 == 0 then continue end
    print(i)  -- 打印奇数
end
```

---

## 🛠️ 测试方法

### 快速测试
```lua
for i = 1, 5 do
    if i == 3 then
        continue
    end
    print(i)
end
-- 应输出: 1 2 4 5
```

### 验证嵌套循环
```lua
for i = 1, 2 do
    for j = 1, 2 do
        if j == 1 then continue end
        print(i, j)
    end
end
-- 应输出: 1,2  2,2
```

---

## 🎓 理解继续流

### 什么时候使用 Continue?

1. **需要跳过当前项**: ✅ 使用 continue
2. **需要完全退出循环**: ❌ 使用 break
3. **需要修改条件**: ❌ 使用 break 或反向条件
4. **多层跳出**: ❌ 使用标志或返回值

### 替代方案对比

**使用 Continue**:
```lua
for i = 1, 10 do
    if skip_condition then continue end
    process(i)
end
```

**使用反向条件**:
```lua
for i = 1, 10 do
    if not skip_condition then
        process(i)
    end
end
```

**选择建议**: 
- 少量条件 → 反向条件
- 多个条件 → continue
- 复杂逻辑 → 提取函数

---

## 📚 相关资源

- **详细说明**: CONTINUE_KEYWORD_IMPLEMENTATION.md
- **使用指南**: USAGE_GUIDE.md
- **验证报告**: VERIFICATION_REPORT.md
- **完整总结**: IMPLEMENTATION_SUMMARY.md

---

## 🚀 快速开始

### 第 1 步: 编译
```bash
make clean && make
```

### 第 2 步: 创建测试文件
```bash
cat > test.lua << EOF
for i = 1, 5 do
    if i % 2 == 0 then continue end
    print(i)
end
EOF
```

### 第 3 步: 运行
```bash
./lua test.lua
```

### 第 4 步: 验证输出
```
1
3
5
```

---

## 💻 命令速查

| 任务 | 命令 |
|------|------|
| 编译项目 | `make clean && make` |
| 运行 Lua | `./lua test.lua` |
| 交互模式 | `./lua` |
| 查看版本 | `./lua -v` |

---

## ❓ 常见问题

### Q: Continue 会不会影响性能?
**A**: 不会。Continue 就是一条跳转指令，性能开销与 break 相同。

### Q: 能否 Continue 多层循环?
**A**: 不能。Continue 只影响最内层循环。需要跳出多层用 break 或返回值。

### Q: Continue 和 Return 的区别?
**A**: Continue 在循环中跳到下一迭代，Return 退出函数。

### Q: 能否在函数中的循环用 Continue?
**A**: 能。Continue 作用于循环，不受函数影响。

### Q: Continue 前的 IO 操作会执行吗?
**A**: 会。Continue 跳过的是后续代码，前面的代码都会执行。

---

## 🔗 语法要点

### ✅ 有效用法
```lua
while condition do
    continue
end

for i = 1, 10 do
    continue
end

repeat
    continue
until condition

-- 条件 continue
if flag then
    continue
end
```

### ❌ 无效用法
```lua
continue          -- 循环外
function foo()
    continue      -- 函数内无循环
end

if x > 5 then
    -- 无循环上下文
end
```

---

## 📊 特性总结

| 特性 | 支持 | 备注 |
|------|------|------|
| 基本 continue | ✅ | 标准用法 |
| 嵌套循环 | ✅ | 只影响内层 |
| 带条件 | ✅ | if + continue |
| Upvalue 安全 | ✅ | 正确处理闭包 |
| 错误检查 | ✅ | "no loop to continue" |

---

## ⏱️ 时间参考

| 操作 | 时间 |
|------|------|
| 编译 | 2-3 秒 |
| 简单测试 | < 1 秒 |
| 完整测试套件 | < 5 秒 |

---

**打印版**: 本卡可保存为 PDF 并打印留用
**最后更新**: 2024
**版本**: 1.0