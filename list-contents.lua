local f = io.popen("dir .")
if f then
    print(f:read("*a"))
else
    print("failed to read")
end