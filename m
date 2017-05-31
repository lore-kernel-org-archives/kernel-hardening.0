MIME-Version: 1.0
In-Reply-To: <20170530225245.092497be@alans-desktop>
References: <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
 <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com> <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop> <1495045540.1619.1.camel@gmail.com>
 <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
 <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
 <20170519143344.GA15983@mail.hallyn.com> <CANA3KFXVzSXuA4Cocm7fUYE9EOvJX7pW0bsj=cgyUYvScUsXGQ@mail.gmail.com>
 <20170530155235.GA11861@mail.hallyn.com> <20170530225245.092497be@alans-desktop>
From: Peter Dolding <oiaohm@gmail.com>
Date: Wed, 31 May 2017 21:27:49 +1000
Message-ID: <CANA3KFWE2kUwdzGAGwRn8x4ceFzx5Z-quC2WBwqvks8LkTCh+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 31, 2017 at 7:52 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> > So tty stuff should under a tty capabilities.
>>
>> (last reply on this)
>>
>> Currently capabilities.7 says
>>
>>               * employ  the  TIOCSTI ioctl(2) to insert characters into the input queue of a
>>                 terminal other than the caller's controlling terminal;
>>
>> for CAP_SYS_ADMIN.
>>
>> So you can create a new CAP_SYS_TIOCSSTI if you like, and offer a patch where
>> *both* CAP_SYS_ADMIN and CAP_SYS_ADMIN suffice.  Again, see CAP_SYSLOG for a
>> prior example.
>
> Even then it wouldn't be useful because the attacker can use every other
> interface in the tty layer, many of which you can't magic away behind a
> capability bit. And the applications would need changing to use the
> feature - at which point any theoretical broken apps can instead be fixed
> to use a pty/tty pair and actually fix the real problem.
>
Alan is right.   CAP_SYS_ADMIN allows crossing the tty barrier.

Broken applications that you can wrap in a pty/tty pair as the lxc
application does would be defeated if those applications move up to
CAP_SYS_ADMIN.  Because you have granted the high right of cross
pty/tty containment.

Pushing CAP_SYS_TIOSSTI out by itself without the feature in
CAP_SYS_ADMIN means broken applications can be allowed to run in like
a lxc container where they cannot go anywhere with the exploit because
the pty/tty they are picking is not going to get them very far at all.

Pushing TIOSSTI up to CAP_SYS_ADMIN to address this problem is wrong.
 Question is also how many applications use CAP_SYS_ADMIN feature to
push chars into other pty/tty on the system.   Pushing across pty/tty
barrier may not be a suitable feature to be generically in
CAP_SYS_ADMIN in the first place.

http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/

This here is example of TIOSSTI pushback as CAP_SYS_ADMIN being bad.
I don't know of a genuine program using push back in exploiting way
where the pushed back input is expected to be processed after the
program has terminated.

Really we need to work out how many breakage will in fact be caused by
majority restricting both pushback and write across tty barrier.
This is not like CAP_SYS_LOG these are features that can be used to
exploit system badly.   It is possible that the exploiting form of
TIOSSTI pushback is used by nothing genuine userspace in any properly
functional case.   So if that is the case unconstrained TIOSSTI
push-back would only be making application crashes worse.

The reason I want TIOSSTI pushback moved to its own CAP_SYS first is
to find out if anything is in fact using it as part of genuine usage
and allowing anyone caught out to work around it.    I am sorry this
is me most likely using X11 logic break it and see if anyone yells.
If no one complains disappear the feature completely then this closes
this form of exploit for good.

Peter Dolding
