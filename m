MIME-Version: 1.0
In-Reply-To: <20170516154818.GA762@mail.hallyn.com>
References: <20170505232018.28846-1-matt@nmatt.com> <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com> <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com> <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com> <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170516154818.GA762@mail.hallyn.com>
From: Peter Dolding <oiaohm@gmail.com>
Date: Wed, 17 May 2017 08:05:17 +1000
Message-ID: <CANA3KFWAbvCwM+EWLpUxDjS+OamW5hWJ136APfzcKYouhUSsFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <keescook@chromium.org>, Matt Brown <matt@nmatt.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 17, 2017 at 1:48 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Kees Cook (keescook@chromium.org):
>> On Tue, May 16, 2017 at 5:22 AM, Matt Brown <matt@nmatt.com> wrote:
>> > On 05/16/2017 05:01 AM, Peter Dolding wrote:
>> >>>
>> >>>
>> >>> I could see a case being make for CAP_SYS_TTY_CONFIG. However I still
>> >>> choose to do with CAP_SYS_ADMIN because it is already in use in the
>> >>> TIOCSTI ioctl.
>> >>>
>> >> Matt Brown don't give me existing behaviour.    CAP_SYS_ADMIN is
>> >> overload.   The documentation tells you that you are not to expand it
>> >> and you openly admit you have.
>> >>
>> >
>> > This is not true that I'm openly going against what the documentation
>> > instructs. The part of the email chain where I show this got removed
>> > somehow. Again I will refer to the capabilities man page that you
>> > quoted.
>> >
>> > From http://man7.org/linux/man-pages/man7/capabilities.7.html
>> >
>> > "Don't choose CAP_SYS_ADMIN if you can possibly avoid it!
>> > ...
>> > The only new features that should be associated with CAP_SYS_ADMIN are
>> > ones that closely match existing uses in that silo."
>> >
>> > My feature affects the TIOCSTI ioctl. The TIOCSTI ioctl already falls
>> > under CAP_SYS_ADMIN, therefore I actually *am* following the
>> > documentation.
>>
>> CAP_SYS_ADMIN is the right choice here, I agree with Matt: it is
>> already in use for TIOCSTI. We can't trivially add new capabilities
>> flags (see the various giant threads debating this, the most recently
>> that I remember from the kernel lock-down series related to Secure
>> Boot).
>
> Consideer that if we use CAP_SYS_TTY_CONFIG now, then any applications
> which are currently being given CAP_SYS_ADMIN would need to be updated
> with a second capability.  Not acceptable.  Even when we split up
> CAP_SYSLOG, we took care to avoid that (by having the original capability
> also suffice, so either capability worked).
>
There is another option create a security bit.

That could be called SECBIT_CONTAINER.   This turns off functionally
like TIOCSTI that can be used to it break out with.

This case the mainlined code the TIOCSTI currently in CAP_SYS_ADMIN is
a container breaker its designed to allow reaching cross users and
TTYs.   SECBIT is a inverted capability so when it enabled it disables
something and once enabled it cannot be disabled.   So the lxc
addressed to the user TIOCSTI causing a breakout does not work against
the CAP_SYS_ADMIN one.   If there was a security bit that disabled
TIOCSTI completely that prevents all the escape paths by TIOCSTI.

There would also be room for a SECBIT_NO_OBSOLETE what is quite simple
make using obsolete functions application fatal.   Now with CAP_SYSLOG
if SECBIT_NO_OBSOLETE programs using the old capability could find the
feature removed.   So over time we can systematically remove the multi
entry path we have now as userspace updates and stops requiring the
second path.

There is more than 1 way to skin this cat.   There is no need to add
more to CAP_SYS_ADMIN and it particular bad when you consider having
to obey the Linux Rule of user-space compatibly would result in having
apply CAP_SYS_ADMIN to existing applications with Matts patch.

Peter

.
