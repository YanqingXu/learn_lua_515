# Continue 关键字使用指南

## 📖 快速开始

### 基本语法

```lua
while condition do
    if skip_condition then
        continue
    end
    -- 循环体代码
end
```

`continue` 语句会：
1. 跳过当前迭代剩余的代码
2. 立即进入下一次迭代
3. 重新评估循环条件（对于 while/for 循环）

## 📚 实际例子

### 例子 1: 过滤偶数

**不使用 continue 的方式**:
```lua
for i = 1, 10 do
    if i % 2 == 0 then
        -- 什么都不做（空循环）
    else
        print(i)
    end
end
```

**使用 continue 的方式** (更简洁):
```lua
for i = 1, 10 do
    if i % 2 == 0 then
        continue
    end
    print(i)  -- 输出: 1, 3, 5, 7, 9
end
```

### 例子 2: 数据处理与验证

**场景**: 处理用户输入列表，跳过无效项

```lua
local users = {
    {name = "Alice", age = 25},
    {name = nil, age = 30},        -- 无效（无名字）
    {name = "Bob", age = -5},      -- 无效（年龄不合法）
    {name = "Charlie", age = 28},
    {name = "", age = 35},         -- 无效（空名字）
}

for i, user in ipairs(users) do
    -- 验证数据
    if not user.name or user.name == "" then
        print("Warning: User " .. i .. " has no name, skipping")
        continue
    end
    
    if user.age < 0 or user.age > 120 then
        print("Warning: User " .. i .. " has invalid age, skipping")
        continue
    end
    
    -- 处理有效用户
    print("Processing user: " .. user.name .. " (" .. user.age .. ")")
end

-- 输出:
-- Warning: User 2 has no name, skipping
-- Warning: User 3 has invalid age, skipping
-- Processing user: Alice (25)
-- Processing user: Charlie (28)
```

### 例子 3: 嵌套循环中的 Continue

**场景**: 生成乘法表，跳过某些行

```lua
print("乘法表 (跳过 5 和 10 的倍数)")
for i = 1, 12 do
    if i == 5 or i == 10 then
        continue  -- 跳过 5 和 10
    end
    
    for j = 1, 12 do
        if j == 5 or j == 10 then
            continue  -- 跳过列
        end
        io.write(string.format("%3d ", i * j))
    end
    print()
end
```

### 例子 4: 文件处理

**场景**: 逐行读取文件，跳过注释和空行

```lua
local function process_config_file(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Cannot open file"
    end
    
    local config = {}
    for line in file:lines() do
        -- 跳过空行
        if line:match("^%s*$") then
            continue
        end
        
        -- 跳过注释行
        if line:match("^%s*#") then
            continue
        end
        
        -- 处理配置行
        local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and value then
            config[key] = value
        end
    end
    
    file:close()
    return config
end

-- 使用示例
local cfg = process_config_file("config.txt")
```

### 例子 5: 搜索和过滤

**场景**: 在列表中查找满足条件的项

```lua
local function find_active_users(users)
    local active = {}
    
    for _, user in ipairs(users) do
        -- 跳过已禁用的用户
        if user.disabled then
            continue
        end
        
        -- 跳过没有邮箱的用户
        if not user.email then
            continue
        end
        
        -- 跳过未验证的邮箱
        if not user.email_verified then
            continue
        end
        
        -- 这个用户满足条件，添加到结果
        table.insert(active, user)
    end
    
    return active
end
```

### 例子 6: While 循环处理

**场景**: 处理数据流，跳过特殊项

```lua
local function process_stream(stream)
    while stream:has_data() do
        local item = stream:read()
        
        -- 跳过哨兵值
        if item.type == "SENTINEL" then
            continue
        end
        
        -- 跳过已处理过的项
        if cache[item.id] then
            continue
        end
        
        -- 处理新项
        process_item(item)
        cache[item.id] = true
    end
end
```

### 例子 7: Repeat-Until 循环

**场景**: 游戏循环，跳过某些帧

```lua
local function game_loop()
    local frame = 0
    repeat
        frame = frame + 1
        
        -- 如果游戏暂停，跳过此帧的游戏逻辑
        if game_state == "PAUSED" then
            render_ui()  -- 仍然渲染 UI
            continue     -- 但跳过游戏逻辑
        end
        
        -- 游戏逻辑
        update_physics()
        update_entities()
        handle_collisions()
        
        -- 渲染
        render()
        
    until quit_requested or frame > 1000000
end
```

## 🔄 与 Break 的对比

### Break vs Continue

| 特性 | Break | Continue |
|------|-------|----------|
| 作用 | 完全退出循环 | 跳到下一次迭代 |
| 循环体代码 | 都被跳过 | 后续代码被跳过 |
| 条件重评 | N/A（循环结束） | 是（对 while/for） |
| 返回值 | 终结语句 | 非终结语句 |

### 对比示例

```lua
-- 使用 Break 的例子
print("Using break:")
for i = 1, 5 do
    if i == 3 then
        break  -- 完全退出循环
    end
    print(i)
end
-- 输出: 1, 2

print("Using continue:")
for i = 1, 5 do
    if i == 3 then
        continue  -- 跳过这一次，继续循环
    end
    print(i)
end
-- 输出: 1, 2, 4, 5
```

## ⚠️ 常见错误

### 错误 1: 在循环外使用 Continue

```lua
-- ❌ 错误
continue  -- Error: no loop to continue
```

**修复**:
```lua
-- ✅ 正确
for i = 1, 10 do
    if i == 5 then
        continue
    end
end
```

### 错误 2: Continue 后面的代码不会执行

```lua
for i = 1, 5 do
    print("Before continue: " .. i)
    continue
    print("After continue: " .. i)  -- 这行永不执行
end
-- 输出:
-- Before continue: 1
-- Before continue: 2
-- ...
```

这是预期的行为。如果需要执行某些代码，应该把它放在 continue 前面。

### 错误 3: 误用 Continue 替代条件

```lua
-- ❌ 不推荐（容易出错）
for i = 1, 10 do
    if i % 2 == 0 then
        continue
    end
    print(i)
end

-- ✅ 更清晰的写法
for i = 1, 10 do
    if i % 2 == 1 then  -- 正向逻辑
        print(i)
    end
end
```

## 🎯 最佳实践

### 1. 优先使用正向条件

```lua
-- ❌ 多层 continue（难以理解）
for i = 1, 100 do
    if condition1 then
        continue
    end
    if condition2 then
        continue
    end
    if condition3 then
        continue
    end
    process(i)
end

-- ✅ 单一正向条件（清晰）
for i = 1, 100 do
    if condition1 or condition2 or condition3 then
        continue
    end
    process(i)
end

-- ✅ 或者使用 elseif（同样清晰）
for i = 1, 100 do
    if condition1 then
        continue
    elseif condition2 then
        continue
    elseif condition3 then
        continue
    else
        process(i)
    end
end
```

### 2. 使用 Continue 处理异常情况

```lua
-- ✅ 好的模式：主路径清晰，异常用 continue 处理
for item in items:iterate() do
    -- 跳过异常
    if not is_valid(item) then
        continue
    end
    if is_deleted(item) then
        continue
    end
    
    -- 主要处理逻辑
    process(item)
end
```

### 3. 保持 Continue 语句简短

```lua
-- ✅ 推荐：continue 条件简单
if should_skip(value) then
    continue
end

-- ❌ 不推荐：复杂的条件应该提取到函数
if (value.x > 10 and value.y < 5) or 
   (value.z == nil) or 
   (value.type == "invalid") then
    continue
end
```

### 4. 在嵌套循环中注意 Continue 的作用域

```lua
-- ✅ Continue 只影响最内层循环
for i = 1, 3 do
    for j = 1, 3 do
        if j == 2 then
            continue  -- 只跳过内层循环
        end
        print(i, j)
    end
    -- 外层循环继续
end

-- 如果需要跳过外层循环，使用 break 或标签
for i = 1, 3 do
    for j = 1, 3 do
        if some_condition then
            break  -- 跳出内层循环
        end
    end
end
```

## 🧪 测试技巧

### 验证 Continue 行为

```lua
local function test_continue()
    print("Test 1: Basic continue")
    local count = 0
    for i = 1, 10 do
        if i % 2 == 0 then
            continue
        end
        count = count + 1
    end
    assert(count == 5, "Expected 5, got " .. count)
    print("✓ Test 1 passed")
    
    print("Test 2: Nested loops")
    local found = false
    for i = 1, 3 do
        for j = 1, 3 do
            if i == 2 and j == 2 then
                found = true
                break
            end
            if j == 2 then
                continue
            end
        end
    end
    assert(found, "Failed to find target")
    print("✓ Test 2 passed")
    
    print("Test 3: While loop")
    local sum = 0
    local i = 0
    while i < 5 do
        i = i + 1
        if i == 3 then
            continue
        end
        sum = sum + i
    end
    assert(sum == 12, "Expected 12 (1+2+4+5), got " .. sum)
    print("✓ Test 3 passed")
end

test_continue()
```

## 📊 性能考虑

### Continue 的性能

- **编译时**: 与 `break` 相同的开销
- **运行时**: 一条跳转指令，无额外开销
- **内存**: 循环每多一个 `continue` 增加一条跳转指令

### 优化建议

1. **避免过多的 continue 语句**
   ```lua
   -- 对于多个 continue，考虑重构代码
   local count = 0
   for i = 1, 1000000 do
       if not is_valid(i) then continue end
       if is_deleted(i) then continue end
       if is_expired(i) then continue end
       count = count + 1
   end
   
   -- 可以考虑改为
   local count = 0
   for i = 1, 1000000 do
       if is_valid(i) and not is_deleted(i) and not is_expired(i) then
           count = count + 1
       end
   end
   ```

## 🔗 与其他语言的对比

### Python
```python
# Python 中的 continue
for i in range(1, 6):
    if i % 2 == 0:
        continue
    print(i)
```

### Lua 5.1.5 (带 Continue)
```lua
-- 与 Python 一样的语义
for i = 1, 5 do
    if i % 2 == 0 then
        continue
    end
    print(i)
end
```

### JavaScript
```javascript
// JavaScript 中的 continue
for (let i = 1; i <= 5; i++) {
    if (i % 2 === 0) continue;
    console.log(i);
}
```

## 📚 相关文档

- 详细实现说明: `CONTINUE_KEYWORD_IMPLEMENTATION.md`
- 验证报告: `VERIFICATION_REPORT.md`
- 编译指南: 项目根目录的 `README.md`

## ✅ 总结

- ✅ `continue` 用于跳过当前迭代的剩余代码
- ✅ 支持所有循环类型：while、for、repeat
- ✅ 只能在循环内使用
- ✅ 在嵌套循环中只影响最内层循环
- ✅ 性能开销最小
- ✅ 代码更清晰简洁

---

**最后更新**: 2024
**适用版本**: Lua 5.1.5 (带 Continue 支持)