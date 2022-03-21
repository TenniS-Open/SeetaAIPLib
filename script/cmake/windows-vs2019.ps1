# Compile using MSVC

# ARCH: x86 x64
# CUDA: ON OFF

$COMPILER = "vs2019"
$ARCH = "x64"
$CUDA = "OFF"

$FAKE_TENNIS="ON"

$CurrentyDir = Split-Path -Parent $MyInvocation.MyCommand.Definition;

$PROJECT = "$CurrentyDir\..\.."

&"$CurrentyDir\..\pwsh\setup_vcvars.ps1" "$COMPILER" "$ARCH"

cmake "$PROJECT" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DTS_DYNAMIC_INSTRUCTION=ON -DAIP_FAKE_TENNIS="${FAKE_TENNIS}" $args


