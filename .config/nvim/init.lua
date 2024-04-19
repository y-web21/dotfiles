local function file_exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    else
        return false
    end
end

local function is_wsl() return os.getenv("WSLENV") ~= nil end

local function is_win_native()
    if (vim.fn.has("win32") or vim.fn.has("win64")) and not is_wsl() then
        return true
    end
    return false
end

local function source_vim_file(path)
    if is_win_native() then path = path:gsub('/', '\\') end

    -- file exists
    local file = io.open(path, 'r')

    -- ファイルが存在する場合にスクリプトを実行
    if file ~= nil then
        file:close()
        print('source ' .. path)
        vim.cmd('source ' .. path)
    else
        print('File does not exist: ' .. path)
    end
end

function set_bash(opt)
    opt = opt or ""
    -- os.getenv('SHELL')
    if is_win_native() then
        -- https://github.com/vim/vim/issues/5136#issuecomment-547422388
        -- vim.o.shell = 'bash'
        vim.o.shell = os.getenv('USERPROFILE') .. '\\scoop\\shims\\bash.exe'
        vim.o.shellcmdflag = '-c'
        vim.o.shellquote = '"'
    else
        vim.o.shell = 'bash'
    end
end

if vim.fn.has('gui_running') == 1 or vim.env.DISPLAY then
    print('GUI')
else
    print('CUI')
end

local config_path

-- Windows specific configuration
if is_win_native() then
    -- localappdata_path = vim.fn.fnamemodify('$LOCALAPPDATA', ':p:h')
    -- config_path = vim.fn.expand('~') .. '/AppData/Local'
    config_path = os.getenv('LOCALAPPDATA')
    if os.getenv('XDG_CONFIG_HOME') then
        config_path = os.getenv('XDG_CONFIG_HOME')
    end
    config_path = config_path .. '\\nvim'
else
    -- Non-Windows configuration
    -- home_path = vim.fn.expand('$HOME')
    config_path = vim.fn.expand('~/.config/nvim')

    if os.getenv('XDG_CONFIG_HOME') then
        config_path = vim.fn.expand('$XDG_CONFIG_HOME/nvim')
    elseif os.getenv('HOME') then
        config_path = vim.fn.expand('$HOME' .. '/.config/nvim')
    end

    source_vim_file(config_path .. '/xlike.vim')
end

-- Check if global variable g.vscode exists
if vim.g.vscode then
    source_vim_file(config_path .. '/vscode.vim')
else
    source_vim_file(config_path .. '/mappings.vim')
    if vim.fn.exists(':fugitive') ~= 0 then
        vim.o.statusline =
            '%F%m%r%h%w%= %{fugitive#statusline()} [%{&ff}:%{&fileencoding}] [%Y] [%04l,%04v] [%l/%L] %{strftime("%Y/%m/%d %H:%M:%S")}'
    else
        vim.o.statusline =
            '%F%m%r%h%w%= [%{&ff}:%{&fileencoding}] [%Y] [%04l,%04v] [%l/%L] %{strftime("%Y/%m/%d %H:%M:%S")}'
    end
end

source_vim_file(config_path .. '/init_.vim')
