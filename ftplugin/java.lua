-- java.lua (fixed lombok handling)
local home = os.getenv 'HOME'
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

-- Detect OS
local os_name = vim.loop.os_uname().sysname:lower()
local config_dir = os_name:match("darwin") and "config_mac" or "config_linux"

local status, jdtls = pcall(require, 'jdtls')
if not status then
    vim.notify("jdtls not found!", vim.log.levels.ERROR)
    return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities

-- ✅ Better lombok path detection
local lombok_path = home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar'
local lombok_exists = vim.fn.filereadable(lombok_path) == 1

-- Base JDTLS command
local cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
}

-- ✅ Add lombok nếu có
if lombok_exists then
    table.insert(cmd, '-javaagent:' .. lombok_path)
    vim.notify("Lombok.jar found - JDTLS will support @Data, @Getter, etc.", vim.log.levels.INFO)
else
    vim.notify("Lombok.jar not found - Install with: wget -O ~/.local/share/nvim/mason/packages/jdtls/lombok.jar https://projectlombok.org/downloads/lombok.jar", vim.log.levels.WARN)
end

-- Add JAR và config paths
table.insert(cmd, '-jar')
table.insert(cmd, vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'))
table.insert(cmd, '-configuration')
table.insert(cmd, home .. '/.local/share/nvim/mason/packages/jdtls/' .. config_dir)
table.insert(cmd, '-data')
table.insert(cmd, workspace_dir)

local config = {
    cmd = cmd,
    root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

    settings = {
        java = {
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
            maven = {
                downloadSources = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = 'all',
                },
            },
            format = {
                enabled = false,
            },
            -- Lombok support trong settings
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = "/usr/lib/jvm/java-21-openjdk", -- Adjust theo Java version của mày
                        default = true,
                    },
                },
            },
        },
    },

    init_options = {
        bundles = {},
    },

    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        
        -- JDTLS keymaps
        vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", 
            vim.tbl_extend("force", opts, { desc = 'Organize Imports' }))
        vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", 
            vim.tbl_extend("force", opts, { desc = 'Extract Variable' }))
        vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", 
            vim.tbl_extend("force", opts, { desc = 'Extract Variable' }))
        vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", 
            vim.tbl_extend("force", opts, { desc = 'Extract Constant' }))
        vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", 
            vim.tbl_extend("force", opts, { desc = 'Extract Constant' }))
        vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", 
            vim.tbl_extend("force", opts, { desc = 'Extract Method' }))
        
        -- Test JDTLS connection
        vim.notify("JDTLS attached to buffer " .. bufnr, vim.log.levels.INFO)
    end,
}

-- Start JDTLS
local status_ok, err = pcall(jdtls.start_or_attach, config)
if not status_ok then
    vim.notify("JDTLS failed to start: " .. tostring(err), vim.log.levels.ERROR)
end
