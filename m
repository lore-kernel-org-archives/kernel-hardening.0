MIME-Version: 1.0
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
From: Djalal Harouni <tixxdz@gmail.com>
Date: Wed, 29 Nov 2017 00:53:16 +0100
Message-ID: <CAEiveUdrpH4qQnNX_r1EaRaH8jQwO6HsKGRnE1qY+OdCLnkGcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 12:23 AM, Theodore Ts'o <tytso@mit.edu> wrote:
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
>
> Is the goal here to protect people using distro kernels which build
> the world as modules, including dodgy pieces of kernel code that are
> bug-ridden?
>
> If so, then presumably 90% of the problem you've cited can be done by
> creating a script which takes a look of the modules that are normally
> in use once the machine is in production, and then deleting everything
> else?  Correct?
>
> And yes, this will potentially break some users, but the security
> folks who are advocating for the more aggressive version of this
> change seem to be OK with breaking users, so they can do this without
> making kernel changes.  Good luck getting Red Hat and SuSE to accept
> such a change, though....

The patches does not change default and make it easy for users and we
have request for this, not all world is Red Hat / SuSE , I build
embedded Linux for clients when I manage to have some, and I clearly
would have set this to my clients since most of them won't be able to
afford all the signing and complexity, now how I should allow modules
load/unload replace with newer versions, but restrict some of their
apps from triggering it, "modules_disabled=1" is not practical. I
can't build a perfect version for every usecase,  and they started to
ship apps for IoT, even containers for IoT, yes they do it and they
use the same os for various use cases! so it is not about those, even
embedded vendors have one single shared layer that they use for all
their products.

For distros, the target is also containers and sandboxes, and they are
already interested in it.

P.S. please the cover letter already mentions that this is for Embedded and IoT.

>                                                 - Ted



-- 
tixxdz
