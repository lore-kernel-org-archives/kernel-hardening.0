MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171128232320.22zo324g5wvo2lce@thunk.org>
References: <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <CAGXu5j+V8+h6kdbz5Det=wsRKjt6Cm0-_n8soLCU2PZ=AvqpJQ@mail.gmail.com> <20171128232320.22zo324g5wvo2lce@thunk.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 15:29:01 -0800
Message-ID: <CAGXu5j+c8AR+3KdXKO1J180ZYZOVqK=-_MGe20g8h+dgf2RWEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 3:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 28, 2017 at 01:33:40PM -0800, Kees Cook wrote:
>> As I've said before, this isn't a theoretical attack surface. This
>> year alone there have been three known-exploitable flaws exposed by
>> autoloading:
>>
>> The exploit for CVE-2017-2636 uses int n_hdlc = N_HDLC; ioctl(fd,
>> TIOCSETD, &n_hdlc) [1]. This is using the existing "tty-ldisc-"
>> prefix, and is intentionally unprivileged.
>>
>> The exploit for CVE-2017-6074 uses socket(PF_INET6, SOCK_DCCP,
>> IPPROTO_IP) [2]. This is using the existing proto prefix, and is
>> intentionally unprivileged.
>
> So in these two cases, if the kernel was built w/o modules, and HDLC
> and DCCP was built-in, you'd be screwed, then?

Sure, but that's not the common situation.

> Is the goal here to protect people using distro kernels which build
> the world as modules, including dodgy pieces of kernel code that are
> bug-ridden?

The bulk of the risk comes from distro kernels, yes. (Though "bug
ridden" is a strong statement. There are and will be bugs, scattered
across a wide portion of the kernel, it's just that modules tend to
cover most of that attack surface.)

> If so, then presumably 90% of the problem you've cited can be done by
> creating a script which takes a look of the modules that are normally
> in use once the machine is in production, and then deleting everything
> else?  Correct?

This isn't always obvious nor is it easy: a kernel upgrade will
reinstall everything, etc. This is effectively a blacklist, and we
need an easy whitelist approach. And an admin may not want to make it
so hard for themselves to load some special filesystem module that
they have to hunt it down and reinstall it. Or they'll want some
containers to be able to trigger module loading and others not to.
They just want to know their users aren't triggering module loading
that expands the kernel attack surface.

> And yes, this will potentially break some users, but the security
> folks who are advocating for the more aggressive version of this
> change seem to be OK with breaking users, so they can do this without
> making kernel changes.  Good luck getting Red Hat and SuSE to accept
> such a change, though....

We should strive to make the kernel easy to protect. Expecting admins
to jump through these hoops isn't a sensible way forward.

-Kees

-- 
Kees Cook
Pixel Security
