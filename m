MIME-Version: 1.0
In-Reply-To: <4a8e9445-4c3f-e44e-9d84-fef2ca956517@nmatt.com>
References: <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop> <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop> <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop> <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk> <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com> <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
 <20170602210544.73680be8@lxorguk.ukuu.org.uk> <48a28010-9f35-63e4-b815-71bb6139d50b@nmatt.com>
 <20170603230048.52b7f111@lxorguk.ukuu.org.uk> <4a8e9445-4c3f-e44e-9d84-fef2ca956517@nmatt.com>
From: Peter Dolding <oiaohm@gmail.com>
Date: Sun, 4 Jun 2017 13:37:39 +1000
Message-ID: <CANA3KFVXyJhUyxEiEBchbQwrMeO5_ZYY=J5mpaENyxhPXzWLpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 4, 2017 at 8:22 AM, Matt Brown <matt@nmatt.com> wrote:
> On 06/03/2017 06:00 PM, Alan Cox wrote:
>>>
>>> TIOCSLCKTRMIOS
>>
>>
>> That one I'm more dubious about
>>
>>> TIOCSLTC
>>> TIOCSSOFTCAR
>>
>>
>> tty_io.c also has a few and n_tty has a couple we'd want.
>>
>>>
>>> would it be overkill to have a sysctl kernel.ttyioctlwhitelist.X where X
>>> is one of the ioctls above?
>>
>>
>> Why would anyone want to change the entries on that list
>>
>
> Did you see Serge's proposed solution? I want us to not be talking past
> each other. Serge proposed the following:
>
> | By default, nothing changes - you can use those on your own tty, need
> | CAP_SYS_ADMIN against init_user_ns otherwise.
> |
> | Introduce a new CAP_TTY_PRIVILEGED.
> |
> | When may_push_chars is removed from the whitelist, you lose the
> | ability to use TIOCSTI on a tty - even your own - if you do not have
> | CAP_TTY_PRIVILEGED against the tty's user_ns.
>
> The question is how do you add/remove something from this whitelist? I
> assume by add/remove we don't mean that you have to recompile your
> kernel to change the whitelist!
>
> you earlier said you wanted the check to look like this:
>
> | if (!whitelisted(ioctl) && different_namespace && magic_flag)
>
> I want to know which namespace you are talking about here. Did you mean
> user_namespace? (the namespace I added tracking for in the tty_struct)

There are many ways to attempt to cure this problem.     They some
that are just wrong.

Pushing stuff up to CAP_SYS_ADMIN is fairly much always wrong.

Using a whitelisted solution does have a downside but to use some
application that use TIOCSTI safely I have not had to push application
to CAP_SYS_ADMIN.

Another question due to the way the exploit work a broken TIOCSTI
where push back could be something someone as CAP_SYS_ADMIN run.

What I don't know if yet set when ever an application used TIOCSTI to
push back chars back into input that this would set input to be
flushed on tty disconnect or application termination would this break
any applications.

So it may be possible to allow applications to freely use TIOCSTI just
make sure that anything an application has pushed back into input
buffer cannot get to anything else.

The thing to remember is most times when applications are controlling
other applications they are not pushing data backwards on input..

Question I have is what is valid usage cases of TIOCSTI.   Thinking
grscecurity got away with pushing this up to CAP_SYS_ADMIN there may
not be many.

If there is no valid usage of TIOCSTI across applications there is no
reason why TIOCSTI cannot be setup to automatically trigger input
flushs to prevent TIOCSTI inserted data getting anywhere.
.
This could be like X11 and it huge number of features where large
number were found that no one ever used just was created that way
because it was though like it would be useful.

My problem here is TIOCSTI might not need a flag at all.   TIOCSTI
functionality maybe in need of limitations particularly if TIOCSTI
push back into input cross from one application to the next has no
genuine application usage.

So far no one has started that exploited TIOCSTI functionality exists
in any genuine application as expected functionality.   I cannot find
example of where pushing back into input then going to background or
dieing/exiting and having that pushed back input processed is done by
any genuine application as expected functionality.   That is something
that could be limited if there is no genuine users and close the door
without having to modify existing applications that don't expect to-do
that.

Its really simple to get focused in on quick fix to problems without
asking is the behaviour even required.

Peter Dolding
