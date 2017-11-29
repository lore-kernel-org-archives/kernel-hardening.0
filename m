From: Geo Kozey <geokozey@mailfence.com>
Message-ID: <481583665.87188.1511966817802@ichabod.co-bxl>
In-Reply-To: <20171128234920.awfwicihuudw5ogx@thunk.org>
References: <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com> <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org> <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com> <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com> <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com> <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com> <CAGXu5j+V8+h6kdbz5Det=wsRKjt6Cm0-_n8soLCU2PZ=AvqpJQ@mail.gmail.com> <20171128232320.22zo324g5wvo2lce@thunk.org> <CAGXu5j+c8AR+3KdXKO1J180ZYZOVqK=-_MGe20g8h+dgf2RWEQ@mail.gmail.com> <20171128234920.awfwicihuudw5ogx@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Nov 2017 15:46:57 +0100 (CET)
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Theodore Ts'o <tytso@mit.edu>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

> From: Theodore Ts'o <tytso@mit.edu>
> Sent: Wed Nov 29 00:49:20 CET 2017
> Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to load 'netdev-%s' modules
> 
> OK, but if the goal is to protect users who are running distro
> kernels, then a kernel config that breaks some percentage of users is
> ****highly**** unlikely to be enabled by Red Hat and SuSE, right?  And
> many of these users either can't (from a skills perspective) or won't
> (because they lose all support from the enterprise distro's help desk)
> recompile their kernel to enable an "might break 3% of all users ---
> oh, well" config option.
> 
> Which argues for being extremely conservative about making something
> that has an extremely low probability of breaking users, and it points
> out why Geo Kozey's "who cares about breaking users; security is
> IMPORTANT" argument is so wrong-headed.
> ----------------------------------------

My argument was the opposite - don't break anything by default. Nobody here wanted to break any users. Some of them may choose stricter option because it actually doesn't break anything relevant for them. That's all. It's the same as perf_event_paranoid, kptr_restrict, yama.ptrace_scope sysctls are working currently.

We're talking about runtime, not compile time option. I doubt RH or SUSE prevent users from changing anything at runtime.


G. K.
