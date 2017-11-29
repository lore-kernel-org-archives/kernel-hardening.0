MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
 <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
 <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
 <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com> <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Nov 2017 14:14:15 -0800
Message-ID: <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 1:17 PM, Kees Cook <keescook@chromium.org> wrote:
>
> So, what we have now is that the permission verification already
> happens at and around the existing request_module() calls.

Usually, yes.

I liked the "request_module_cap()" interface partly because that made
the net/core/dev_ioctl.c ones more explicit, and maybe it could be
convenient if we make other places do similar things.

I was hoping some other users could be converted, but grepping around,
there's no obvious cases. There is tcp_cong.c and tcp_ulp.c, but they
want some extra locking in between the checking..

> It still sounds like you'd like to see an explicit change, similar to
> the proposed request_module_cap(), that identifies the privilege
> expectations on a per-call-site basis. How about this plan:

Yes.

I'd be perfectly happy to have a long-range plan where the existing
"request_module()" ends up requiring more capabilities.

I just don't think it's a good first step, exactly because *if* it's a
first step, it basically has to be disabled by default.

And once you disable it by default, and it becomes purely opt-in, that
means that nothing will change for most cases. Some embedded people
that do their own thing (ie Android) might change, but normal
distributions probably won't.

Yes, Android may be 99% of the users, and yes, the embedded world in
general needs to be secure, but I'd still like this to be something
that helps _everybody_.

So:

> 1) Add request_module_cap(required_cap, module_name_prefix, fmt, fmt_args...)
>
> 2) Convert known privileged-but-not-CAP_SYS_MODULE request_module()
> callers to request_module_cap(the_needed_cap, prefix, ...)

Yes. The upside seems to be very limited here, but at least it makes
the users that use CAP_NET_ADMIN instead of CAP_SYS_MODULE able to
specify so.

> 2) Convert known unprivileged callers to use request_module_cap(0, ...)

0 is CAP_CHOWN, so it would have to be -1.

And I wouldn't actually want to see that as-is. Not only would I not
want to see people have that "-1" in random driver subsystems, I'd
much prefer to have actual helper naming that descibes why something
is ok

Because as mentioned, I think there are valid permission reasons that
are _not_ about capabilities that make you able to load a module.

If you can open a character device node, then "misc_open()" will do

                request_module("char-major-%d-%d", MISC_MAJOR, minor);

and there is nothing about capabilities in the CAP_SYS_MODULE sense
about the user. But the user _did_ have the privileges to open that
character device file.

That's why I suggested something like request_module_dev(): it's not
at all the same thing as request_module_cap(-1, ...), saying "I don't
need/have a capability". It's saying something else entirely, it's
basically saying "I have the right based on device permissions".

And something like request_module_dev() might even have real semantic
meaning, exactly because it says "this module request comes from
trying to open a device node".

Why would that be? If we know we're on a system where /dev is
auto-populated through udev, then the device nodes should have been
created by the drivers, not the other way around. So we might even
have a rule that notices that automatically, and simply disables
request_module_dev() entirely.

Anyway, I'm not saying that is necessarily something we should do, but
I do suspect that we could adapt to modern systems without having to
have tons of magic settings, and try to be as strict as possible
without breaking them.

Because I dislike "system tuning" in general. I hate knobs that do
kernel performance tuning - we try very hard to just DTRT wrt sizing
hashes etc instead of expecting the system admin to set flags.

And I think we can try to avoid some system tuning in this area too.

I suspect that for a lot of our existing request_module() cases, they
really are pretty trivial. In most cases, it's probably really about
whether you have the hardware or not.

So for the hardware driver cases, either the hardware enumerates
itself, or it is presumably set up by the system scripts anyway, and
CAP_SYS_MODULE is all fine. The "open device node" case is one special
case, though.

That mainly leaves the protocol ones we need to look out for, I suspect.

> 3) Add WARN_RATELIMIT for request_module() calls without
> CAP_SYS_MODULE to shake out other places where request_module_cap() is
> needed.

Yes.

And this is where I hope that there really aren't actually all that
many cases that will warn, and that it's hopefully easy to simply just
look at a handful of reports and say "ok, that case is obviously
fine".

And I may be wrong.

> 4) Adapt the original patch series to add the per-process flag that
> can block privilege elevations.

Yes.

            Linus
