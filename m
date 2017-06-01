MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170531005633.484a2e14@alans-desktop>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop> <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com> <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com> <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
 <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop> <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 31 May 2017 19:35:55 -0700
Message-ID: <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Matt Brown <matt@nmatt.com>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 30, 2017 at 4:56 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> This is my point. Apps will continue to shoot themselves in the foot. Of course
>> the correct response to one of these vulns is to not pass ttys across a
>> security boundary. We have an opportunity here to reduce the impact of this bug
>> class at the kernel level.
>
> Not really.
>
> If you pass me your console for example I can mmap your framebuffer and
> spy on you all day. Or I could reprogram your fonts, your keyboard, your
> video mode, or use set and paste selection to write stuff. If you are
> using X and you can't get tty handles right you'll no doubt pass me a
> copy of your X file descriptor in which case I own your display, your
> keyboard and your mouse and I don't need to use TIOCSTI there either.
>
> There are so many different attacks based upon that screwup that the
> kernel cannot defend against them. You aren't exactly reducing the impact.

I still cannot wrap my head around why providing users with a
protection is a bad thing. Yes, the other tty games are bad, but this
fixes a specific and especially bad case that is easy to kill. It's
got a Kconfig and a sysctl. It's not on by default. This protects the
common case of privileged ttys that aren't attached to consoles, etc,
so while the framebuffer thing is an issue, it's not always an issue,
etc.

I'd like to hear Greg's thoughts on this series...

-Kees

-- 
Kees Cook
Pixel Security
