# Ctrl

A minimal widget library for **awesome wm**, providing
easily customizable tools for handling volume,
brightness and battery information.

![ctrl screenshot](https://i.imgur.com/ku7GK5y.png "15 (brightness) | 75% volume | full battery")

## Modules

### Battctl

A minimal battery status and notification widget.

### Lightctl

A portable backlight control widget with support for different
managers.

Compatible with different system backlight settings
(Intel and AMD), and tries to figure it out in other
cases.

Pseudo-bilogarithmic brightness adjustment tones it down
as you get closer to minimum and maximum values, giving
you more fine-grained control over extreme cases. 

### Soundctl

An alsamixer volume interface.

### Tray

Minimal tray container. 

### Spacer

A dynamic fully customizable spacing widget.

It's just a separator.

### Container

Simple configurable container widget.

## Features

- Both text and visual mode
- Mouse events 1 to 5 implemented by default
- Modular setup

Unfortunately I've had to remove support for progressbar
with text overlay because some parts were deprecated
and I was just trying to polish the code and to cleanse
all in excess.

Now it only has support for text or progressbar mode
separately, not combined.

I'm definitely planning on reimplementing that in a
cleaner fashion someday. Don't hold your breath though!

## Install

    cd ~/.config/awesome
    git clone https://github.com/cherrynoize/ctrl

## Configuration

### Customization

> Widget customization is handled in the `config.lua` file.
> 
> At the bare minimum you need to copy the
> `config.lua.def` into `config.lua` and restart awesome.
> 
> Configuration is shared among all modules, though there
> are some sections specific to each.

I tried to keep the file thoroughly commented so you can
hopefully work it out along the way and there'll be no
need for a separate documentation. It should be all
rather self-explanatory once you look at it.

#### Lightctl

Since `light` has become abandoned I developed my own
replacement and expanded the module to support it. It's a simple
shell script and it's completely optional. It also supports a
minimum (as well as maximum) threshold and both relative and
absolute brightness values.

You can get it from [here](https://github.com/cherrynoize/set-light).

### Theme

By default Ctrl tries to read from `beautiful` for a lot of
configuration values, and automatically falls back if it
doesn't find anything.

Things like colorschemes and font settings should be imported
easily, but if you wanted to configure other options in your
theme, you could then define any arbitrary property in the
configuration file like so:

    config.option = beautiful.my_option or previous_value

This way the previous value will be mantained as a
fallback, in case the theme option gets deleted.

> Just make sure Ctrl gets imported after the call to
`beautiful.init`.

## Usage

### Import

You can import modules like this: 

    local ctrl = require "ctrl"
    local battctl = ctrl.battctl
    local soundctl = ctrl.soundctl
    local lightctl = ctrl.lightctl
    local tray = ctrl.tray
    local sep = ctrl.spacer

Or like this:

    local battctl = require "ctrl.battctl"
    local soundctl = require "ctrl.soundctl"
    local lightctl = require "ctrl.lightctl"
    local tray = require "ctrl.tray"
    local sep = require "ctrl.spacer"

They both work the same way.

### Setup

Then simply add them to your `wibox:setup` section like
so: 

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
                tray.shelf,
                -- End of the new widgets!
            },
            mytextclock,
            s.mylayoutbox,
         },
      }

> This is just a sample config.
>
> The relevant section is enclosed in comments.

And you're good to go!

#### Container

Sample setup for the container can be found in `tray.lua`.

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

> The single modules are totally independent one from the
> other, but they all rely on the same central core.
>
> The only exception would be the Spacer widget.

Therefore if you didn't want Soundctl and Lightctl,
here's what you would do:

    git clone https://github.com/cherrynoize/ctrl
    cd ctrl
    rm soundctl.lua lightctl.lua

Or you could easily just have them lying around, if you
ever change your mind. I tried to keep the code down
to a minimum weight for the whole project, so it's small,
tidy and easily rearrangeable. In case you want to try
and use it to make your own widgets.

---

## Bugs

The widgets tend to work pretty well all in all for me,
but please do open an issue or contact me otherwise if you
encounter any problem whatsoever.

The general functionality is mostly respected and I do
not see errors on my machine:

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

- Brightness pseudo-log functions not always working as
  expected. I did make sure they work for the lowest
  edge, meaning the lowest brightness end of the
  spectrum, which was the most relevant use-case for the
  function anyway. More generally the current behaviour
  seems to be that it always decreases in small steps
  while going down (decreasing) and in normal steps
  going up (increasing) *after* the lowest edge.

Still works smoother than Spotify desktop though.

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

3) Install `light` or setup `set-light` and set `blightmgr` to
   either `light` or `set-light` respectively in the config file.

## Contacts

> u/cherrynoize
> 
> 0xo1m0x5w@mozmail.com

Please feel free to contact me about any feedback or
request.

## Donations

If you wanted to show your support or just buy me a Coke:

    ETH   0x5938C4DA9002F1b3a54fC63aa9E4FB4892DC5aA8

    SOL   G77bErQLYatQgMEXHYUqNCxFdUgKuBd8xsAuHjeqvavv

    BNB   0x0E0eAd7414cFF412f89BcD8a1a2043518fE58f82

    LUNC  terra1n5sm6twsc26kjyxz7f6t53c9pdaz7eu6zlsdcy

### Thank you

Thanks for using my software.
