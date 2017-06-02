References: <20170530132427.016053da@alans-desktop>
 <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop>
 <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop>
 <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop>
 <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk>
 <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com>
 <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
 <20170602210544.73680be8@lxorguk.ukuu.org.uk>
From: Matt Brown <matt@nmatt.com>
Message-ID: <48a28010-9f35-63e4-b815-71bb6139d50b@nmatt.com>
Date: Fri, 2 Jun 2017 16:46:24 -0400
MIME-Version: 1.0
In-Reply-To: <20170602210544.73680be8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/2/17 4:05 PM, Alan Cox wrote:
>> Can't we also have a sysctl that toggles if CAP_SYS_ADMIN is involved in
>> this whitelist check? Otherwise someone might leave things out of the
>> whitelist just because they want to use those ioctls as a privileged
>> process. Also restricting a privileged user from ioctls with this
>> whitelist approach is going to be pointless because, if the whitelist is
>> configurable from userspace, they will just be able to modify the
>> whitelist.
> 
> Something like CAP_SYS_ADMIN is fine if you must have it configurable on
> the grounds that CAP_SYS_ADMIN will let you override the list anyway.
> 
>> I'm fine with moving this to an LSM that whitelists ioctls. I also want
>> to understand what a whitelist would like look and how you would
>> configure it? Does a sysctl that is a list of allowed ioctls work? I
>> don't want to just have a static whitelist that you can't change without
>> recompiling your kernel.
> 
> That's odd because your previous argument was for a fixed one entry
> whitelist containing TIOCSTI 8)
> 

I just take some convincing that's all ;)

> The list can probably be fixed. IMHO those wanting to do cleverer stuff
> sre inevitably going to end up using a "grown up" LSM for the job because
> 

I really want it to be more flexible if we are making this into a full
blown LSM. From drivers/tty/tty_ioctl.c I gather the following tty
ioctls:

TCGETA
TCGETS
TCGETS2
TCGETX
TCSETA
TCSETAF
TCSETAW
TCSETS
TCSETS2
TCSETSF
TCSETSF2
TCSETSW
TCSETSW2
TCSETX
TCSETXF
TCSETXW
TIOCGETC
TIOCGETP
TIOCGLCKTRMIOS
TIOCGLTC
TIOCGSOFTCAR
TIOCSETC
TIOCSETN
TIOCSETP
TIOCSLCKTRMIOS
TIOCSLTC
TIOCSSOFTCAR

would it be overkill to have a sysctl kernel.ttyioctlwhitelist.X where X
is one of the ioctls above?

(definitely will work on a better name than ttyioctlwhitelist)


> a) they'll want to shape things like su not just containers
> b) they will have cases where you want to lock down cleverly - eg you can
> disable TIOCSTI use except by certain apps, and make those apps non
> ptraceable so only existing real users of it can continue to use it.

I agree. When you have those kinds of requirements, a MAC is required.

> 
> For the whitelist you want most of the standard tty ioctls, but none of
> the device specific ones, none of the hardware configuration ones, no
> TIOCSTI, no selection, no line discipline change (or you can set a
> network ldisc or various other evil and fascinating things).
> 
> I really think that for container type uses the whitelist can be fairly
> clearly defined because we know a container isn't supposed to be screwing
> with the hardware of the parent, configuring network interfaces or
> pushing data to trip people up.
> 
> If we are prepared to accept nuisance attacks (messing up baud rate,
> hangup, etc) then it's fairly easy to fix.
> 
> So I'd say it's all the generic tty ioctls except TIOCSTI and TIOCSETD
> but it would be good to see what Android is going with and why.
> 
> You can still do some typeback stuff even then because the consoles and
> terminals have ranges of query and requests you can trigger. As you can
> use termios to absorb some symbols in the reply and map which one to use
> for newline you can even type stuff. However it's very limited - hex
> digits, [, c and some other oddments. People have looked hard at that and
> I've yet to see a successful attack. Yes I can make you run test (aka
> '[') but I've yet to see a way to use it for anything.
> 
> Alan
> 
