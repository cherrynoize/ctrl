      ____ _        _
     / ___| |_ _ __| |
    | |   | __| '__| | - Simple awesome wm widget library.
    | |___| |_| |  | | - https://github.com/cherrynoize/ctrl
     \____|\__|_|  |_| - cherry-noize

------------------------------------------------------


# Ctrl

A minimal widget library for **awesome wm**, providing
easily customizable tools for handling volume,
brightness and battery information.

## Features

- support for both text and visual mode
- `light` support
- `alsamixer` for audio configuration 
- portability between Intel and AMD
- tries to figure it on its own in other scenarios
- mouse events support (1 to 5 by default)
- pseudo-bilogarithmic brightness adjustment
  (tones it down as you get closer to the extremes)
- modular widget installation

Unfortunately I've had to remove support for progressbar
with text overlay because some parts were deprecated
and I was just trying to polish the code and to cleanse
all in excess.

Now it only has support for text or progressbar mode
separately, not combined.

I'm definitely planning on reimplementing that in a
cleaner fashion someday. Don't hold your breath though!

## Install

    git clone https://github.com/cherrynoize/ctrl

## Configuration

### Customization

Widget customization is handled in the `config.lua` file.

Configuration is shared among all modules, though there
are sections specific to each.

I tried to keep the file well commented so you can
hopefully work it out on the spot and there'll be no
need for a separate documentation. It should be all
rather self-explanatory.

### Ctrl variable

There is also a `ctrl` variable definition at the top of
each module.

That is used for cross-interaction between different
files in the repo. You need to point it to the path
you cloned this repo in.

> The path is relative to the `awesome` (`rc.lua`) config
> path.

### Theme

By default you can import your theme in the configuration
file to automatically derive colorschemes and font
settings.

If you wanted to configure more options in your theme,
you can set them for an arbitrary property in the
configuration file like so:

    config.option = theme.my_option or previous_value

This way the previous value will be mantained as a
fallback, in case the theme option gets deleted.

## Usage

### Import

After you've set the correct path in the modules you
want to use, you need to import them (in your `rc.lua`,
for instance):

    local ctrl     = "path/to/ctrl"
    local battctl  = require (ctrl .. "battctl")
    local soundctl = require (ctrl .. "soundctl")
    local lightctl = require (ctrl .. "lightctl")
    local sep      = require (ctrl .. "spacer")

### Setup

Then simply add them to your `wibox:setup` like so: 

    -- Setup wibox layout and widgets.
    s.mywibox:setup {
        layout = wibox.layout.stack,
        { -- Left widgets
            -- ...
        },
        layout = wibox.layout.align.horizontal,
        s.mytasklist,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            align = right,
            {
                layout = wibox.layout.fixed.horizontal,
                align = "center",
                valign = "center",
                spacing = 20,

                -- These are the new widgets!
                spacing_widget = sep.arator,
                lightctl.widget,
                soundctl.widget,
                battctl.widget,
                -- End of the new widgets!
            },
            mytextclock,
            s.mylayoutbox,
         },
      }

> This is just a sample config.
>
> The relevant section is enclosed in the comments.

And you should be good to go!

### Keybindings

Yes, I lied. If you restart your config you should notice
that as of now you're just staring at your current
backlight value and it's not very fun.

So you probably want to set up some keybindings, before
these tools are any use.

This is a sample config for the `awful` keybindings to
get you started.

    -- Soundctl.
    awful.key({}, "XF86AudioRaiseVolume", soundctl.up),
    awful.key({}, "XF86AudioLowerVolume", soundctl.down),
    awful.key({}, "XF86AudioMute", soundctl.togglemute),
    awful.key({modkey, "Control", "Shift"}, "q", soundctl.max),
    awful.key({modkey, "Control", "Shift"}, "w", soundctl.half),
    awful.key({modkey, "Control", "Shift"}, "e", soundctl.min),
    awful.key({modkey, "Control", "Shift"}, "m", soundctl.togglemute),

    -- Lightctl.
    awful.key({}, "XF86MonBrightnessDown", lightctl.logdown),
    awful.key({}, "XF86MonBrightnessUp", lightctl.logup),
    awful.key({modkey}, "XF86MonBrightnessUp", lightctl.all),
    awful.key({modkey}, "XF86MonBrightnessDown", lightctl.min),
    awful.key({modkey, "Control", "Shift"}, "a", lightctl.all),
    awful.key({modkey, "Control", "Shift"}, "s", lightctl.half),
    awful.key({modkey, "Control", "Shift"}, "d", lightctl.min)

Other functions for lightctl would include for instance
`up` and `down`, which you could substitute for `logup`
and `logdown` if you wanted an always linear behaviour
when pressing the brightness keys. 

## Installing separate modules

The single modules are totally independent one from the
other, but they all rely on the same central core.

> The only exception would be the Spacer widget.

So, say you wanted to install the Battctl widget alone.

Here's what you would do:

    git clone https://github.com/cherrynoize/ctrl
    cd ctrl
    rm soundctl.lua lightctl.lua spacer.lua

Or you could always just keep them sleeping, in case
you change your mind. I tried to keep the code down to
a minimum weight for the whole project, so it's small,
tidy and easily rearrangeable, in case you wanted to
use it to make your own widgets.

## Bugs

The widgets tend to work pretty well all in all for me,
but please do open an issue or contact me otherwise if you
encounter any disturbance whatsoever.

The general functionality is mostly respected and I do
not have any fatal errors on my configuration:

    $ awesome -v
    awesome v4.3 (Too long)
     • Compiled against Lua 5.3.6 (running with Lua 5.3)
     • D-Bus support: ✔
     • execinfo support: ✔
     • xcb-randr version: 1.6
     • LGI version: 0.9.2

    $ lua -v
    Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio

The program is far from perfect though. Aside from the
features that still need implementation, this is a list
of well known bugs:

- Brightness pseudolog functions not always working as
  expected. I did make sure they work for the lowest
  edge, meaning the lowest brightness end of the
  spectrum, which was the most relevant use-case for the
  function anyway. More generally the current behaviour
  seems to be that it always decreases in small steps
  while going down (decreasing) and in normal steps
  *after* the lowest edge.

Still works smoother than the Spotify desktop app.

     ____       _
    |  _ \  ___| |__  _   _  __ _
    | | | |/ _ \ '_ \| | | |/ _` |
    | |_| |  __/ |_) | |_| | (_| |
    |____/ \___|_.__/ \__,_|\__, |
       --Troubleshooting--  |___/

------------------------------------------------------


## Troubleshooting

### Misc

1) Remember paths for custom theme and widgets
   directory are relative to rc.lua.

### Config

1) If theme properties are not respected check the
   variables requested from theme in the config file and 
   update them to match the definitions used in your 
   actual theme.

### Lightctl

1) Make sure you've set the correct udev permissions.

2) You may want to edit the backlight path variables
   to best suit your system.

3) Install `light` and set `use_light` to true in 
   the Lightctl configuration.

## Contacts

u/cherrynoize
0xo1m0x5w@mozmail.com

Please feel free to contact me about any feedback or
request.

## Donations

If you want to support me:

0x5938C4DA9002F1b3a54fC63aa9E4FB4892DC5aA8 (ETH)
G77bErQLYatQgMEXHYUqNCxFdUgKuBd8xsAuHjeqvavv (SOL)
0x0E0eAd7414cFF412f89BcD8a1a2043518fE58f82 (BNB)
terra1n5sm6twsc26kjyxz7f6t53c9pdaz7eu6zlsdcy (LUNC)

### Thank you

Thank you for using my software!
