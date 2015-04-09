sourceDir = 'C:\\Users\\manu\\Downloads' --copy source path in between quotes
targetDir = 'C:\\Users\\manu\\Downloads' --copy target path in between quotes

verbose = true --show full subpaths instead of only filenames
listMissing = true --show files in source directory that are missing from target directory
listAdditional = true --show files in target directory that are missing from source directory

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
--[[
local sourceDir = io.popen("echo %cd%")
if sourceDir then
    sourceDir = sourceDir:read("*a")
    sourceDir = sourceDir:gsub("\n", "")
    print("Source directory:")
    print(sourceDir)
    print()
else
    print("Could not determine source directory, exiting now.")
    return
end
]]--

local ls = io.popen("dir "..sourceDir.." /b /s")

rawContentsSource = {}
fileContentsSource = {}

if ls then
    rawContentsSource = mysplit(ls:read("*a"), "\n")
else
    print("failed to read")
end

print("Checking source directory:")
print("Analysing raw contents:")
for _,value in pairs(rawContentsSource) do
    subpath,_ = value:gsub(sourceDir:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0"), "", 1)--:gsub("\\", "", 1)
    filename,_ = subpath:gsub(".*\\", "", 1)
    if (verbose == true) then
        print(subpath)
    end
    table.insert(fileContentsSource, filename)
end
print("Done")
print()
if (verbose == true) then
print("Listing files:")

for _,value in pairs(fileContentsSource) do
    print(value)
end
print()
end
print("Files found in source directory: "..#rawContentsSource)

print()
print("Checking against target directory:")
local ls = io.popen("dir "..targetDir.." /b /s")

rawContentsTarget = {}
fileContentsTarget = {}
missingContentTarget = {}
additionalContentTarget = {}

if ls then
    rawContentsTarget = mysplit(ls:read("*a"), "\n")
else
    print("failed to read")
end

print("Analysing raw contents:")
for _,value in pairs(rawContentsTarget) do
    subpath,_ = value:gsub(targetDir:gsub("[%(%)%%%+%-%*%?%[%]%^%$]", "%%%0"), "", 1)--:gsub("\\", "", 1)
    filename,_ = subpath:gsub(".*\\", "", 1)
    if (verbose == true) then
        print(subpath)
    end
    table.insert(fileContentsTarget, filename)
end
print("Done")
print()
if (verbose == true) then
print("Listing files:")

for _,value in pairs(fileContentsSource) do
    print(value)
end
print()
end
print("Files found in target directory: "..#rawContentsTarget)
print()

print("Files missing in target directory:")
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
        print(sourceValue.."\t\t\t("..rawContentsSource[_]..")")
    end
end
print()

print("Files missing in source directory:")
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
        print(targetValue.."\t\t\t("..rawContentsTarget[_]..")")
    end
end
print()
