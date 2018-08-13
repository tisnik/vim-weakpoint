#!/usr/bin/lua

local OUTPUT_SWITCH = "-output"
local CLEAN_SWITCH = "-clean"
local DEDUCT_SWITCH = "-deduct"
local HEIGHT_SWITCH = "-height"
local BREAK_SWITCH = "-break"
local VIM = "-vim"

local OUT_DIR_DEFAULT="."
local inFile = nil
local outDir = OUT_DIR_DEFAULT
local clean = false
local deduct = false
local height = 0
local page = "--PAGE--"
local vim = false

local function boolToString(b)
    if (b) then
        return "true"
    else
        return "false"
    end
end
local function help(exit)
    print("Splitting utility for github.com/tisnik/vim-weakpoint (ideally with github.com/plasticboy/vim-markdown [which needs .markdown suffix])")
    print("Will split your file to several slides, so you can run them as comfortbale console presentation")
    print("Single input parameter of inut file is necessary eg PtisnovsWeakPointSpliter my/file.markdown")
    print("Optional swithces")
    print(OUTPUT_SWITCH.." dir_to_save_slides_to  set the output directory. Default is `"..outDir.. "`")
    print(CLEAN_SWITCH.."  default "..", will empty the output directory")
    print(DEDUCT_SWITCH.."  default "..boolToString(deduct)..", will create directory input'sDir/file-WeakPoint (wihtut suffix), and treat it as -output. Or in input'sDir/file-WeakPoint if output is specified. If you need cwd, do not use -deduct ")
    print(HEIGHT_SWITCH.." number  defualt "..height..",will fill the slides with empty lines untill a number (so vim do not show the ~)")
    print(BREAK_SWITCH.." string  if line is starting by this string, the line is removed, and next slide started default is "..page)
    print("Warning, some characters, like . have to be escaped by %. (eg %.). This is caused by my stupidity in startsWith implementation by pseudo regex")
    print(VIM.."  default "..boolToString(vim)..", after presentation is lunched, vim is executed in target dirctory, so you can ctrl+c:WeakPoint and check the slides")
    os.exit(exit)
end

function startsWith(str,start)
    return string.sub(str, 1, string.len(start))==start
end

function fileExists(name)
    local f=io.open(name,"r")
    if f~=nil then
    io.close(f)
        return true
    else
        return false
    end
end

function lastIndexOf(haystack, needle)
    local i=string.match(haystack, ".*"..needle.."()")
    if i==nil then
        return nil
    else
        return i-1
    end
end

function deductFileName(name) 
    if (string.match(name, "%.")) then
        name = string.sub(name, 0, lastIndexOf(name, "%.")-1)
    end
    return name.."-WeakPoint"
end

function fileGetName(path)
    if (string.match(path, "/")) then
        name = string.sub(path, lastIndexOf(path, "/")+1)
    else
       name=name
    end
    return name
end

function getParentFile(path)
    if (string.match(path, "/")) then
        parent = string.sub(path, 0, lastIndexOf(path, "/"))
    else
       parent="."
    end
    return parent
end

function createWriter(currentPage, outDir, width, name)
    local f = outDir.."/"..createName(currentPage, width, name)
    fho,err = io.open(f,"w")
    return fho
end

function createName(currentPage, width, name)
    local suffix = ""
    if (string.match(name, "%.")) then
        suffix = string.sub(name, lastIndexOf(name,"%."))
    end
    local r = currentPage..""
    while (#r < width) do
        r="0"..r;
    end
    r=r..suffix;
    io.stderr:write(r.."\n");
    return r;
end

if (#arg == 0) then
    help(1)
end

local shift=0;
for x=1,#arg,1 do 
    i=x+shift
    if (i > #arg) then
      break
    end
    if (arg[i] == "-h" or arg[i] == "--help" or arg[i] == "-help") then
        if (#arg == 1) then
            help(0)
        else
            help(10)
        end
    end
    if (startsWith(arg[i], "-")) then
        if (arg[i]  ==  OUTPUT_SWITCH) then
            shift=shift+1
            outDir = arg[i+1]
        elseif (arg[i]  ==  CLEAN_SWITCH) then
            clean = true
        elseif (arg[i]  ==  DEDUCT_SWITCH) then
            deduct = true
        elseif (arg[i]  ==  HEIGHT_SWITCH) then
            shift=shift+1
            height = tonumber(arg[i+1])
        elseif (arg[i]  ==  BREAK_SWITCH) then
            shift=shift+1
            page = arg[i+1]
        elseif(arg[i]  ==  VIM) then
            vim = true
        else
            io.stderr:write("unknown switch "..arg[i].."\n")
            os.exit(3)
        end
    else
        inFile = arg[i]
    end
end

if (fileExists(inFile)) then
    io.stderr:write(inFile.." exists and is file\n")
else
    io.stderr:write(inFile.." do not exists and is not file\n")
    os.exit(2)
end

io.stderr:write(CLEAN_SWITCH..": "..boolToString(clean).."\n")
io.stderr:write(DEDUCT_SWITCH..": "..boolToString(deduct).."\n")
io.stderr:write(HEIGHT_SWITCH..": "..height.."\n")
io.stderr:write(BREAK_SWITCH..": "..page.."\n")
io.stderr:write(VIM..": "..boolToString(vim).."\n")
local posix = require "posix"
if (deduct) then
    local name = deductFileName(fileGetName(inFile))
    if (outDir == OUT_DIR_DEFAULT) then
        -- not set: cwd or via in?
        -- in cwd is used differently usually
        outDir = getParentFile(inFile)..name
    else
        outDir = outDir.."/"..name
    end
    posix.mkdir(outDir)
end
io.stderr:write(OUTPUT_SWITCH..": "..outDir.."\n")

if (clean) then
    posix.spawn({"rm", "-rfv", outDir..""})
    posix.mkdir(outDir)
end

local totalPages = 1;
fh,err = io.open(inFile)
while true do
    s = fh:read()
    if s == nil then break end
    if startsWith(s,page) then
        totalPages=totalPages+1
    end
end
fh:close()
io.stderr:write("Pages: "..totalPages.."\n");
local width = #(totalPages.."");
local currentPage = 1;
local lines = 0;
fh,err = io.open(inFile)
local bw = createWriter(currentPage, outDir, width, fileGetName(inFile));
while true do
    s = fh:read()
    if s == nil then break end
    lines=lines+1
    if startsWith(s,page) then
        for x=lines,height,1 do
            bw:write("\n")
        end
        bw:flush()
        bw:close()
        currentPage=currentPage+1;
        lines = 0;
        bw = createWriter(currentPage, outDir, width, fileGetName(inFile));
    else 
        bw:write(s)
        bw:write("\n")
    end
end
fh:close()
for x=lines,height-1,1 do
    bw:write("\n")
end
bw:flush()
bw:close()
io.stderr:flush();
print(outDir);
if (vim) then
    cwd=posix.getcwd()
    posix.chdir(outDir)
    posix.execp("vim", {".", "-c", ":WeakPoint"})
    posix.chdir(cwd) --should be not necessary
end
