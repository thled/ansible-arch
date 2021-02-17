

Config { font = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"
    , bgColor = "black"
    , fgColor = "grey"
    , position = Top
    , lowerOnStart = True
    , allDesktops = True
    , pickBroadest = False
    , overrideRedirect = False
    , commands = [    Run Weather "EDDL" ["-t"," <tempC>C","-L","64","-H","77","--normal","green","--high","red","--low","lightblue"] 36000
                    , Run Network "eno1" ["-L","0","-H","32","--normal","green","--high","red"] 100
                    , Run Wireless "" [ "-t", "<quality>" ] 100
                    , Run MultiCpu ["-L","15","-H","50","--normal","green","--high","red"] 50
                    , Run Memory [] 50
                    , Run Swap [] 50
                    , Run TopProc [] 50
                    , Run Date "%a %b %_d %Y %H:%M" "date" 50
                    , Run UnsafeStdinReader
    ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "%UnsafeStdinReader% }{ %multicpu% | %memory% * %swap% | %eno1% * %wi% | %date% | %EDDL%"
}
