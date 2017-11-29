MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171128234920.awfwicihuudw5ogx@thunk.org>
References: <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <CAGXu5j+V8+h6kdbz5Det=wsRKjt6Cm0-_n8soLCU2PZ=AvqpJQ@mail.gmail.com>
 <20171128232320.22zo324g5wvo2lce@thunk.org> <CAGXu5j+c8AR+3KdXKO1J180ZYZOVqK=-_MGe20g8h+dgf2RWEQ@mail.gmail.com>
 <20171128234920.awfwicihuudw5ogx@thunk.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 16:18:59 -0800
Message-ID: <CAGXu5j+kXxkctzH79YxOu=45xgamV-5qyR2zL7OiC4POL6EcyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 3:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> OK, but if the goal is to protect users who are running distro
> kernels, then a kernel config that breaks some percentage of users is
> ****highly**** unlikely to be enabled by Red Hat and SuSE, right?  And
> many of these users either can't (from a skills perspective) or won't
> (because they lose all support from the enterprise distro's help desk)
> recompile their kernel to enable an "might break 3% of all users ---
> oh, well" config option.

There's a spectrum across "insane not to be done everywhere"
(STRICT_KERNEL_RWX), "this is a good idea for nearly all Linux
systems" (link restrictions), "this can break some common use-cases,
but protects systems without that use-case" (user-namespace
disabling), "this breaks most systems, but specialized deployments
really need it" (modules_disabled).

There's also a difference between immutable CONFIG options that cannot
be disabled at runtime, those that can, global sysctls, per-namespace
controls, etc etc. The kernel is all about providing admins with knobs
to tweak their performance and security. Suddenly being told that we
can't create optional improvements is very odd.

Now, being told "make it easier to audit all the module loading we're
already doing so we can further reduce needless exposures for everyone
even without this feature enabled", THAT makes sense. My point there
is that we've already done those kinds of things; see commits like:

  7f78e0351394 ("fs: Limit sys_mount to only request filesystem modules.")
  5d26a105b5a7 ("crypto: prefix module autoloading with "crypto-"")
  4943ba16bbc2 ("crypto: include crypto- module prefix in template")

> Which argues for being extremely conservative about making something
> that has an extremely low probability of breaking users, and it points
> out why Geo Kozey's "who cares about breaking users; security is
> IMPORTANT" argument is so wrong-headed.

I don't want to break users either. I want to provide meaningful ways
for admins to reduce their kernel attack surface. Djalal and I aren't
advocating for on-by-default removal of module auto-loading (that
would have been a very small patch!). The idea was to provide a
dynamic control over it, and make that available to distros. As shown
in the patch series, it would be immediately put to use with systemd
for process-tree isolation and for container restriction.

> If the goal is to protect distro kernels, but a sloppy approach
> guarantees that distro kernels will never enable it, is it really
> worth it?

I don't think this is sloppy and of course distros would see use,
since systemd would be using it.

> P.S.  This is where it might be useful to get some input from the Red
> Hat and SuSE support teams.  How many angry user calls to their help
> desk are they willing to field before they'll just turn off the kernel
> config option for their kernels?

This isn't about giant-hammer CONFIGs -- this is like more like
PR_SET_DUMPABLE or seccomp.

-Kees

-- 
Kees Cook
Pixel Security
