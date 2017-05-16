References: <20170505232018.28846-1-matt@nmatt.com>
 <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
 <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
 <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com>
Date: Tue, 16 May 2017 08:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Peter Dolding <oiaohm@gmail.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/16/2017 05:01 AM, Peter Dolding wrote:
>>
>> I could see a case being make for CAP_SYS_TTY_CONFIG. However I still
>> choose to do with CAP_SYS_ADMIN because it is already in use in the
>> TIOCSTI ioctl.
>>
> Matt Brown don't give me existing behaviour.    CAP_SYS_ADMIN is
> overload.   The documentation tells you that you are not to expand it
> and you openly admit you have.
>

This is not true that I'm openly going against what the documentation
instructs. The part of the email chain where I show this got removed
somehow. Again I will refer to the capabilities man page that you
quoted.

 From http://man7.org/linux/man-pages/man7/capabilities.7.html

"Don't choose CAP_SYS_ADMIN if you can possibly avoid it!
...
The only new features that should be associated with CAP_SYS_ADMIN are
ones that closely match existing uses in that silo."

My feature affects the TIOCSTI ioctl. The TIOCSTI ioctl already falls
under CAP_SYS_ADMIN, therefore I actually *am* following the
documentation.

> Does anything of TIOSCTI functionally say that it really should be in
> CAP_SYS_ADMIN.
>
> If functionality is going to cause security for containers maybe it
> should be not in CAP_SYS_ADMIN but in its own capability that can
> enabled on file by file base.
>
>>
>> You might be right that CAP_SYS_ADMIN is overloaded, but my patch
>> barely adds anything to it since TIOCSTI already falls under its
>> control. It seems extreme to say this patch ought to be rejected just
>> because it contains CAP_SYS_ADMIN. If we want to fix the state of Linux
>> capabilities, then I suggest that should be a separate patchset to
>> reorganize them into a more modular set of controls.
>>
> We have end up with CAP_SYS_ADMIN a mess by the of a death by a
> thousand cuts.   Each person to extend CAP_SYS_ADMIN to it current
> mess said the same thing.   My patch barely added anything times that
> by a few thousand and you end up with what we have today.   At some
> point no more has to be said.
>
> There is no point attempting to tidy it up of the rules are not put in
> place so it does not turn into a mess again.
>
> This is not something that is suitable to be done as one large
> patchset.   This is better done in the same kind of method that made
> it.  So every time people want to alter something associated with
> CAP_SYS_ADMIN it has to get assessed and the patch has to be one that
> partly corrects the existing mess.    Do this enough times and we will
> no longer have a mess on CAP_SYS_ADMIN.
>
> https://www.freedesktop.org/software/systemd/man/systemd.exec.html
> Please note the CapabilityBoundingSet=
>
> Your current patch adds no extra controls for me running a service
> under systemd or anything else like it to say I don't want the
> processes having the means to-do this even that they are running with
> CAP_SYS_ADMIN to perform other tasks..
>
> --employ the TIOCSTI ioctl(2) to insert characters into the input
> queue of a terminal other than the caller's controlling terminal;--
> This currently under CAP_SYS_ADMIN is vastly more powerful than the
> one you are attempt to take away with your patch.  This one can send
> messages into other terminals.   This is a vastly more powerful
> version of TIOSCTI.
>
> I fact this usage of TIOCSTI I personally think should require two
> capabilities flags set.   CAP_SYS_ADMIN section left as it is at this
> stage.   With TIOSCTI stuck behind another capability.
>
> If you had added a new capability flag you could set file capabilities
> on any of the old applications depending on the now secured behaviour.
>
> https://github.com/lxc/lxc/commit/e986ea3dfa4a2957f71ae9bfaed406dd6e1ffff6
>
> Also the general user TIOCSTI issue can be handled a different way as
> LXC fix shows.  Where they uses a pty to isolate so meaning in their
> fixed setup user TIOSCTI was not harmful but CAP_SYS_ADMIN TIOSCTI
> still could be.  You patch as not address this problem because you
> shoved everything under CAP_SYS_ADMIN.   But if you add different
> capability to use TIOSCIT that is not CAP_SYS_ADMIN  to allow
> CAP_SYS_ADMiN TIOSCTI functionality to be disabled.
>
> This is what you see more often than not when you dig into this
> patches adding more CAP_SYS_ADMIN.  Adding CAP_SYS_ADMIN is not fixing
> a problem in most cases.   Breaking CAP_SYS_ADMIN functionality up
> should be the goal not expand it.
>
> Basically you have done something documentation has a note to
> developer not to-do.   If you start looking at the problem what you
> doing is not helping.   If people end up using CAP_SYS_ADMIN to access
> TIOSCTI its giving the program a more powerful version of TIOSCTI to
> do more harm with so reduced containment.  Totally anti to what you
> are meant to be doing with capabilities..
>
