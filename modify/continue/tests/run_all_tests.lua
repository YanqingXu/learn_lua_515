#!/usr/bin/env lua
-- ============================================================================
-- Continue 关键字 - 测试套件运行器
-- 自动运行所有测试并生成报告
-- ============================================================================

print("=" .. string.rep("=", 70))
print("Continue 关键字 - 完整测试套件")
print("=" .. string.rep("=", 70))
print()

-- 测试文件列表
local test_files = {
    {
        name = "基础功能测试",
        file = "test_continue_basic.lua",
        description = "测试 continue 在各种循环中的基本功能"
    },
    {
        name = "高级功能测试",
        file = "test_continue_advanced.lua",
        description = "测试复杂场景和实际应用"
    },
    {
        name = "错误处理测试",
        file = "test_continue_errors.lua",
        description = "测试错误情况和边界条件"
    },
    {
        name = "性能测试",
        file = "test_continue_performance.lua",
        description = "测试性能和大规模场景",
        optional = true  -- 性能测试可选
    }
}

local total_passed = 0
local total_failed = 0
local test_results = {}

-- 运行单个测试文件
local function run_test(test_info)
    print(string.rep("-", 70))
    print("运行: " .. test_info.name)
    print("描述: " .. test_info.description)
    print(string.rep("-", 70))
    
    local success, err = pcall(function()
        dofile(test_info.file)
    end)
    
    if success then
        table.insert(test_results, {
            name = test_info.name,
            passed = true
        })
        print()
        return true
    else
        table.insert(test_results, {
            name = test_info.name,
            passed = false,
            error = err
        })
        print("\n错误: " .. tostring(err))
        print()
        return false
    end
end

-- 主测试循环
local start_time = os.clock()

for i, test_info in ipairs(test_files) do
    if test_info.optional then
        io.write("是否运行 " .. test_info.name .. "? (可能需要较长时间) [y/N]: ")
        local response = io.read()
        if not response or (response:lower() ~= "y" and response:lower() ~= "yes") then
            print("跳过 " .. test_info.name)
            print()
            continue
        end
    end
    
    local success = run_test(test_info)
    if success then
        total_passed = total_passed + 1
    else
        total_failed = total_failed + 1
    end
end

local elapsed_time = os.clock() - start_time

-- 生成测试报告
print("=" .. string.rep("=", 70))
print("测试报告")
print("=" .. string.rep("=", 70))
print()

for i, result in ipairs(test_results) do
    local status = result.passed and "✓ 通过" or "✗ 失败"
    print(string.format("%d. %s: %s", i, result.name, status))
    if not result.passed and result.error then
        print("   错误: " .. result.error)
    end
end

print()
print(string.rep("-", 70))
print(string.format("总计:       %d 个测试套件", #test_results))
print(string.format("通过:       %d", total_passed))
print(string.format("失败:       %d", total_failed))
print(string.format("耗时:       %.2f 秒", elapsed_time))
print(string.rep("-", 70))

if total_failed == 0 then
    print("\n✓ 所有测试套件通过！Continue 关键字实现正确！")
    os.exit(0)
else
    print("\n✗ 有测试套件失败，请检查实现！")
    os.exit(1)
end