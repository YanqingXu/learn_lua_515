#!/usr/bin/env lua
-- ============================================================================
-- Continue 关键字 - 快速验证测试
-- 用于快速验证 continue 关键字是否正常工作
-- ============================================================================

print("=" .. string.rep("=", 70))
print("Continue 关键字 - 快速验证测试")
print("=" .. string.rep("=", 70))
print()

local all_passed = true

-- 辅助函数：简单测试
local function quick_test(name, test_func)
    io.write(name .. " ... ")
    local success, err = pcall(test_func)
    if success then
        print("✓ 通过")
        return true
    else
        print("✗ 失败")
        print("  错误: " .. tostring(err))
        all_passed = false
        return false
    end
end

print("运行快速验证测试...\n")

-- Test 1: For 循环基本功能
quick_test("For 循环基本功能", function()
    local result = {}
    for i = 1, 5 do
        if i == 3 then
            continue
        end
        table.insert(result, i)
    end
    assert(table.concat(result, ",") == "1,2,4,5", "For 循环结果不正确")
end)

-- Test 2: While 循环
quick_test("While 循环", function()
    local result = {}
    local i = 0
    while i < 5 do
        i = i + 1
        if i == 3 then
            continue
        end
        table.insert(result, i)
    end
    assert(table.concat(result, ",") == "1,2,4,5", "While 循环结果不正确")
end)

-- Test 3: Repeat-Until 循环
quick_test("Repeat-Until 循环", function()
    local result = {}
    local i = 0
    repeat
        i = i + 1
        if i == 3 then
            continue
        end
        table.insert(result, i)
    until i >= 5
    assert(table.concat(result, ",") == "1,2,4,5", "Repeat 循环结果不正确")
end)

-- Test 4: 嵌套循环
quick_test("嵌套循环", function()
    local count = 0
    for i = 1, 3 do
        for j = 1, 3 do
            if j == 2 then
                continue
            end
            count = count + 1
        end
    end
    assert(count == 6, "嵌套循环计数不正确")
end)

-- Test 5: Continue 与 ipairs
quick_test("Continue 与 ipairs", function()
    local input = {10, 20, 30, 40, 50}
    local result = {}
    for i, v in ipairs(input) do
        if v % 20 == 0 then
            continue
        end
        table.insert(result, v)
    end
    assert(table.concat(result, ",") == "10,30,50", "ipairs 结果不正确")
end)

-- Test 6: 错误检测 - 循环外使用
quick_test("错误检测 (循环外)", function()
    local code = [[continue]]
    local func, err = loadstring(code)
    assert(not func, "应该产生编译错误")
    assert(err:find("no loop to continue"), "错误消息不正确")
end)

-- Test 7: Continue 前后代码执行
quick_test("Continue 前后代码执行", function()
    local before = 0
    local after = 0
    for i = 1, 5 do
        before = before + 1
        if i % 2 == 0 then
            continue
        end
        after = after + 1
    end
    assert(before == 5, "Continue 前代码应执行 5 次")
    assert(after == 3, "Continue 后代码应执行 3 次")
end)

-- Test 8: 多条件 Continue
quick_test("多条件 Continue", function()
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
    assert(table.concat(result, ",") == "1,3,5,7", "多条件结果不正确")
end)

-- Test 9: Continue 与函数
quick_test("Continue 与函数", function()
    local function process(items)
        local result = {}
        for _, v in ipairs(items) do
            if v < 0 then
                continue
            end
            table.insert(result, v)
        end
        return result
    end
    local output = process({1, -2, 3, -4, 5})
    assert(table.concat(output, ",") == "1,3,5", "函数内 continue 结果不正确")
end)

-- Test 10: Continue 与局部变量
quick_test("Continue 与局部变量", function()
    local sum = 0
    for i = 1, 5 do
        local x = i * 10
        if i == 3 then
            continue
        end
        sum = sum + x
    end
    assert(sum == 120, "局部变量处理不正确")  -- 10+20+40+50
end)

print()
print("=" .. string.rep("=", 70))

if all_passed then
    print("✓✓✓ 所有快速测试通过！Continue 关键字工作正常！")
    print("=" .. string.rep("=", 70))
    print()
    print("建议运行完整测试套件以进行全面验证：")
    print("  lua run_all_tests.lua")
    print()
    os.exit(0)
else
    print("✗✗✗ 有测试失败！请检查 Continue 关键字实现！")
    print("=" .. string.rep("=", 70))
    os.exit(1)
end