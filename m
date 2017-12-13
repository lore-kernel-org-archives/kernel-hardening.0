From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CA+55aFxHdAX_ztDMUyXihhUv_eftntHecGUUaV3qAtGj_ZbKCg@mail.gmail.com>
References: <20171201200819.GA25519@linux.vnet.ibm.com> <1512158945-27269-2-git-send-email-paulmck@linux.vnet.ibm.com> <bc07683158334e8f90573bbd77e037a3@AcuMS.aculab.com> <20171204134203.GR7829@linux.vnet.ibm.com> <f51c8864617a45d3aabef7106ae7a9f1@AcuMS.aculab.com> <20171204161100.GT7829@linux.vnet.ibm.com> <CAHp75VcJKYnW2grD6jViNFU3z6+fJoTmqs+ZP3Xm6YB3C8ZH1Q@mail.gmail.com> <CA+55aFwQEd_d40g4mUCSsVRZzrFPUJt74vc6PPpb675hYNXcKw@mail.gmail.com> <87wp1sa55h.fsf@concordia.ellerman.id.au> <CA+55aFxHdAX_ztDMUyXihhUv_eftntHecGUUaV3qAtGj_ZbKCg@mail.gmail.com>
Date: Wed, 13 Dec 2017 23:59:46 +1100
Message-ID: <87r2ryaim5.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: Long live %pK (was Re: [PATCH tip/core/rcu 02/20] torture: Prepare scripting for shift from %p to %pK)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Laight <David.Laight@aculab.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "dipankar@in.ibm.com" <dipankar@in.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "edumazet@google.com" <edumazet@google.com>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "oleg@redhat.com" <oleg@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> This is a perfect example of just %pK being complete shit.
>
> %pK doesn't actually do any file permissions right. It looks like it does
> it, but it's just a hot mess of garbage.
>
> And %pK doesn't even work the way you claim it does. Not in the general
> case, and only with a particular value.

Right. My email was only about the kptr_restrict = 1 case, but I didn't
actually make that clear.

But that's also sort of my point, it has multiple modes of operation,
which is useful.

> On Dec 11, 2017 21:26, "Michael Ellerman" <mpe@ellerman.id.au> wrote: I
> >
> >
> > I understand that the CAP_SYSLOG checking that %pK does is kind of
> > gross, but it does work in at least some useful cases like this.
> >
> > What am I missing?
>
>
> Just do the damn thing right, like /proc/kallsyms does these days.
>
> With the proper open time cred check, not the wrong one at io time.

OK, that's the piece I was missing - ie. what to do in the case where
%px for all users is too permissive but %p is not useful.

> Which has the added advantage that it actually does the right thing even
> when you don't have kptr_restrict set, or when you have patches to make it
> print zero even for people with capabilities.
>
> Don't depend on some random flag that has nothing to do with your actual
> example and that has random values for security.

> Just say no to kptr_restrict "logic". Your example basically depends
> entirely on one particular setting, when (a) real distributions have a
> different value and expose those pointers that your claim shouldn't be
> exposed and (b) other people are pushing for values that will hide the
> values that you claim area needed.

I'm still a bit confused by the above. Because kallsyms which is your
example of how to do it right, still uses kptr_restrict. I get that it
also checks kallsyms_for_perf(), but that's only in the
kptr_restrict = 0 case.

Anyway, I'll do a patch for vmallocinfo to do the CAP_SYSLOG check at
open time, and use that to decide if it should print 0 or the address.

I can't think of any other flag or setting to sensibly determine if
vmallocinfo should be visible, so I've just done:

	if (kptr_restrict < 2 && has_capability_noaudit(current, CAP_SYSLOG))
		priv->show_addrs = true;
	else
		priv->show_addrs = false;

So basically visible to root, unless kptr_restrict == 2, otherwise not
visible. 

cheers
