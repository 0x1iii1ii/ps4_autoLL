
FORCE_LAPSE_EXPLOIT = false

WRITABLE_PATH = "/av_contents/content_tmp/"
LOG_FILE = WRITABLE_PATH .. "loader_log.txt"
log_fd = io.open(LOG_FILE, "w")

game_name = nil
eboot_base = nil
libc_base = nil
libkernel_base = nil

gadgets = nil
eboot_addrofs = nil
libc_addrofs = nil

native_cmd_handler = nil
native_invoke = nil

kernel_offset = nil

old_print = print
function print(...)

    local out = prepare_arguments(...) .. "\n"

    old_print(out) -- print to stdout

    if client_fd and native_invoke then
        syscall.write(client_fd, out, #out) -- print to socket
    end

    log_fd:write(out) -- print to file
    log_fd:flush()
end

package.path = package.path .. ";/savedata0/?.lua"

require "globals"
require "offsets"
require "misc"
require "bit32"
require "hash"
require "uint64"
require "struct"
require "lua"
require "memory"
require "ropchain"
require "syscall"
require "signal"
require "native"
require "thread"
require "kernel_offset"
require "kernel"
require "gpu"

function run_lua_code(lua_code)
    local script, err = loadstring(lua_code)
    if err then
        local err_msg = "error loading script: " .. err
        print(err_msg)
        return
    end

    local env = {
        print = function(...)
            local out = prepare_arguments(...) .. "\n"
            print(out)
        end,
        printf = function(fmt, ...)
            local out = string.format(fmt, ...) .. "\n"
            print(out)
        end
    }

    setmetatable(env, { __index = _G })
    setfenv(script, env)

    err = run_with_coroutine(script)

    if err then
        print("Error: " .. err)
    end
end

function get_savedata_path()
    local path = "/savedata0/"
    if is_jailbroken() then
        path = "/mnt/sandbox/" .. get_title_id() .. "_000/savedata0/"
    end
    return path
end

function load_and_run_lua(path)
    local lua_code = file_read(path, "r")
    run_lua_code(lua_code)
end

elf_loader_active = false
function start_elf_loader()
    if elf_loader_active then
        print("elf_loader already loaded")
        return
    end

    load_and_run_lua(get_savedata_path() .. "elf_loader.lua")
    sleep(4000, "ms")
    elf_loader_active = true
end

old_error = error
function error(msg)
    if type(msg) == "table" then
        msg = table.concat(msg, "\n")
    end

    if not msg or msg == "" then
        msg = "Unknown error"
    end

    send_ps_notification("Error:\n" .. msg)

    old_error(msg)
end


function main()

    -- setup limited read & write primitives
    lua.setup_primitives()
    print("[+] lua r/w primitives achieved")

    syscall.init()
    print("[+] syscall initialized")

    native.register()
    print("[+] native handler registered")

    print("[+] arbitrary r/w primitives achieved")

    syscall.resolve({
        read = 0x3,
        write = 0x4,
        open = 0x5,
        close = 0x6,
        getuid = 0x18,
        kill = 0x25,
        accept = 0x1e,
        pipe = 0x2a,
        mprotect = 0x4a,
        socket = 0x61,
        connect = 0x62,
        bind = 0x68,
        setsockopt = 0x69,
        listen = 0x6a,
        getsockopt = 0x76,
        netgetiflist = 0x7d,
        sysctl = 0xca,
        nanosleep = 0xf0,
        sigaction = 0x1a0,
        thr_self = 0x1b0,
        dlsym = 0x24f,
        dynlib_load_prx = 0x252,
        dynlib_unload_prx = 0x253,
        is_in_sandbox = 0x249,
    })

    FW_VERSION = get_version()

    AUTOLL_VERSION = "0.3"

    thread.init()

    kernel_offset = get_kernel_offset()

    send_ps_notification(string.format("PS4 AutoLuaLoader HEN v%s\nFirmware: %s", AUTOLL_VERSION, FW_VERSION))

    if tonumber(FW_VERSION) <= 12.02 then
        kernel_exploit_lua = "lapse.lua"
    else
        notify(string.format("Unsupported firmware version (%s %s)", PLATFORM, FW_VERSION))
        return
    end

    sleep(1000, "ms") -- wait a little before starting the kernel exploit

    load_and_run_lua(get_savedata_path() .. kernel_exploit_lua)

    if not is_jailbroken() then
        send_ps_notification("Jailbreak failed\nRestart the console and try again...")
        syscall.kill(syscall.getpid(), 15)
        return
    end

    sleep(2000, "ms") -- wait for the jailbreak to settle

    load_and_run_lua(get_savedata_path() .. "autoload.lua")

    load_and_run_lua(get_savedata_path() .. "bin_loader.lua")

    syscall.kill(syscall.getpid(), 15)
end

function entry()
    local err = run_with_coroutine(main)
    if err then
        notify(err)
        print(err)
    end
end

entry()
