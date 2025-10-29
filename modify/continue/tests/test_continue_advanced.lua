#!/usr/bin/env lua
-- ============================================================================
-- Continue 关键字高级功能测试
-- 测试复杂场景、边界条件和实际应用场景
-- ============================================================================

print("=" .. string.rep("=", 70))
print("Continue 关键字 - 高级功能测试")
print("=" .. string.rep("=", 70))

local test_count = 0
local pass_count = 0
local fail_count = 0

-- 辅助函数：测试结果验证
local function test_result(name, expected, actual)
    test_count = test_count + 1
    local result = expected == actual
    if result then
        pass_count = pass_count + 1
        print(string.format("✓ TEST %d PASSED: %s", test_count, name))
    else
        fail_count = fail_count + 1
        print(string.format("✗ TEST %d FAILED: %s", test_count, name))
        print(string.format("  Expected: %s", tostring(expected)))
        print(string.format("  Got:      %s", tostring(actual)))
    end
    return result
end

print("\n" .. string.rep("-", 70))
print("测试组 1: 复杂嵌套循环")
print(string.rep("-", 70))

-- Test 1: 三层嵌套循环
do
    local result = {}
    for i = 1, 2 do
        for j = 1, 2 do
            for k = 1, 3 do
                if k == 2 then
                    continue
                end
                table.insert(result, i .. j .. k)
            end
        end
    end
    test_result(
        "三层嵌套-最内层continue",
        "111,113,121,123,211,213,221,223",
        table.concat(result, ",")
    )
end

-- Test 2: 混合循环类型嵌套 (for + while)
do
    local result = {}
    for i = 1, 3 do
        local j = 0
        while j < 3 do
            j = j + 1
            if j == 2 then
                continue
            end
            table.insert(result, i .. j)
        end
    end
    test_result(
        "混合嵌套(for+while)",
        "11,13,21,23,31,33",
        table.concat(result, ",")
    )
end

-- Test 3: 混合循环类型 (while + for)
do
    local result = {}
    local i = 0
    while i < 2 do
        i = i + 1
        for j = 1, 3 do
            if j == 2 then
                continue
            end
            table.insert(result, i .. j)
        end
    end
    test_result(
        "混合嵌套(while+for)",
        "11,13,21,23",
        table.concat(result, ",")
    )
end

-- Test 4: repeat + for 混合
do
    local result = {}
    local i = 0
    repeat
        i = i + 1
        for j = 1, 2 do
            if i == 2 and j == 1 then
                continue
            end
            table.insert(result, i .. j)
        end
    until i >= 2
    test_result(
        "混合嵌套(repeat+for)",
        "11,12,22",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 2: Continue 与函数交互")
print(string.rep("-", 70))

-- Test 5: Continue 在函数内的循环中
do
    local function process_items(items)
        local result = {}
        for i, v in ipairs(items) do
            if v < 0 then
                continue
            end
            table.insert(result, v)
        end
        return result
    end
    
    local output = process_items({1, -2, 3, -4, 5})
    test_result(
        "函数内循环的continue",
        "1,3,5",
        table.concat(output, ",")
    )
end

-- Test 6: 嵌套函数调用与 continue
do
    local function is_valid(x)
        return x > 0 and x < 100
    end
    
    local result = {}
    for i = -5, 105, 10 do
        if not is_valid(i) then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "Continue与函数调用",
        "5,15,25,35,45,55,65,75,85,95",
        table.concat(result, ",")
    )
end

-- Test 7: Continue 与闭包
do
    local function make_filter(threshold)
        return function(items)
            local result = {}
            for _, v in ipairs(items) do
                if v <= threshold then
                    continue
                end
                table.insert(result, v)
            end
            return result
        end
    end
    
    local filter = make_filter(5)
    local output = filter({1, 3, 5, 7, 9})
    test_result(
        "Continue与闭包",
        "7,9",
        table.concat(output, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 3: 实际应用场景")
print(string.rep("-", 70))

-- Test 8: 数据验证与过滤
do
    local users = {
        {name = "Alice", age = 25, active = true},
        {name = "Bob", age = -1, active = true},      -- 无效年龄
        {name = "", age = 30, active = true},          -- 无效名字
        {name = "Charlie", age = 35, active = false},  -- 未激活
        {name = "David", age = 40, active = true},
    }
    
    local valid_users = {}
    for _, user in ipairs(users) do
        -- 验证名字
        if not user.name or user.name == "" then
            continue
        end
        -- 验证年龄
        if user.age < 0 or user.age > 120 then
            continue
        end
        -- 验证激活状态
        if not user.active then
            continue
        end
        table.insert(valid_users, user.name)
    end
    
    test_result(
        "数据验证与过滤",
        "Alice,David",
        table.concat(valid_users, ",")
    )
end

-- Test 9: 列表处理 - 去重
do
    local items = {1, 2, 2, 3, 3, 3, 4, 5, 5}
    local result = {}
    local seen = {}
    
    for _, v in ipairs(items) do
        if seen[v] then
            continue
        end
        seen[v] = true
        table.insert(result, v)
    end
    
    test_result(
        "列表去重",
        "1,2,3,4,5",
        table.concat(result, ",")
    )
end

-- Test 10: 范围过滤
do
    local numbers = {}
    for i = 1, 100 do
        if i < 10 then
            continue
        end
        if i > 90 then
            continue
        end
        if i % 10 == 0 then
            table.insert(numbers, i)
        end
    end
    
    test_result(
        "范围过滤",
        "10,20,30,40,50,60,70,80,90",
        table.concat(numbers, ",")
    )
end

-- Test 11: 字符串处理 - 跳过空行和注释
do
    local lines = {
        "# This is a comment",
        "",
        "data1",
        "  # Another comment",
        "data2",
        "   ",
        "data3"
    }
    
    local result = {}
    for _, line in ipairs(lines) do
        -- 跳过空行
        if line:match("^%s*$") then
            continue
        end
        -- 跳过注释
        if line:match("^%s*#") then
            continue
        end
        table.insert(result, line)
    end
    
    test_result(
        "字符串处理-跳过空行注释",
        "data1,data2,data3",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 4: 性能和边界测试")
print(string.rep("-", 70))

-- Test 12: 大量迭代
do
    local count = 0
    local skipped = 0
    for i = 1, 10000 do
        count = count + 1
        if i % 2 == 0 then
            skipped = skipped + 1
            continue
        end
    end
    test_result(
        "大量迭代-总计数",
        10000,
        count
    )
    test_result(
        "大量迭代-跳过数",
        5000,
        skipped
    )
end

-- Test 13: Continue 在循环开始处
do
    local result = {}
    for i = 1, 5 do
        if true then
            if i % 2 == 0 then
                continue
            end
        end
        table.insert(result, i)
    end
    test_result(
        "Continue在循环开始处",
        "1,3,5",
        table.concat(result, ",")
    )
end

-- Test 14: 多个独立的 continue 路径
do
    local result = {}
    for i = 1, 20 do
        if i % 2 == 0 then
            continue
        end
        if i % 3 == 0 then
            continue
        end
        if i % 5 == 0 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "多个独立continue路径",
        "1,7,11,13,17,19",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 5: Continue 与局部变量")
print(string.rep("-", 70))

-- Test 15: Continue 与局部变量作用域
do
    local result = {}
    for i = 1, 5 do
        local x = i * 10
        if i % 2 == 0 then
            continue
        end
        local y = x + i
        table.insert(result, y)
    end
    test_result(
        "Continue与局部变量",
        "11,33,55",
        table.concat(result, ",")
    )
end

-- Test 16: Continue 前定义变量
do
    local sum = 0
    for i = 1, 10 do
        local temp = i * 2
        if temp % 4 == 0 then
            continue
        end
        sum = sum + temp
    end
    test_result(
        "Continue前定义变量",
        50,  -- 2+6+10+14+18 = 50, 跳过4,8,12,16,20
        sum
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 6: Continue 与表操作")
print(string.rep("-", 70))

-- Test 17: Continue 与表插入
do
    local t1 = {}
    local t2 = {}
    for i = 1, 10 do
        table.insert(t1, i)
        if i % 2 == 0 then
            continue
        end
        table.insert(t2, i)
    end
    test_result(
        "表插入-全部",
        10,
        #t1
    )
    test_result(
        "表插入-过滤后",
        5,
        #t2
    )
end

-- Test 18: Continue 与表遍历修改
do
    local input = {a = 1, b = 2, c = 3, d = 4, e = 5}
    local output = {}
    for k, v in pairs(input) do
        if v % 2 == 0 then
            continue
        end
        output[k] = v * 10
    end
    local count = 0
    for _ in pairs(output) do
        count = count + 1
    end
    test_result(
        "表遍历修改",
        3,  -- a, c, e
        count
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 7: Continue 与逻辑运算")
print(string.rep("-", 70))

-- Test 19: Continue 与 and/or
do
    local result = {}
    for i = 1, 10 do
        if (i > 3 and i < 7) or i == 9 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "Continue与and/or",
        "1,2,3,7,8,10",
        table.concat(result, ",")
    )
end

-- Test 20: Continue 与 not
do
    local result = {}
    local valid = {[2] = true, [4] = true, [6] = true}
    for i = 1, 8 do
        if not valid[i] then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "Continue与not",
        "2,4,6",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 8: 特殊场景")
print(string.rep("-", 70))

-- Test 21: Continue 与 pcall
do
    local result = {}
    for i = 1, 5 do
        local success = pcall(function()
            if i == 3 then
                error("test error")
            end
        end)
        if not success then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "Continue与pcall",
        "1,2,4,5",
        table.concat(result, ",")
    )
end

-- Test 22: Continue 与元表
do
    local t = setmetatable({1, 2, 3, 4, 5}, {
        __index = function(t, k)
            return -1
        end
    })
    
    local result = {}
    for i = 1, 7 do
        local v = t[i]
        if v == -1 then
            continue
        end
        table.insert(result, v)
    end
    test_result(
        "Continue与元表",
        "1,2,3,4,5",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("=", 70))
print("测试统计")
print(string.rep("=", 70))
print(string.format("总测试数:   %d", test_count))
print(string.format("通过数:     %d", pass_count))
print(string.format("失败数:     %d", fail_count))
print(string.format("通过率:     %.1f%%", (pass_count / test_count) * 100))

if fail_count == 0 then
    print("\n✓ 所有高级测试通过！")
    os.exit(0)
else
    print("\n✗ 有测试失败，请检查实现！")
    os.exit(1)
end