MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com>
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
 <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
 <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com> <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Nov 2017 16:44:45 -0800
Message-ID: <CAGXu5jLcpfyq0TrXcmkzzO4oFzX0cERVtPFxoAtRyD-HxnAJyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 2:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 29, 2017 at 1:17 PM, Kees Cook <keescook@chromium.org> wrote:
>> 1) Add request_module_cap(required_cap, module_name_prefix, fmt, fmt_args...)
>>
>> 2) Convert known privileged-but-not-CAP_SYS_MODULE request_module()
>> callers to request_module_cap(the_needed_cap, prefix, ...)
>
> Yes. The upside seems to be very limited here, but at least it makes
> the users that use CAP_NET_ADMIN instead of CAP_SYS_MODULE able to
> specify so.

Yeah, agreed; it's limited in scope.

>> 2) Convert known unprivileged callers to use request_module_cap(0, ...)
>
> 0 is CAP_CHOWN, so it would have to be -1.

Oops, yes, think-o.

> And I wouldn't actually want to see that as-is. Not only would I not
> want to see people have that "-1" in random driver subsystems, I'd
> much prefer to have actual helper naming that descibes why something
> is ok

So, if some catch-all is needed, maybe request_module_unpriv(...), but
I think it should be possible to identify SOME kind of defining
privilege to check.

> Because as mentioned, I think there are valid permission reasons that
> are _not_ about capabilities that make you able to load a module.
>
> If you can open a character device node, then "misc_open()" will do
>
>                 request_module("char-major-%d-%d", MISC_MAJOR, minor);
>
> and there is nothing about capabilities in the CAP_SYS_MODULE sense
> about the user. But the user _did_ have the privileges to open that
> character device file.
>
> That's why I suggested something like request_module_dev(): it's not
> at all the same thing as request_module_cap(-1, ...), saying "I don't
> need/have a capability". It's saying something else entirely, it's
> basically saying "I have the right based on device permissions".
>
> And something like request_module_dev() might even have real semantic
> meaning, exactly because it says "this module request comes from
> trying to open a device node".

I just want to make sure I'm visualizing this correctly. Using the
misc_open() example, you're thinking something like:

    request_module_dev(file, "char-major-%d-%d", MISC_MAJOR, minor);

which would then do a verification that file->f_cred matched
current_cred()? (For misc_open(), this is obviously going to always be
okay, but other cases may be further from the fops open handler...)

> Why would that be? If we know we're on a system where /dev is
> auto-populated through udev, then the device nodes should have been
> created by the drivers, not the other way around. So we might even
> have a rule that notices that automatically, and simply disables
> request_module_dev() entirely.

Right, we have both directions -- hotplug module loading ("I saw this
PCI alias, load something! Oh! It needs some fancy crypto too!") and
on-use module loading. It seems like on-use module loading would get
covered by request_module_dev(), and the hotplug case would always be
privileged. Anyway... exploring this with real code is clearly
warranted.

> I suspect that for a lot of our existing request_module() cases, they
> really are pretty trivial. In most cases, it's probably really about
> whether you have the hardware or not.

Right, and those would all be privileged, etc.

> So for the hardware driver cases, either the hardware enumerates
> itself, or it is presumably set up by the system scripts anyway, and
> CAP_SYS_MODULE is all fine. The "open device node" case is one special
> case, though.

Yeah, going through the call sites and asking "where does the
privilege for loading this module derive from?" for each one will help
shape the resulting API changes.

> That mainly leaves the protocol ones we need to look out for, I suspect.

This is where a lot of the exposure really comes from. socket()
triggers a bunch of stuff, but doesn't have an obvious privilege
associated with it... while it already does the name templates, maybe
add request_module_socket() just to explicitly mark it?

>> 3) Add WARN_RATELIMIT for request_module() calls without
>> CAP_SYS_MODULE to shake out other places where request_module_cap() is
>> needed.
>
> Yes.
>
> And this is where I hope that there really aren't actually all that
> many cases that will warn, and that it's hopefully easy to simply just
> look at a handful of reports and say "ok, that case is obviously
> fine".
>
> And I may be wrong.
>
>> 4) Adapt the original patch series to add the per-process flag that
>> can block privilege elevations.
>
> Yes.

Okay, excellent. Hopefully we haven't scared off Djalal, and hopefully
Jessica doesn't think this is all insane. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
