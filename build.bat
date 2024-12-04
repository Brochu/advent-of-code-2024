@echo off
SET debug=""
SET example=""

:: Loop through all arguments
for %%A in (%*) do (
    if "%%A"=="-d" (
        set debug="-debug"
    )
    if "%%A"=="-ex" (
        set example="-define:EXAMPLE=true"
    )
)

odin build .\src\ %debug% %example% -out:AoC2024.exe
