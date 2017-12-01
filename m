Message-ID: <1512110374.28364.33.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 01 Dec 2017 01:39:34 -0500
In-Reply-To: <CAEiveUdgm_n-TUYGCtw_Zf24TJXrdrsFjcU8_S1M2qQUmHG+KA@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
	 <1511803118-2552-6-git-send-email-tixxdz@gmail.com>
	 <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
	 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
	 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
	 <1100603534.56586.1511871419952@ichabod.co-bxl>
	 <20171128193243.4fymnjk7fplqw62x@thunk.org>
	 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
	 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
	 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
	 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
	 <708003731.69563.1511905898471@ichabod.co-bxl>
	 <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
	 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
	 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
	 <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
	 <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
	 <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
	 <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
	 <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com>
	 <1512024677.1374.168.camel@gmail.com>
	 <CAEiveUdgm_n-TUYGCtw_Zf24TJXrdrsFjcU8_S1M2qQUmHG+KA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

It was suggested that the feature would only be adopted in niches like
Android and I pointed out that it's not really relevant to Android.

It's a waste of time to try convincing me that it's useful elsewhere. I
never said or implied that it wasn't.

On Thu, 2017-11-30 at 09:50 +0100, Djalal Harouni wrote:
> On Thu, Nov 30, 2017 at 7:51 AM, Daniel Micay <danielmicay@gmail.com>
> wrote:
> [...]
> > Lots of potential module attack surface also gets eliminated by
> > default
> > via their SELinux whitelists for /dev, /sys, /proc, debugfs, ioctl
> > commands, etc. The global seccomp whitelist might be relevant in
> > some
> > cases too.
> 
> In embedded systems we can't maintain a SELinux policy, distro man
> power hardly manage. We have abstracted seccomp etc, but the kernel
> inherited the difficult multiplex things, plus all other paths that
> trigger this.

It's cheaper to use an existing system like Android Things where device
makers only need to make their apps and perhaps some userspace hardware
drivers for cases not covered by mainline kernel drivers. I don't think
it makes sense for every device vendor to manage an OS and I seriously
doubt that's how the ecosystem is going to end up as it matures.

> > Android devices like to build everything into the kernel too, so
> > even if
> > they weren't using a module this feature wouldn't usually help them.
> > It
> > would need to work like this existing sysctl:
> > 
> >     net.ipv4.tcp_available_congestion_control = cubic reno lp
> > 
> > i.e. whitelists for functionality offered by the modules, not just
> > whether they can be loaded.
> 
> Yes, but it is hard to maintain a whitelist policy, the code is hardly
> maintained... if you include everything you should have an LSM policy
> or something like that, and compiling kernels is expert thing.

I'm not talking about whitelist vs. blacklist, compiling kernels or
anything like that.

> Otherwise IMHO the kernel should provide default secure behaviour on
> how to load or add new functionality to the running one. From a user
> perspective, a switch "yes/no" that a privileged entity will
> *understand* and assume is what should be there, and the switch or
> flag as discussed here is local to processes, the sysctl will be
> removed. IMO it should come from userspace point of view, cause as an
> example the sysctl:
> 
> net.ipv4.tcp_available_congestion_control = cubic reno lp
> 
> Is kernel thing, too technical, userspace developers, admins or
> privileged entity will not understand what cubic or reno mean.

Congestion control algorithms are being used as an example in terms of
the mechanism being used to control which are available to unprivileged
users. The obscurity of congestion control algorithms is irrelevant.

>  Doing
> the same per functionality directly like this seems to much of a
> burden compared to the use case. The kernel maybe can do this to
> advance the art of the networking stack and for advanced cases, but in
> IMHO a sane default behaviour + an abstracted process/sandbox flag
> "yes/no" for most others, userspace developers and humans is what
> should be provided and we need the kernel to help here.

There are cases where unprivileged module auto-loading is relied upon
like network protocols. Having configuration for which protocols can be
used by unprivileged users is superior to limiting only which ones can
be auto-loaded. That's why I bought up the existing congestion control
knob. It works well in terms of having a whitelist of the sane, widely
used cases with exposing anything obscure requiring configuration. They
happen to be implemented as modules too.

Killing off unprivileged module loading other than a few cases like that
makes sense, and then those can provide similar control with similarly
sane defaults.
