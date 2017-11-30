MIME-Version: 1.0
In-Reply-To: <1512024677.1374.168.camel@gmail.com>
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
 <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
 <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com> <1512024677.1374.168.camel@gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu, 30 Nov 2017 09:50:27 +0100
Message-ID: <CAEiveUdgm_n-TUYGCtw_Zf24TJXrdrsFjcU8_S1M2qQUmHG+KA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Daniel Micay <danielmicay@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 30, 2017 at 7:51 AM, Daniel Micay <danielmicay@gmail.com> wrote:
[...]
> Lots of potential module attack surface also gets eliminated by default
> via their SELinux whitelists for /dev, /sys, /proc, debugfs, ioctl
> commands, etc. The global seccomp whitelist might be relevant in some
> cases too.

In embedded systems we can't maintain a SELinux policy, distro man
power hardly manage. We have abstracted seccomp etc, but the kernel
inherited the difficult multiplex things, plus all other paths that
trigger this.


> Android devices like to build everything into the kernel too, so even if
> they weren't using a module this feature wouldn't usually help them. It
> would need to work like this existing sysctl:
>
>     net.ipv4.tcp_available_congestion_control = cubic reno lp
>
> i.e. whitelists for functionality offered by the modules, not just
> whether they can be loaded.

Yes, but it is hard to maintain a whitelist policy, the code is hardly
maintained... if you include everything you should have an LSM policy
or something like that, and compiling kernels is expert thing.
Otherwise IMHO the kernel should provide default secure behaviour on
how to load or add new functionality to the running one. From a user
perspective, a switch "yes/no" that a privileged entity will
*understand* and assume is what should be there, and the switch or
flag as discussed here is local to processes, the sysctl will be
removed. IMO it should come from userspace point of view, cause as an
example the sysctl:

net.ipv4.tcp_available_congestion_control = cubic reno lp

Is kernel thing, too technical, userspace developers, admins or
privileged entity will not understand what cubic or reno mean. Doing
the same per functionality directly like this seems to much of a
burden compared to the use case. The kernel maybe can do this to
advance the art of the networking stack and for advanced cases, but in
IMHO a sane default behaviour + an abstracted process/sandbox flag
"yes/no" for most others, userspace developers and humans is what
should be provided and we need the kernel to help here.

It seems that Linus and kees agreed on this direction which allows me
to follow up.

Thanks!


-- 
tixxdz
