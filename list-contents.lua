sourceDir = 'E:\\Games' --copy source path in between quotes
targetDir = 'E:\\Downloads' --copy target path in between quotes

verbose = true --show verbose output
listMissing = true --show files in source directory that are missing from target directory
listAdditional = true --show files in target directory that are missing from source directory

local log = io.open("log.txt", "w")

function cprint(string)
    if verbose == true then
       print(string) 
    end
    if string ~= nil then
        log:write(string.."\n")
    else
        log:write("\n")
    end
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%n"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

local ls = io.popen("dir \""..sourceDir.."\" /b /s")

rawContentsSource = {}
fileContentsSource = {}

if ls then
    rawContentsSource = mysplit(ls:read("*a"), "\n")
else
    cprint("failed to read")
end

cprint("Checking source directory: ("..sourceDir..")")
cprint("Analysing raw contents:")
for _,value in pairs(rawContentsSource) do
    subpath,_ = value:gsub(sourceDir:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0"), "", 1)--:gsub("\\", "", 1)
    filename,_ = subpath:gsub(".*\\", "", 1)
    cprint(subpath)
    table.insert(fileContentsSource, filename)
end
cprint("Done")
cprint()
if verbose == true then
    cprint("Listing files:")
    for _,value in pairs(fileContentsSource) do
        cprint(value)
    end
    cprint()
end

cprint("Files found in source directory: "..#rawContentsSource)

cprint()
cprint("Checking against target directory: ("..targetDir..")")
local ls = io.popen("dir \""..targetDir.."\" /b /s")

rawContentsTarget = {}
fileContentsTarget = {}
missingContentTarget = {}
additionalContentTarget = {}

if ls then
    rawContentsTarget = mysplit(ls:read("*a"), "\n")
else
    cprint("failed to read")
end

cprint("Analysing raw contents:")
for _,value in pairs(rawContentsTarget) do
    subpath,_ = value:gsub(targetDir:gsub("[%(%)%%%+%-%*%?%[%]%^%$]", "%%%0"), "", 1)--:gsub("\\", "", 1)
    filename,_ = subpath:gsub(".*\\", "", 1)
    cprint(subpath)
    table.insert(fileContentsTarget, filename)
end
cprint("Done")
cprint()
if verbose == true then
    cprint("Listing files:")

    for _,value in pairs(fileContentsSource) do
        cprint(value)
    end
    cprint()
end 

cprint("Files found in target directory: "..#rawContentsTarget)
cprint()

cprint("Files missing in target directory:")
for _,sourceValue in pairs(fileContentsSource) do
    found = false
    for _,targetValue in pairs(fileContentsTarget) do
        if (sourceValue == targetValue) then
            found = true
            break
        end
    end
    if (found == false) then
        table.insert(missingContentTarget, sourceValue)
        cprint(sourceValue.."\t\t\t("..rawContentsSource[_]..")")
    end
end
cprint()

cprint("Files missing in source directory:")
for _,targetValue in pairs(fileContentsTarget) do
    found = false
    for _,sourceValue in pairs(fileContentsSource) do
        if (sourceValue == targetValue) then
            found = true
            break
        end
    end
    if (found == false) then
        table.insert(additionalContentTarget, targetValue)
        cprint(targetValue.."\t\t\t("..rawContentsTarget[_]..")")
    end
end
cprint()

log:close()
