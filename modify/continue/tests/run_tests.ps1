# ============================================================================
# Continue 关键字测试套件 - PowerShell 脚本
# ============================================================================

Write-Host "======================================================================"
Write-Host "Continue 关键字测试套件 - 自动运行"
Write-Host "======================================================================"
Write-Host ""

# 查找 lua.exe
$luaExe = $null
if (Test-Path "..\bin\lua.exe") {
    $luaExe = "..\bin\lua.exe"
    Write-Host "使用编译的 Lua: $luaExe"
} elseif (Test-Path "..\lua\x64\Debug\lua.exe") {
    $luaExe = "..\lua\x64\Debug\lua.exe"
    Write-Host "使用调试版 Lua: $luaExe"
} elseif (Test-Path "..\lua\x64\Release\lua.exe") {
    $luaExe = "..\lua\x64\Release\lua.exe"
    Write-Host "使用发布版 Lua: $luaExe"
} else {
    $luaExe = "lua"
    Write-Host "使用系统 Lua"
}

Write-Host ""
Write-Host "选择测试模式："
Write-Host "  1. 快速验证测试 (10个测试, ~5秒)"
Write-Host "  2. 基础功能测试 (22个测试, ~1秒)"
Write-Host "  3. 高级功能测试 (22个测试, ~2秒)"
Write-Host "  4. 错误处理测试 (22个测试, ~1秒)"
Write-Host "  5. 性能测试 (16个测试, ~30-60秒)"
Write-Host "  6. 完整测试套件 (所有测试)"
Write-Host ""

$choice = Read-Host "请选择 (1-6)"

Write-Host ""

switch ($choice) {
    "1" {
        Write-Host "运行快速验证测试..."
        Write-Host "======================================================================"
        & $luaExe quick_test.lua
    }
    "2" {
        Write-Host "运行基础功能测试..."
        Write-Host "======================================================================"
        & $luaExe test_continue_basic.lua
    }
    "3" {
        Write-Host "运行高级功能测试..."
        Write-Host "======================================================================"
        & $luaExe test_continue_advanced.lua
    }
    "4" {
        Write-Host "运行错误处理测试..."
        Write-Host "======================================================================"
        & $luaExe test_continue_errors.lua
    }
    "5" {
        Write-Host "运行性能测试..."
        Write-Host "======================================================================"
        & $luaExe test_continue_performance.lua
    }
    "6" {
        Write-Host "运行完整测试套件..."
        Write-Host "======================================================================"
        & $luaExe run_all_tests.lua
    }
    default {
        Write-Host "无效选择，运行快速验证测试..."
        Write-Host "======================================================================"
        & $luaExe quick_test.lua
    }
}

Write-Host ""
Write-Host "======================================================================"
Write-Host "测试完成！"
Write-Host "======================================================================"
Write-Host ""
Read-Host "按回车键退出"