#!/usr/bin/env lua
-- ============================================================================
-- Continue 关键字错误处理测试
-- 测试错误情况和边界条件的处理
-- ============================================================================

print("=" .. string.rep("=", 70))
print("Continue 关键字 - 错误处理测试")
print("=" .. string.rep("=", 70))

local test_count = 0
local pass_count = 0
local fail_count = 0

-- 辅助函数：测试是否产生预期错误
local function test_error(name, code, expected_error_pattern)
    test_count = test_count + 1
    local func, err = loadstring(code)
    
    if not func then
        -- 编译时错误
        if expected_error_pattern and string.find(err, expected_error_pattern) then
            pass_count = pass_count + 1
            print(string.format("✓ TEST %d PASSED: %s", test_count, name))
            print(string.format("  Got expected error: %s", err:match(":%d+: (.+)")))
            return true
        else
            fail_count = fail_count + 1
            print(string.format("✗ TEST %d FAILED: %s", test_count, name))
            print(string.format("  Expected error pattern: %s", expected_error_pattern or "any error"))
            print(string.format("  Got error: %s", err))
            return false
        end
    else
        -- 运行时错误
        local success, run_err = pcall(func)
        if not success then
            if expected_error_pattern and string.find(run_err, expected_error_pattern) then
                pass_count = pass_count + 1
                print(string.format("✓ TEST %d PASSED: %s", test_count, name))
                print(string.format("  Got expected runtime error: %s", run_err:match(":%d+: (.+)") or run_err))
                return true
            else
                fail_count = fail_count + 1
                print(string.format("✗ TEST %d FAILED: %s", test_count, name))
                print(string.format("  Expected error pattern: %s", expected_error_pattern or "any error"))
                print(string.format("  Got runtime error: %s", run_err))
                return false
            end
        else
            fail_count = fail_count + 1
            print(string.format("✗ TEST %d FAILED: %s", test_count, name))
            print(string.format("  Expected error but code executed successfully"))
            return false
        end
    end
end

-- 辅助函数：测试代码是否正确执行（不应报错）
local function test_no_error(name, code)
    test_count = test_count + 1
    local func, err = loadstring(code)
    
    if not func then
        fail_count = fail_count + 1
        print(string.format("✗ TEST %d FAILED: %s", test_count, name))
        print(string.format("  Compilation failed: %s", err))
        return false
    end
    
    local success, run_err = pcall(func)
    if success then
        pass_count = pass_count + 1
        print(string.format("✓ TEST %d PASSED: %s", test_count, name))
        return true
    else
        fail_count = fail_count + 1
        print(string.format("✗ TEST %d FAILED: %s", test_count, name))
        print(string.format("  Runtime error: %s", run_err))
        return false
    end
end

print("\n" .. string.rep("-", 70))
print("测试组 1: Continue 在非法位置")
print(string.rep("-", 70))

-- Test 1: Continue 在循环外
test_error(
    "循环外使用continue",
    [[
        local x = 1
        continue
    ]],
    "no loop to continue"
)

-- Test 2: Continue 在函数顶层（无循环）
test_error(
    "函数顶层使用continue(无循环)",
    [[
        function test()
            continue
        end
        test()
    ]],
    "no loop to continue"
)

-- Test 3: Continue 在 if 块中（无循环）
test_error(
    "if块中使用continue(无循环)",
    [[
        local x = 5
        if x > 0 then
            continue
        end
    ]],
    "no loop to continue"
)

-- Test 4: Continue 在 do-end 块中（无循环）
test_error(
    "do-end块中使用continue(无循环)",
    [[
        do
            continue
        end
    ]],
    "no loop to continue"
)

print("\n" .. string.rep("-", 70))
print("测试组 2: Continue 的作用域测试")
print(string.rep("-", 70))

-- Test 5: Continue 在函数内部的循环（应该正常）
test_no_error(
    "函数内循环中的continue",
    [[
        function process()
            for i = 1, 5 do
                if i == 3 then
                    continue
                end
            end
        end
        process()
    ]]
)

-- Test 6: Continue 在嵌套函数的循环中（应该正常）
test_no_error(
    "嵌套函数中循环的continue",
    [[
        function outer()
            return function()
                for i = 1, 3 do
                    if i == 2 then
                        continue
                    end
                end
            end
        end
        local inner = outer()
        inner()
    ]]
)

-- Test 7: Continue 不能跨函数边界
test_no_error(
    "Continue不跨函数边界",
    [[
        for i = 1, 3 do
            local function inner()
                -- Continue 不能影响外层循环
                return i
            end
            if inner() == 2 then
                continue
            end
        end
    ]]
)

print("\n" .. string.rep("-", 70))
print("测试组 3: Continue 与 Break 对比")
print(string.rep("-", 70))

-- Test 8: Continue 与 break 在同一循环
test_no_error(
    "Continue与break在同一循环",
    [[
        for i = 1, 10 do
            if i == 3 then
                continue
            end
            if i == 7 then
                break
            end
        end
    ]]
)

-- Test 9: Break 和 Continue 在不同分支（都合法）
test_no_error(
    "Continue和break在不同分支",
    [[
        for i = 1, 10 do
            if i == 3 then
                continue
            end
            if i == 7 then
                break
            end
        end
    ]]
)

print("\n" .. string.rep("-", 70))
print("测试组 4: Continue 语法边界")
print(string.rep("-", 70))

-- Test 10: Continue 作为单独语句
test_no_error(
    "Continue作为单独语句",
    [[
        for i = 1, 3 do
            continue
        end
    ]]
)

-- Test 11: Continue 在复杂表达式后
test_no_error(
    "Continue在表达式后",
    [[
        for i = 1, 5 do
            local x = i * 2 + 3
            if x > 8 then
                continue
            end
            local y = x + 1
        end
    ]]
)

-- Test 12: 多个 continue 在不同分支
test_no_error(
    "多个continue在不同分支",
    [[
        for i = 1, 10 do
            if i < 3 then
                continue
            elseif i > 7 then
                continue
            end
        end
    ]]
)

print("\n" .. string.rep("-", 70))
print("测试组 5: Continue 与局部变量")
print(string.rep("-", 70))

-- Test 13: Continue 跳过局部变量定义
test_no_error(
    "Continue跳过局部变量定义",
    [[
        for i = 1, 5 do
            if i % 2 == 0 then
                continue
            end
            local x = i * 10  -- 偶数时不执行
        end
    ]]
)

-- Test 14: Continue 与 upvalue
test_no_error(
    "Continue与upvalue",
    [[
        local sum = 0
        for i = 1, 5 do
            if i == 3 then
                continue
            end
            sum = sum + i
        end
        assert(sum == 12)  -- 1+2+4+5
    ]]
)

print("\n" .. string.rep("-", 70))
print("测试组 6: Continue 的语义正确性")
print(string.rep("-", 70))

-- Test 15: Continue 后的代码不执行
test_no_error(
    "验证continue后代码不执行",
    [[
        local executed = false
        for i = 1, 1 do
            continue
            executed = true
        end
        assert(not executed)
    ]]
)

-- Test 16: Continue 使循环继续
test_no_error(
    "验证continue使循环继续",
    [[
        local count = 0
        for i = 1, 5 do
            count = count + 1
            if i < 5 then
                continue
            end
        end
        assert(count == 5)
    ]]
)

-- Test 17: While 循环中 continue 跳转到条件检查
test_no_error(
    "While循环continue跳转正确",
    [[
        local i = 0
        local count = 0
        while i < 5 do
            i = i + 1
            if i == 3 then
                continue
            end
            count = count + 1
        end
        assert(count == 4)  -- 跳过了i=3
    ]]
)

-- Test 18: Repeat 循环中 continue 跳转到条件检查
test_no_error(
    "Repeat循环continue跳转正确",
    [[
        local i = 0
        local count = 0
        repeat
            i = i + 1
            if i == 3 then
                continue
            end
            count = count + 1
        until i >= 5
        assert(count == 4)
    ]]
)

print("\n" .. string.rep("-", 70))
print("测试组 7: 嵌套循环中的 Continue")
print(string.rep("-", 70))

-- Test 19: 内层循环的 continue 不影响外层
test_no_error(
    "内层continue不影响外层循环",
    [[
        local outer_count = 0
        local inner_count = 0
        for i = 1, 3 do
            outer_count = outer_count + 1
            for j = 1, 3 do
                inner_count = inner_count + 1
                if j == 2 then
                    continue  -- 只影响内层
                end
            end
        end
        assert(outer_count == 3)
        assert(inner_count == 9)
    ]]
)

-- Test 20: 外层循环的 continue 跳过内层循环
test_no_error(
    "外层continue跳过内层循环",
    [[
        local outer_count = 0
        local inner_count = 0
        for i = 1, 3 do
            outer_count = outer_count + 1
            if i == 2 then
                continue
            end
            for j = 1, 2 do
                inner_count = inner_count + 1
            end
        end
        assert(outer_count == 3)
        assert(inner_count == 4)  -- i=1: 2次, i=2: 0次(continue), i=3: 2次
    ]]
)

print("\n" .. string.rep("-", 70))
print("测试组 8: Continue 与其他语句组合")
print(string.rep("-", 70))

-- Test 21: Continue 与 return（在函数中）
test_no_error(
    "Continue与return组合",
    [[
        function process()
            for i = 1, 5 do
                if i == 2 then
                    continue
                end
                if i == 4 then
                    return i
                end
            end
            return 0
        end
        assert(process() == 4)
    ]]
)

-- Test 22: Continue 与 goto（如果支持）
test_no_error(
    "Continue基本功能不受goto影响",
    [[
        local result = 0
        for i = 1, 5 do
            if i % 2 == 0 then
                continue
            end
            result = result + i
        end
        assert(result == 9)  -- 1+3+5
    ]]
)

print("\n" .. string.rep("=", 70))
print("测试统计")
print(string.rep("=", 70))
print(string.format("总测试数:   %d", test_count))
print(string.format("通过数:     %d", pass_count))
print(string.format("失败数:     %d", fail_count))
print(string.format("通过率:     %.1f%%", (pass_count / test_count) * 100))

if fail_count == 0 then
    print("\n✓ 所有错误处理测试通过！")
    os.exit(0)
else
    print("\n✗ 有测试失败，请检查实现！")
    os.exit(1)
end