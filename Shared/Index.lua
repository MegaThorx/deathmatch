local files = {
    "Utils.lua",
    "Inspect.lua",
    "Classlib.lua",
    "Classes/Object.lua",
    "Classes/Singleton.lua",
    "Classes/Hook.lua"
}

DEBUG = true

for _, file in ipairs(files) do
    Package:Require(file)
end
