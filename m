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
 <48a28010-9f35-63e4-b815-71bb6139d50b@nmatt.com>
 <20170603230048.52b7f111@lxorguk.ukuu.org.uk>
From: Matt Brown <matt@nmatt.com>
Message-ID: <4a8e9445-4c3f-e44e-9d84-fef2ca956517@nmatt.com>
Date: Sat, 3 Jun 2017 18:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <20170603230048.52b7f111@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/03/2017 06:00 PM, Alan Cox wrote:
>> TIOCSLCKTRMIOS
>
> That one I'm more dubious about
>
>> TIOCSLTC
>> TIOCSSOFTCAR
>
> tty_io.c also has a few and n_tty has a couple we'd want.
>
>>
>> would it be overkill to have a sysctl kernel.ttyioctlwhitelist.X where X
>> is one of the ioctls above?
>
> Why would anyone want to change the entries on that list
>

Did you see Serge's proposed solution? I want us to not be talking past
each other. Serge proposed the following:

| By default, nothing changes - you can use those on your own tty, need
| CAP_SYS_ADMIN against init_user_ns otherwise.
|
| Introduce a new CAP_TTY_PRIVILEGED.
|
| When may_push_chars is removed from the whitelist, you lose the
| ability to use TIOCSTI on a tty - even your own - if you do not have
| CAP_TTY_PRIVILEGED against the tty's user_ns.

The question is how do you add/remove something from this whitelist? I
assume by add/remove we don't mean that you have to recompile your
kernel to change the whitelist!

you earlier said you wanted the check to look like this:

| if (!whitelisted(ioctl) && different_namespace && magic_flag)

I want to know which namespace you are talking about here. Did you mean
user_namespace? (the namespace I added tracking for in the tty_struct)
