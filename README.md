  ____ _        _
 / ___| |_ _ __| |
| |   | __| '__| | - Simple awesome wm widget library.
| |___| |_| |  | | - https://github.com/cherrynoize/ctrl
 \____|\__|_|  |_| - cherry-noize

# Ctrl

A minimal widget library for **awesome wm**, providing
easily customizable tools for handling volume,
brightness and battery information.

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

> The path is relative to the `awesome` config dir.
> (i.e: where `rc.lua` is.)

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

And you should be good to go!

> This is just a sample config.
>
> The relevant section is enclosed in the comments.

## Installing separate modules

The single modules are totally independent one from the
other, but they all rely on the same core.

> The core is comprised of `ui.lua`, `utils.lua` and
`config.lua`. Widgets need all three of these files to
work.
>> The only exception would be the Spacer widget.

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
