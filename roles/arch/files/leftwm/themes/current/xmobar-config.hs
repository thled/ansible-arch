

Config { font = "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*"
    , bgColor = "black"
    , fgColor = "grey"
    , position = Top
    , lowerOnStart = True
    , allDesktops = True
    , pickBroadest = False
    , overrideRedirect = False
    , commands = [    Run Weather "EDDL" ["-t"," <tempC>C","-L","15","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                    , Run Network "eno1" ["-L","0","-H","32","--normal","green","--high","red"] 100
                    , Run Wireless "" [ "-t", "<quality>" ] 100
                    , Run MultiCpu ["-L","15","-H","50","--normal","green","--high","red"] 50
                    , Run Memory [] 50
                    , Run Swap [] 50
                    , Run TopProc [] 50
                    , Run Date "%a %b %_d %Y %H:%M" "date" 50
                    , Run UnsafeStdinReader
                    , Run Battery [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "20"
                             , "--High"     , "80"
                             , "--low"      , "darkred"
                             , "--normal"   , "darkorange"
                             , "--"
                                       , "-o"	, "<left>% (<timeleft>)"
                                       , "-O"	, "Charging"
                                       , "-i"	, "Charged"
                             ] 50
    ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = "%UnsafeStdinReader% }{ %multicpu% | %memory% * %swap% | %eno1% * %wi% | %battery% | %date% | %EDDL%"
}
