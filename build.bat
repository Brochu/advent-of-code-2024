@echo off
SET debug=""
SET example=""

:: Loop through all arguments
for %%A in (%*) do (
    if "%%A"=="-debug" (
        set debug="-debug"
    )
    if "%%A"=="-example" (
        set example="-define:EXAMPLE=true"
    )
)

odin build .\src\ %debug% %example% -out:AoC2024.exe
