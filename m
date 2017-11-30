Message-ID: <1512024677.1374.168.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 30 Nov 2017 01:51:17 -0500
In-Reply-To: <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

> And once you disable it by default, and it becomes purely opt-in, that
> means that nothing will change for most cases. Some embedded people
> that do their own thing (ie Android) might change, but normal
> distributions probably won't.
> 
> Yes, Android may be 99% of the users, and yes, the embedded world in
> general needs to be secure, but I'd still like this to be something
> that helps _everybody_.

Android devices won't get much benefit since they ship a tiny set of
modules chosen for the device. The kernels already get very stripped
down to the bare minimum vs. enabling every feature and driver available
and shipping it all by default on a traditional distribution.

Lots of potential module attack surface also gets eliminated by default
via their SELinux whitelists for /dev, /sys, /proc, debugfs, ioctl
commands, etc. The global seccomp whitelist might be relevant in some
cases too.

Android devices like to build everything into the kernel too, so even if
they weren't using a module this feature wouldn't usually help them. It
would need to work like this existing sysctl:

    net.ipv4.tcp_available_congestion_control = cubic reno lp

i.e. whitelists for functionality offered by the modules, not just
whether they can be loaded.
