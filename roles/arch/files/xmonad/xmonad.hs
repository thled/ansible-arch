import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ docks def
        { modMask = mod4Mask
        , terminal = "alacritty"
        , focusedBorderColor = "#0066FF"
        , layoutHook=avoidStruts $ layoutHook def
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppCurrent = xmobarColor "black" "grey" . wrap "[" "]"
            , ppHidden = xmobarColor "grey" "black" . wrap "(" ")"
            , ppHiddenNoWindows = xmobarColor "grey" "black"
            , ppSep = " | "
            , ppTitle = xmobarColor "#00AAFF" "" . shorten 100
            }
        }
        `additionalKeysP`
        [ ("M-x", spawn "slock")
        , ("M-n", spawn "touch ~/.cache/pomodoro_session")
        ]
