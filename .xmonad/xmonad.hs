import Control.Applicative
import Control.Monad
import Control.Monad.Writer
import Data.List
import qualified Data.Map as M
import Data.Maybe
import Data.Monoid
import Data.Traversable(traverse)
import Graphics.X11.Xinerama
import Graphics.X11.Xlib(openDisplay, closeDisplay)
import System.Exit
import System.IO

import XMonad hiding (openDisplay, closeDisplay)
import XMonad.Actions.CopyWindow
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.UpdatePointer(updatePointer)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutHints
import XMonad.Layout.ResizableTile
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)


-- define keysyms not supplied by xmonad
xK_XF86VolumeUp = 0x1008ff13
xK_XF86VolumeDown = 0x1008ff11
xK_XF86VolumeMute = 0x1008ff12
xK_XF86ScreenSaver = 0x1008ff2d
xK_XF86Sleep = 0x1008ff2f
xK_XF86TouchpadToggle = 0x1008ffa9
xK_XF86MonBrightnessUp = 0x1008ff02
xK_XF86MonBrightnessDown = 0x1008ff03


main = do
    xmonad . urgency . myConfig
    	=<< mapM xmobarScreen =<< getScreens

urgency = withUrgencyHook NoUrgencyHook
	
myConfig statusbarhandles = docks $ ewmh $ defaultConfig {
	  terminal      = "urxvt"
        -- Mod3 was unused, so i remapped capslock to it for my modkey
        , modMask       = mod3Mask
        , borderWidth   = 1
	, logHook = myLogHook statusbarhandles
	, layoutHook = avoidStruts $ smartBorders (myLayoutHook)
        , manageHook = myManageHooks
        , keys = myKeys
        , mouseBindings = myMouseBindings
        , workspaces = myWorkspaces
        , focusFollowsMouse = False
        , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
        } 

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]

backlightupCmd = "xbacklight -inc 3.125"
backlightdownCmd = "xbacklight -dec 3.125"
volupCmd = "~/bin/pulsevolume up"
voldownCmd = "~/bin/pulsevolume down"
volmuteCmd = "~/bin/pulsevolume mute"
lockCmd = "xautolock -locknow"
sleepCmd = "~/bin/lockandsleep.sh"
touchpadCmd = "~/bin/toggle_touchpad.sh"
browserCmd = "google-chrome-stable"
privateBrowserCmd = "google-chrome-stable --incognito"
displayConfigCmd =  "autorandr --change --default laptop --force"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((0, xK_XF86VolumeUp),    spawn volupCmd) 
    , ((0, xK_XF86VolumeDown),  spawn voldownCmd) 
    , ((0, xK_XF86VolumeMute),  spawn volmuteCmd)
    , ((0, xK_XF86MonBrightnessUp),  spawn backlightupCmd)
    , ((modm, xK_Page_Up),      spawn backlightupCmd)
    , ((0, xK_XF86MonBrightnessDown),  spawn backlightdownCmd)
    , ((modm, xK_Page_Down),    spawn backlightdownCmd)
    , ((0, xK_XF86TouchpadToggle), spawn touchpadCmd)
    , ((0, xK_XF86ScreenSaver), spawn lockCmd)
    , ((modm, xK_x),            spawn lockCmd)
    , ((modm, xK_s),            spawn sleepCmd)
    -- Move cursor to middle of focused window.
    , ((modm, xK_f), updatePointer (0.5, 0.5) (1, 1))
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9]++[xK_0]++[xK_F1 .. xK_F12])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [ ((modm,               xK_Return    ), spawn $ XMonad.terminal conf)
    , ((modm,               xK_z         ), spawn $ XMonad.terminal conf)
    , ((modm,               xK_apostrophe), spawn browserCmd)
    , ((modm .|. shiftMask, xK_apostrophe), spawn privateBrowserCmd)
    , ((modm,               xK_p         ), spawn "dmenu_run")
    , ((modm .|. shiftMask, xK_p         ), spawn "gmrun")
    , ((modm .|. shiftMask, xK_c         ), kill)
    , ((modm,               xK_d         ), spawn displayConfigCmd)
    , ((modm,               xK_space     ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space     ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n         ), refresh)
    , ((modm,               xK_Tab       ), windows W.focusDown)
    , ((modm,               xK_j         ), windows W.focusDown)
    , ((modm,               xK_k         ), windows W.focusUp)
    , ((modm,               xK_m         ), windows W.focusMaster)
    , ((modm .|. shiftMask, xK_Return    ), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j         ), windows W.swapDown)
    , ((modm .|. shiftMask, xK_k         ), windows W.swapUp)
    , ((modm,               xK_h         ), sendMessage Shrink)
    , ((modm,               xK_l         ), sendMessage Expand)
    , ((modm .|. shiftMask, xK_h         ), sendMessage MirrorExpand)
    , ((modm .|. shiftMask, xK_l         ), sendMessage MirrorShrink)
    , ((modm,               xK_t         ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma     ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period    ), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_q         ), io (exitWith ExitSuccess))
    , ((modm              , xK_q         ), spawn "xmonad --recompile; xmonad --restart")
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
        -- resizableTiled is unused as there isn't a way to reset
        -- sizing yet. Left in place for future reference.
        resizableTiled = ResizableTall nmaster delta ratio []
        nmaster = 1 -- number of windows in master pane
        ratio = 1/2 -- ratio of space allocated to to master/slave panes
        delta = 3/100 -- increment for resizing panes

-- Like =?, but tests for substring instead of equality.
(=??) :: Eq a => Query [a] -> [a] -> Query Bool
q =?? x = fmap (isInfixOf x) q

myManageHooks = composeAll
    [ resource =? "Wine" --> doFloat
    , className =? "Wine" --> doFloat
    , className =? "Steam" --> doFloat
    , title =? "Ticket to Ride" --> doCenterFloat
    , title =? "Pandora" --> doFloat -- Pandora desktop app - doesn't deal with resizing right
    , title =? "Chromium Preferences" --> doCenterFloat
    , title =? "Page(s) Unresponsive" --> doCenterFloat
    , stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
    , isDialog --> doCenterFloat
    , isFullscreen -->  doFullFloat
    , stringProperty "WM_COMMAND" =?? "xev" --> doFloat
--    , fmap not (stringProperty "WM_WINDOW_ROLE" =? "browser") <&&> className =? "Google-chrome" --> doFloat
--    , isSticky --> doIgnore
-- This works, but suddenly EVERY desktop shows up as having windows. Reenable once that is fixed.
--    , isSticky --> manageSticky
    ]


-- Per-screen xmobars. Taken from http://www.haskell.org/haskellwiki/Xmonad/Config_archive/adamvo%27s_xmonad.hs --

getScreens :: IO [Int]
getScreens = openDisplay "" >>= liftA2 (<*) f closeDisplay
    where f = fmap (zipWith const [0..]) . getScreenInfo
 
multiPP :: PP -- ^ The PP to use if the screen is focused
        -> PP -- ^ The PP to use otherwise
        -> [Handle] -- ^ Handles for the status bars, in order of increasing X
                    -- screen number
        -> X ()
multiPP = multiPP' dynamicLogString
 
multiPP' :: (PP -> X String) -> PP -> PP -> [Handle] -> X ()
multiPP' dynlStr focusPP unfocusPP handles = do
    state <- get
    let pickPP :: WorkspaceId -> WriterT (Last XState) X String
        pickPP ws = do
            let isFoc = (ws ==) . W.tag . W.workspace . W.current $ windowset state
            put state{ windowset = W.view ws $ windowset state }
            out <- lift $ dynlStr $ if isFoc then focusPP else unfocusPP
            when isFoc $ get >>= tell . Last . Just
            return out
    traverse put . getLast
        =<< execWriterT . (io . zipWithM_ hPutStrLn handles <=< mapM pickPP) . catMaybes
        =<< mapM screenWorkspace (zipWith const [0..] handles)
    return ()
 
mergePPOutputs :: [PP -> X String] -> PP -> X String
mergePPOutputs x pp = fmap (intercalate (ppSep pp)) . sequence . sequence x $ pp
 
onlyTitle :: PP -> PP
onlyTitle pp = defaultPP { ppCurrent = const ""
                         , ppHidden = const ""
                         , ppVisible = const ""
                         , ppLayout = ppLayout pp
                         , ppTitle = ppTitle pp }
 
-- | Requires a recent addition to xmobar (>0.9.2), otherwise you have to use
-- multiple configuration files, which gets messy
xmobarScreen :: Int -> IO Handle
xmobarScreen = spawnPipe . ("xmobar -x " ++) . show


myLogHook statusbarhandles = do
    let myPP = xmobarPP { ppTitle = xmobarColor "gray" ""
                        , ppUrgent = xmobarColor "white" ""
                        }
    multiPP'
            (mergePPOutputs [dynamicLogString])
            myPP
            myPP
            statusbarhandles

