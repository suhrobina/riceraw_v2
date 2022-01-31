-- =====================================================================
--  __   _____  ___                      _   _
--  \ \ / /|  \/  |                     | | | |
--   \ V / | .  . | ___  _ __   __ _  __| | | |__  ___
--   /   \ | |\/| |/ _ \| '_ \ / _` |/ _` | | '_ \/ __|
--  / /^\ \| |  | | (_) | | | | (_| | (_| |_| | | \__ \
--  \/   \/\_|  |_/\___/|_| |_|\__,_|\__,_(_)_| |_|___/
--
-- =====================================================================
--          FILE: xmonad.hs
--
--         USAGE: Default folder is `~/.xmonad/`
--
--   DESCRIPTION: This is configuration file for xmonad
--                Created on xmonad version = 0.15
--                           xmonad-contrib version = 0.16
--
--  REQUIREMENTS: Packages: pkill xbacklight amixer dmenu paplay trayer
--                          sound-theme-freedesktop
--
--        AUTHOR: Suhrob R. Nuraliev, LongOverdueVitalEnergy@GMail.com
--     COPYRIGHT: Copyright (c) 2021
--       LICENSE: GNU General Public License
--       CREATED: 21 May 2021
--      REVISION: 31 Jan 2022
-- =====================================================================


------------------------------------------------------------------------
-- IMPORTS

  -- Base
import XMonad hiding ( (|||) )
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W

  -- Action
import XMonad.Actions.CycleWS
import XMonad.Actions.GroupNavigation
import XMonad.Actions.SwapPromote
import XMonad.Actions.WithAll

  -- Data
import Data.Maybe (fromJust)
import Data.Monoid
import qualified Data.Map as M

  -- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

  -- Layouts
import XMonad.Layout.Tabbed

  -- Layouts modifiers
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, NOBORDERS))
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

  -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.Run
import XMonad.Util.SpawnOnce


------------------------------------------------------------------------
-- VARIABLES

-- default font
myFontDefault :: String
myFontDefault = "xft:Iosevka:weight=regular:size=14:antialias=true:hinting=true"

-- large font
myFontLarge :: String
myFontLarge = "xft:Iosevka:weight=regular:size=40:antialias=true:hinting=true"

-- emoji font
myEmojiFont :: String
myEmojiFont = "xft:JoyPixels:weight=regular:size=14:antialias=true:hinting=true"

-- define dmenu font
myDMenuFont :: String
myDMenuFont = "Iosevka:weight=regular:size=14:antialias=true:hinting=true"

-- dmenu monitor numbers are starting from 0
myDMenuMonitorNo:: String
myDMenuMonitorNo = "0"

-- default terminal emulator
myTerminal :: String
myTerminal = "xterm"

-- default internet browser
myBrowser :: String
myBrowser = "iceweasel"

-- default file manager
myFileManager :: String
myFileManager = "vifm"

-- default music player daemon client
myMPDClient :: String
myMPDClient = "ncmpcpp"

-- default calculator
myCalculator :: String
myCalculator = "bc -l"

-- Whether focus follows the mouse pointer
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels
myBorderWidth :: Dimension
myBorderWidth = 2

-- Width of the window spacing in pixels
mySpacingWidth :: Integer
mySpacingWidth = 6

-- Sets modkey to super/windows key
myModMask :: KeyMask
myModMask = mod4Mask

-- Heigh of the decoration of Tabbed layout
myTabsDecoHeight :: Dimension
myTabsDecoHeight = 26

-- Window count function
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- My Workspaces
myWorkspaces    = ["SYS","DEV","WWW","CHAT"]
--myWorkspaces    = ["SYS","WWW","DEV","EXT","CHAT"]
--myWorkspaces    = ["1:GEN","2:WWW","3:SYS","4:DEV","5:VBOX","6:CHAT","7:MUS","8:DOC","9:GFX"]

-- Clickable workspaces
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Main Colors
--
--    PRIMARY COLOR: A primary color is the color displayed most frequently
--                   across your app's screens and components.
--
--  SECONDARY COLOR: A secondary color provides more ways to accent and distinguish
--                   your product. Having a secondary color is optional, and should
--                   be applied sparingly to accent select parts of your UI.
--
--                   Secondary colors are best for:
--                     * Floating action buttons
--                     * Selection controls, like sliders and switches
--                     * Highlighting selected text
--                     * Progress bars
--                     * Links and headlines
--
--    SURFACE COLOR: Surface colors affect surfaces of components, such as cards,
--                   sheets, and menus.
--
-- BACKGROUND COLOR: The background color appears behind scrollable content.
--                   The baseline background and surface color is #FFFFFF.
--
--      ERROR COLOR: Error color indicates errors in components, such as invalid
--                   text in a text field. The baseline error color is #B00020.
--
--      EXTRA COLOR: Optional
--
-- LINKS:
--
-- Haskell data color names:
--   https://hackage.haskell.org/package/colour-2.3.3/docs/Data-Colour-Names.html
--
-- 100 color combinations:
--   https://www.canva.com/learn/100-color-combinations/


-- Sun & Sky Theme
myColorPrimary           = "#756867" -- Wood Veener
myColorSecondary         = "#e29930" -- Mustard
myColorSurface           = "#444444" -- Grey2
myColorBackground        = "#282c34" -- Shade of Black Russian Color
myColorError             = "red"
myColorExtra1            = "darkseagreen"
myColorExtra2            = "snow"

--"#32384d" -- Asphalt

-- Shades of grey from darker to lighter
myColorGrey1             = "#222222"
myColorGrey2             = "#444444"
myColorGrey3             = "#bbbbbb"
myColorGrey4             = "#eeeeee"

-- Pure black & white colors
myColorBlack             = "#000000"
myColorWhite             = "#ffffff"

-- 16 ANSI Color Theme
myColorTangoNormalBlack  = "#000000"
myColorTangoNormalRed    = "#cc0000"
myColorTangoNormalGreen  = "#4e9a06"
myColorTangoNormalYellow = "#c4a000"
myColorTangoNormalBlue   = "#3465a4"
myColorTangoNormalPurple = "#75507b"
myColorTangoNormalCyan   = "#06989a"
myColorTangoNormalWhite  = "#d3d7cf"

myColorTangoBrightBlack  = "#555753"
myColorTangoBrightRed    = "#ef2929"
myColorTangoBrightGreen  = "#8ae234"
myColorTangoBrightYellow = "#fce94f"
myColorTangoBrightBlue   = "#739fcf"
myColorTangoBrightPurple = "#ad7fa8"
myColorTangoBrightCyan   = "#34e2e2"
myColorTangoBrightWhite  = "#eeeeec"

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = myColorSurface
myFocusedBorderColor = myColorSecondary

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
-- Check keysynm definitions:
-- /usr/include/X11/XF86keysym.h
-- /usr/include/X11/keysymdef.h

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- custom basic binds
    [ ((modm, xK_w ), spawn myBrowser)                                      -- Launch a browser
    , ((modm, xK_e ), spawn (myTerminal ++ " -e " ++ myFileManager))        -- Launch a file manager
    , ((modm, xK_a ), spawn (myTerminal ++ " -e " ++ myMPDClient))          -- Launch a mpd client
    , ((modm, xK_c ), spawn (myTerminal ++ " -e " ++ myCalculator))         -- Launch a calculator
    , ((modm .|. shiftMask, xK_BackSpace),
              spawn (myTerminal ++ " -e tmux new-session -A -s 'Default'")) -- Launch terminal multiplexer

    -- power management
    , ((modm .|. shiftMask, xK_r), spawn "dmenu_prompt.sh 'Reboot computer?' 'paplay /usr/share/sounds/freedesktop/stereo/service-logout.oga;systemctl reboot'" )                  -- Reboot computer
    , ((modm .|. shiftMask, xK_h), spawn "dmenu_prompt.sh 'Hibernate computer?' 'paplay /usr/share/sounds/freedesktop/stereo/service-logout.oga;systemctl hibernate && slimlock'") -- Hibernate computer
    , ((modm .|. shiftMask, xK_x), spawn "dmenu_prompt.sh 'Shutdown computer?' 'paplay /usr/share/sounds/freedesktop/stereo/service-logout.oga;systemctl poweroff'")               -- Shutdown computer
    , ((0,          xF86XK_Tools), spawn "systemctl suspend && slimlock")                                                                                                          -- Suspend computer
    , ((modm .|. shiftMask, xK_l), spawn "slimlock")                                                                                                                               -- Lock screen

    -- brightness/audio
    , ((0, xF86XK_MonBrightnessDown              ), spawn "xbacklight -dec 1")  -- Adjust screen's backlight brightness for -1%
    , ((0 .|. shiftMask, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")  -- Adjust screen's backlight brightness for -5%
    , ((0, xF86XK_MonBrightnessUp                ), spawn "xbacklight -inc 1")  -- Adjust screen's backlight brightness for +1%
    , ((0 .|. shiftMask, xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 5")  -- Adjust screen's backlight brightness for +5%

    , ((0, xF86XK_AudioLowerVolume               ), spawn "amixer sset Master 5%-; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga" )  -- Decrease audio volume for +5%
    , ((0 .|. shiftMask, xF86XK_AudioLowerVolume ), spawn "amixer sset Master 10%-; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga")  -- Decrease audio volume for +10%
    , ((0, xF86XK_AudioRaiseVolume               ), spawn "amixer sset Master 5%+; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga" )  -- Increase audio volume for +5%
    , ((0 .|. shiftMask, xF86XK_AudioRaiseVolume ), spawn "amixer sset Master 10%+; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga")  -- Increase audio volume for +10%

    , ((0, xF86XK_AudioMute                      ), spawn "amixer sset Master toggle; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga ") -- Mute/Unmute audio
    , ((0, xF86XK_AudioMicMute                   ), spawn "amixer sset Capture toggle; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga") -- Mute/Unmute microphone

    -- recording
    , ((0, xK_Print         ), spawn "screenshot.sh"       ) -- Take screenshot
    , ((shiftMask, xK_Print ), spawn "dmenu_maimpick.sh"   ) -- Choose the kind of screenshot to take
    , ((modm,      xK_Print ), spawn "dmenu_record.sh"     ) -- Record audio and video
    , ((modm,      xK_Delete), spawn "dmenu_record.sh kill") -- Stop recording

    -- extras
    , ((0,         xF86XK_LaunchA ), spawn "killall screenkey || screenkey") -- Toggle screen key
    , ((0,         xF86XK_Display ), spawn "toggle-webcam.sh"              ) -- Toggle Web camera window
    , ((0,         xF86XK_Explorer), spawn "dmenu_mount.sh"                ) -- Mount USB drive or Android device
    , ((shiftMask, xF86XK_Explorer), spawn "dmenu_umount.sh"               ) -- Unmount USB drive or Android device
    , ((0,         xF86XK_Search  ), spawn "dmenu_websearch.sh"            ) -- Quick Web Search

    ]

    ++

    -- launching and killing programs
    [ ((modm, xK_F1), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)       -- Launch a terminal
    , ((modm,               xK_p     ), spawn ("dmenu_run -i -p 'RUN' "
                                               ++ "-m "   ++ myDMenuMonitorNo  ++ " "
                                               ++ "-fn '" ++ myDMenuFont       ++ "' "
                                               ++ "-nb '" ++ myColorBackground ++ "' "
                                               ++ "-nf '" ++ myColorGrey3      ++ "' "
                                               ++ "-sb '" ++ myColorPrimary    ++ "' "
                                               ++ "-sf '" ++ myColorGrey4      ++ "' "
                                               ))                           -- Launch dmenu
    , ((modm,               xK_q     ), kill)                               -- Close/kill the focused window

    -- layout operations
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- Reset the layouts on the current workspace to default
    , ((modm,               xK_n     ), sendMessage NextLayout)             -- Rotate through the available layout algorithms
    , ((modm,               xK_g     ), sendMessage $ JumpToLayout "til")   -- Jump directly to the 'til' layout
    , ((modm,               xK_r     ), sendMessage $ JumpToLayout "mti")   -- Jump directly to the 'mti' layout
    , ((modm,               xK_f     ), sendMessage $ JumpToLayout "tab")   -- Jump directly to the 'tab' layout
    , ((modm,               xK_space ),
               sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)  -- Toggle noborders/full

    -- move focus up or down the window stack
    , ((modm,               xK_j     ), windows W.focusDown)                -- Move focus to the next window
    , ((modm,               xK_k     ), windows W.focusUp  )                -- Move focus to the previous window
    , ((modm,               xK_m     ), windows W.focusMaster  )            -- Move focus to the master window
      -- method described here...
      -- https://www.reddit.com/r/xmonad/comments/1oi2xs/how_to_jump_back_from_master_window/
    , ((modm,               xK_Tab   ), nextMatch History (return True))    -- Move focus to the previous window

    -- modifying the window order
    , ((modm,               xK_Return), swapPromote' False  )               -- Swap the focused window and the master window and visa versa
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )               -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )               -- Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modm,               xK_h     ), sendMessage Shrink)                 -- Shrink the master area
    , ((modm,               xK_l     ), sendMessage Expand)                 -- Expand the master area

    -- floating layer support
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)     -- Push window back into tiling

    -- increase or decrease number of window in the master area
    , ((modm              , xK_i     ), sendMessage (IncMasterN 1))         -- Increase the number of windows in the master area
    , ((modm              , xK_d     ), sendMessage (IncMasterN (-1)))      -- Decrease the number of windows in the master area

    -- quit or restart
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))          -- Quit xmonad
    , ((modm              , xK_Escape), spawn "xmonad --recompile; xmonad --restart;notify-send 'XMonad' 'Recompiled and restarted!'") -- Recompile and restart xmonad

    ]

    ++

    -- magnifier layout modifier commands
    [ ((modm,               xK_bracketleft ),
                          sendMessage MagnifyLess >> sendMessage ToggleOn)  -- Make the focused window smaller
    , ((modm,               xK_bracketright),
                          sendMessage MagnifyMore >> sendMessage ToggleOn)  -- Make the focused window bigger
    , ((modm,               xK_backslash   ), sendMessage Toggle)           -- Toggle the Magnifier layout modifier
    ]

    ++

    -- rotate through the available workspaces
    [ ((modm,               xK_comma ), prevWS)                              -- Switch to the previous workspace
    , ((modm,               xK_period), nextWS)                              -- Switch to the next workspace
    ]

    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]


    --  ++
    --
    --  --
    --  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    --  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --  --
    --  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- bind events to the mouse scroll wheel
    , ((modm, button4), (\w -> prevWS))
    , ((modm, button5), (\w -> nextWS))


    -- bind alternative brightness/audio
    , ((modm .|. shiftMask .|. controlMask, button4), (\w -> spawn "xbacklight -inc 1"))
    , ((modm .|. shiftMask .|. controlMask, button5), (\w -> spawn "xbacklight -dec 1"))

    , ((modm .|. shiftMask, button4), (\w -> spawn "amixer sset Master 5%+; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
    , ((modm .|. shiftMask, button5), (\w -> spawn "amixer sset Master 5%-; paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = myFontLarge
    , swn_bgcolor           = myColorBackground
    , swn_color             = myColorGrey4
    , swn_fade              = 0.8
    }

-- Setting colors for tabbed layout and tabbed sublayout.
myTabConfig = def { fontName            = myFontDefault
                  , activeColor         = myColorSecondary
                  , inactiveColor       = myColorSurface
                  , urgentColor         = myColorError
                  , activeBorderColor   = myColorSecondary
                  , inactiveBorderColor = myColorSecondary
                  , urgentBorderColor   = myColorSecondary
                  , activeTextColor     = myColorGrey1
                  , inactiveTextColor   = myColorGrey4
                  , urgentTextColor     = myColorGrey1
                  , decoHeight          = myTabsDecoHeight
                  }

-- Sets the gap size around the window
sw  = mySpacingWidth
mySpacing = spacingRaw False (Border sw sw sw sw) True (Border sw sw sw sw) True

-- Sets the gap size around the window for tabbed layout
sw2 = mySpacingWidth + mySpacingWidth
mySpacingForTabbedLayout = spacingRaw False (Border sw2 sw2 sw2 sw2) True (Border 0 0 0 0) True

-- Defining a bunch of layouts, some of them not using

til     = renamed [Replace "til"] -- Layout Tiled
        $ mySpacing
        $ magnifierOff
        $ Tall 1 (3/100) (1/2)

mti    = renamed [Replace "mti"]      -- Layout Mirror Tiled
        $ mySpacing
        $ magnifierOff
        $ Mirror
        $ Tall 1 (3/100) (1/2)

tab    = renamed [Replace "tab"]  -- Layout Tabbed
        $ mySpacingForTabbedLayout
        $ tabbed shrinkText myTabConfig

full   = renamed [Replace "ful"] -- Layout Full
        $ Full


-- The Layout Hook
myLayoutHook =   avoidStruts
        $ mkToggle (NBFULL ?? NOBORDERS ?? EOT)
        $ myDefaultLayout
  where
     myDefaultLayout =     til
                       ||| mti
                       ||| tab

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "confirm"           --> doFloat
    , className =? "file_progress"     --> doFloat
    , className =? "dialog"            --> doFloat
    , className =? "download"          --> doFloat
    , className =? "error"             --> doFloat
--    , className =? "Gimp"              --> doFloat
    , className =? "KeePassXC"         --> doFloat
    , resource  =? "desktop_window"    --> doIgnore
    , resource  =? "kdesktop"          --> doIgnore
    , title     =? "Mozilla Firefox"   --> doShift ( myWorkspaces !! 2 )
    , className =? "TelegramDesktop"   --> doShift ( myWorkspaces !! 3 )
    ]


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()


  -- historyHook(XMonad.Actions.GroupNavigation):
  -- Used a hook to store recent focus data.

  -- masterHistoryHook (XMonad.Actions.SwapPromote):
  -- Mapping from workspace tag to master history list. The current
  -- master is the head of the list, the previous master the second
  -- element, and so on. Without history, the list is empty

myLogHook = historyHook >> masterHistoryHook

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "setxkbmap -option caps:escape"    -- Map CAPSLOCK to ESCAPE
    spawnOnce "xset r rate 300 50"               -- Speed xrate up
    spawnOnce "pointer-devices.sh"               -- Pointer devices configuration script
    spawnOnce "power-manager.sh &"               -- Power Manager script
    -- spawnOnce "xcalib -d :0 .local/share/color/AUO_B140HAN01.3-26.icm" -- Load monitor calibration profile

    spawnOnce "mpd &"                            -- Music Player Daemon
    -- spawnOnce "unclutter -grab &"             -- Remove mouse pointer when idle
    spawnOnce "xsetroot -cursor_name left_ptr &" -- Set cursor
    spawnOnce "dunst &"                          -- Notification Daemon
    spawnOnce "fbxkb &"                          -- Keyboard indicator and switcher
    spawnOnce "compton &"                        -- Compositor
    spawnOnce "nitrogen --restore &"             -- Wallpaper restore
    spawnOnce "nm-applet &"                      -- Network Manager
    spawnOnce "remmina -i &"                     -- Remote Desktop Client
    spawnOnce "blueman-applet &"                 -- Bluetooth Manager
    spawnOnce "redshift-gtk &"                   -- Color temperature adjustment tool
    spawnOnce "syncthing-gtk -m &"               -- GUI for Syncthing
    spawnOnce "telegram &"                       -- Favorite messenger
    spawnOnce "uget-gtk &"                       -- Download Manager
    spawnOnce "QOwnNotes &"                      -- Note Taking Software
    spawnOnce "keepassxc &"                      -- Password Manager
    spawnOnce "pkill trayer; trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --tint 0x282c34  --height 25 &"   -- Systray
    spawnOnce "sleep 4;notify-send 'Welcome to RiceRAW on Linux with XMonad!' 'Press SUPER+F1 to the help.'"  -- Welcome Notification
    spawnOnce "paplay /usr/share/sounds/freedesktop/stereo/service-login.oga" -- Login sound
    setWMName "LG3D"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
	-- Launching three instances of xmobar on their monitors.
	xmproc0 <- spawnPipe "pkill xmobar; xmobar -x 0 ~/.xmobar/xmobarrc"
	-- xmproc1 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc1"
	-- xmproc2 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc2"

	xmonad $ docks $ defaults xmproc0 -- for passing xmproc0 to defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults xmproc0 = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = showWName' myShowWNameTheme $ myLayoutHook,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook,
        logHook            = myLogHook >> ( dynamicLogWithPP
                                    $ xmobarPP { ppOutput = hPutStrLn xmproc0
                                               , ppCurrent = xmobarColor myColorSecondary "" . wrap "<fn=1>" "</fn>"
                                               , ppVisible = xmobarColor "" "" . clickable
                                               , ppHidden = xmobarColor "grey" "" . clickable
                                               , ppHiddenNoWindows = xmobarColor "dimgray" "" . clickable
                                               , ppUrgent = xmobarColor myColorError ""
                                               , ppSep =  " • "
                                               , ppTitle = xmobarColor myColorExtra2 "" . shorten 60
                                               , ppLayout = xmobarColor myColorExtra1  ""
                                               , ppExtras = [windowCount]
                                               }
                                           )
         }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'super'. Default keybindings:",
     "",
         "-- launching and killing programs",
         "[Super]+[Shift]+[Enter]  Start terminal",
         "[Super]+[p]              Spawn dmenu for launching other programs",
         "[Super]+[Shift]+[q]      Close/kill the focused window",
         "",
         "-- layout operations",
         "[Super]+[Shift]+[Space]  Reset the layouts on the current workspace to default",
         "[Super]+[n]              Rotate through the available layout algorithms",
         "[Super]+[g]              Jump directly to the 'Tiled' layout",
         "[Super]+[r]              Jump directly to the 'Mirror Tiled' layout",
         "[Super]+[f]              Jump directly to the 'Tabbed' layout",
         "[Super]+[Space]          Toggle 'Full' layout",
         "",
         "-- magnifier layout modifier commands",
         "[Super]+[BackSlash]      Toggle the Magnifier layout modifier",
         "[Super]+[[]              Make the focused window smaller",
         "[Super]+[]]              Make the focused window bigger",
         "",
         "-- move focus up or down the window stack",
         "[Super]+[j]              Move focus to the next window",
         "[Super]+[k]              Move focus to the previous window",
         "[Super]+[m]              Move focus to the master window",
         "[Super]+[Tab]            Move focus to the previous window",
         "",
         "-- modifying the window order",
         "[Super]+[Return]         Swap the focused window and the master window and visa versa",
         "[Super]+[Shift]+[j]      Swap the focused window with the next window",
         "[Super]+[Shift]+[k]      Swap the focused window with the previous window",
         "",
         "-- resizing the master/slave ratio",
         "[Super]+[h]              Shrink the master area",
         "[Super]+[l]              Expand the master area",
         "",
         "-- floating layer support",
         "[Super]+[t]              Push window back into tiling",
         "",
         "-- increase or decrease number of windows in the master area",
         "[Super]+[i]              Increase the number of windows in the master area",
         "[Super]+[d]              Decrease the number of windows in the master area",
         "",
         "-- quit, or restart",
         "[Super]+[Escape]         Recompile and restart xmonad ",
         "[Super]+[Shift]+[q]      Quit xmonad",
         "",
         "-- workspaces & screens",
         "[Super]+[1..9]           Switch to workspace N",
         "[Super]+[Shift]+[1..9]   Move client to workspace N",
         "[Super]+[w,e,r]          Switch to physical/Xinerama screens 1, 2, or 3",
         "[Super]+[Shift]+[w,e,r]  Move client to screen 1, 2, or 3",
         "",
         "-- rotate through the available workspaces",
         "[Super]+[,]              Switch to the previous workspace",
         "[Super]+[.]              Switch to the next workspace",
         "",
         "-- mouse bindings: default actions bound to mouse events",
         "[Super]+[button1]        Set the window to floating mode and move by dragging",
         "[Super]+[button2]        Raise the window to the top of the stack",
         "[Super]+[button3]        Set the window to floating mode and resize by dragging",
         "[Super]+[button4]        Switch to the previous workspace",
         "[Super]+[button5]        Switch to the next workspace",
         "",
         "For other bindings check ~/.xmonad/xmonad.hs"]



