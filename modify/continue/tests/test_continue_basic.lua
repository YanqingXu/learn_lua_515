#!/usr/bin/env lua
-- ============================================================================
-- Continue 关键字基础功能测试
-- 测试基本的 continue 语句在各种循环中的功能
-- ============================================================================

print("=" .. string.rep("=", 70))
print("Continue 关键字 - 基础功能测试")
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

-- 辅助函数：捕获输出
local function capture_output(func)
    local result = {}
    local old_print = print
    _G.print = function(...)
        local args = {...}
        local str = ""
        for i, v in ipairs(args) do
            if i > 1 then str = str .. "\t" end
            str = str .. tostring(v)
        end
        table.insert(result, str)
    end
    func()
    _G.print = old_print
    return table.concat(result, "\n")
end

print("\n" .. string.rep("-", 70))
print("测试组 1: For 数值循环中的 Continue")
print(string.rep("-", 70))

-- Test 1: 基本 for 循环跳过偶数
do
    local result = {}
    for i = 1, 10 do
        if i % 2 == 0 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "For循环跳过偶数",
        "1,3,5,7,9",
        table.concat(result, ",")
    )
end

-- Test 2: For 循环跳过特定值
do
    local result = {}
    for i = 1, 5 do
        if i == 3 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "For循环跳过特定值(3)",
        "1,2,4,5",
        table.concat(result, ",")
    )
end

-- Test 3: For 循环多个 continue 条件
do
    local result = {}
    for i = 1, 10 do
        if i % 2 == 0 then
            continue
        end
        if i > 7 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "For循环多个continue条件",
        "1,3,5,7",
        table.concat(result, ",")
    )
end

-- Test 4: For 循环倒序
do
    local result = {}
    for i = 10, 1, -1 do
        if i % 3 == 0 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "For循环倒序跳过3的倍数",
        "10,8,7,5,4,2,1",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 2: While 循环中的 Continue")
print(string.rep("-", 70))

-- Test 5: 基本 while 循环
do
    local result = {}
    local i = 0
    while i < 10 do
        i = i + 1
        if i % 2 == 0 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "While循环跳过偶数",
        "1,3,5,7,9",
        table.concat(result, ",")
    )
end

-- Test 6: While 循环多个条件
do
    local result = {}
    local i = 0
    while i < 20 do
        i = i + 1
        if i < 5 then
            continue
        end
        if i > 15 then
            continue
        end
        if i % 2 == 0 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "While循环复合条件",
        "5,7,9,11,13,15",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 3: Repeat-Until 循环中的 Continue")
print(string.rep("-", 70))

-- Test 7: 基本 repeat-until 循环
do
    local result = {}
    local i = 0
    repeat
        i = i + 1
        if i % 2 == 0 then
            continue
        end
        table.insert(result, i)
    until i >= 10
    test_result(
        "Repeat循环跳过偶数",
        "1,3,5,7,9",
        table.concat(result, ",")
    )
end

-- Test 8: Repeat-until 条件在 continue 前
do
    local result = {}
    local i = 0
    repeat
        i = i + 1
        if i == 5 then
            continue
        end
        table.insert(result, i)
    until i >= 8
    test_result(
        "Repeat循环跳过特定值",
        "1,2,3,4,6,7,8",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 4: For 泛型循环 (ipairs/pairs)")
print(string.rep("-", 70))

-- Test 9: ipairs 循环
do
    local input = {10, 20, 30, 40, 50}
    local result = {}
    for i, v in ipairs(input) do
        if v % 20 == 0 then
            continue
        end
        table.insert(result, v)
    end
    test_result(
        "ipairs循环跳过20的倍数",
        "10,30,50",
        table.concat(result, ",")
    )
end

-- Test 10: pairs 循环（表）
do
    local input = {a = 1, b = 2, c = 3, d = 4}
    local result = {}
    for k, v in pairs(input) do
        if v % 2 == 0 then
            continue
        end
        table.insert(result, k .. "=" .. v)
    end
    table.sort(result)
    test_result(
        "pairs循环跳过偶数值",
        "a=1,c=3",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 5: 嵌套循环中的 Continue")
print(string.rep("-", 70))

-- Test 11: 嵌套 for 循环 - 内层 continue
do
    local result = {}
    for i = 1, 3 do
        for j = 1, 3 do
            if j == 2 then
                continue
            end
            table.insert(result, i .. "," .. j)
        end
    end
    test_result(
        "嵌套循环-内层continue",
        "1,1,1,3,2,1,2,3,3,1,3,3",
        table.concat(result, ",")
    )
end

-- Test 12: 嵌套 for 循环 - 外层 continue
do
    local result = {}
    for i = 1, 4 do
        if i == 2 then
            continue
        end
        for j = 1, 2 do
            table.insert(result, i .. "," .. j)
        end
    end
    test_result(
        "嵌套循环-外层continue",
        "1,1,1,2,3,1,3,2,4,1,4,2",
        table.concat(result, ",")
    )
end

-- Test 13: 嵌套循环 - 双层 continue
do
    local result = {}
    for i = 1, 4 do
        if i == 3 then
            continue
        end
        for j = 1, 4 do
            if j == 2 then
                continue
            end
            table.insert(result, i .. j)
        end
    end
    test_result(
        "嵌套循环-双层continue",
        "11,13,14,21,23,24,41,43,44",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 6: Continue 与其他控制流")
print(string.rep("-", 70))

-- Test 14: Continue 与 if-else
do
    local result = {}
    for i = 1, 10 do
        if i % 3 == 0 then
            continue
        elseif i % 2 == 0 then
            table.insert(result, "even-" .. i)
        else
            table.insert(result, "odd-" .. i)
        end
    end
    test_result(
        "Continue与if-else",
        "odd-1,even-2,even-4,odd-5,odd-7,even-8,even-10",  -- i=3,6,9 被 continue 跳过
        table.concat(result, ",")
    )
end

-- Test 15: Continue 在条件块内
do
    local result = {}
    for i = 1, 10 do
        if i <= 5 then
            if i % 2 == 0 then
                continue
            end
            table.insert(result, "A" .. i)
        else
            if i % 2 == 1 then
                continue
            end
            table.insert(result, "B" .. i)
        end
    end
    test_result(
        "Continue在嵌套条件块内",
        "A1,A3,A5,B6,B8,B10",
        table.concat(result, ",")
    )
end

print("\n" .. string.rep("-", 70))
print("测试组 7: 边界条件测试")
print(string.rep("-", 70))

-- Test 16: 空循环体（只有 continue）
do
    local count = 0
    for i = 1, 5 do
        count = count + 1
        continue
    end
    test_result(
        "空循环体(只有continue)",
        5,
        count
    )
end

-- Test 17: Continue 作为最后一条语句
do
    local result = {}
    for i = 1, 5 do
        table.insert(result, i)
        if i > 0 then
            continue
        end
    end
    test_result(
        "Continue作为最后语句",
        "1,2,3,4,5",
        table.concat(result, ",")
    )
end

-- Test 18: 循环第一次迭代就 continue
do
    local result = {}
    for i = 1, 5 do
        if i == 1 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "首次迭代即continue",
        "2,3,4,5",
        table.concat(result, ",")
    )
end

-- Test 19: 循环最后一次迭代 continue
do
    local result = {}
    for i = 1, 5 do
        if i == 5 then
            continue
        end
        table.insert(result, i)
    end
    test_result(
        "末次迭代continue",
        "1,2,3,4",
        table.concat(result, ",")
    )
end

-- Test 20: Continue 前后都有代码
do
    local before = 0
    local after = 0
    for i = 1, 5 do
        before = before + 1
        if i % 2 == 0 then
            continue
        end
        after = after + 1
    end
    test_result(
        "Continue前代码执行次数",
        5,
        before
    )
    test_result(
        "Continue后代码执行次数",
        3,
        after
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
    print("\n✓ 所有基础测试通过！")
    os.exit(0)
else
    print("\n✗ 有测试失败，请检查实现！")
    os.exit(1)
end