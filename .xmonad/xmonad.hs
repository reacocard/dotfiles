import XMonad
import Data.Monoid
import System.Exit

import Graphics.X11.Xlib
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutHints
import XMonad.Actions.PhysicalScreens
import XMonad.Util.Run(spawnPipe)
import System.IO

-- define keysyms not supplied by xmonad
xK_XF86VolumeUp = 0x1008ff13
xK_XF86VolumeDown = 0x1008ff11
xK_XF86VolumeMute = 0x1008ff12
xK_XF86ScreenSaver = 0x1008ff2d
xK_XF86Sleep = 0x1008ff2f
xK_XF86TouchpadToggle = 0x1008ffa9

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ withUrgencyHook NoUrgencyHook
        $ defaultConfig
        { terminal      = "urxvt"
        -- Mod3 was unused, so i remapped capslock to it for my modkey
        , modMask       = mod3Mask
        , borderWidth   = 1
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "gray" ""
                        , ppUrgent = xmobarColor "white" ""
                        }
        , layoutHook = avoidStruts $ smartBorders (myLayoutHook)
        , manageHook = manageDocks <+> myManageHooks
        , keys = myKeys
        , mouseBindings = myMouseBindings
        , workspaces = myWorkspaces
        , focusFollowsMouse = False
        , handleEventHook = fullscreenEventHook
        }

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]

volupCmd = "~/bin/pulsevolume up"
voldownCmd = "~/bin/pulsevolume down"
volmuteCmd = "~/bin/pulsevolume mute"
lockCmd = "xautolock -locknow"
sleepCmd = "~/bin/lockandsleep.sh"
touchpadCmd = "~/bin/toggle_touchpad.sh"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((0, xK_XF86VolumeUp),    spawn volupCmd) 
    , ((0, xK_XF86VolumeDown),  spawn voldownCmd) 
    , ((0, xK_XF86VolumeMute),  spawn volmuteCmd)
    , ((0, xK_XF86Sleep),       spawn sleepCmd)
    , ((0, xK_XF86TouchpadToggle), spawn touchpadCmd)
    , ((0, xK_XF86ScreenSaver), spawn lockCmd)
    , ((modm, xK_x),            spawn lockCmd)
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9]++[xK_0]++[xK_F1 .. xK_F12])
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,               xK_p     ), spawn "dmenu_run")
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster  )
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm .|. shiftMask, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]


-- set layouts. currently same as the default
myLayoutHook = tiled ||| Mirror tiled ||| Full
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1 -- number of windows in master pane
        ratio = 1/2 -- ratio of space allocated to to master/slave panes
        delta = 3/100 -- increment for resizing panes


myManageHooks = composeAll
    [ className =? "MPlayer"    --> doFullFloat -- mplayer is always floated, fullscreen
    --, resource =? "file_properties" --> doFloat
    , resource =? "Wine" --> doFloat
    , className =? "Wine" --> doFloat
    , title =? "Pandora" --> doFloat -- Pandora desktop app - doesn't deal with resizing right
    , title =? "Chromium Preferences" --> doCenterFloat
    , isDialog --> doCenterFloat
    , isFullscreen              --> (doF W.focusDown <+> doFullFloat) -- fix flash fullscreen
    ]
