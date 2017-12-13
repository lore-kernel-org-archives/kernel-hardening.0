MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <87r2ryaim5.fsf@concordia.ellerman.id.au>
References: <20171201200819.GA25519@linux.vnet.ibm.com> <1512158945-27269-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <bc07683158334e8f90573bbd77e037a3@AcuMS.aculab.com> <20171204134203.GR7829@linux.vnet.ibm.com>
 <f51c8864617a45d3aabef7106ae7a9f1@AcuMS.aculab.com> <20171204161100.GT7829@linux.vnet.ibm.com>
 <CAHp75VcJKYnW2grD6jViNFU3z6+fJoTmqs+ZP3Xm6YB3C8ZH1Q@mail.gmail.com>
 <CA+55aFwQEd_d40g4mUCSsVRZzrFPUJt74vc6PPpb675hYNXcKw@mail.gmail.com>
 <87wp1sa55h.fsf@concordia.ellerman.id.au> <CA+55aFxHdAX_ztDMUyXihhUv_eftntHecGUUaV3qAtGj_ZbKCg@mail.gmail.com>
 <87r2ryaim5.fsf@concordia.ellerman.id.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Dec 2017 10:21:27 -0800
Message-ID: <CA+55aFxkPYaa6vt-wH_M6kfgMHgOizakfGQe0o10QDPncwiOiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: Long live %pK (was Re: [PATCH tip/core/rcu 02/20] torture:
 Prepare scripting for shift from %p to %pK)
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Laight <David.Laight@aculab.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "dipankar@in.ibm.com" <dipankar@in.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "edumazet@google.com" <edumazet@google.com>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "oleg@redhat.com" <oleg@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 13, 2017 at 4:59 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Right. My email was only about the kptr_restrict = 1 case, but I didn't
> actually make that clear.
>
> But that's also sort of my point, it has multiple modes of operation,
> which is useful.

No it isn't.

It's completely useless. Let me count the ways:

 - it ties a lot of completely unrelated things together in illogical
ways. What if you want vmallocinfo for debuggability, but not
something else?

 - we've had it for most of a decade, and few people use it, and it's
not actually fixed any real security holes. It has only helped on
particular setups, not in general.

> OK, that's the piece I was missing - ie. what to do in the case where
> %px for all users is too permissive but %p is not useful.

Right. THAT IS THE WHOLE POINT OF THE NEW %p BEHAVIOR.

Make people actually _think_ about the things they see, and hopefully
just remove it entirely. Not the total idiocy that was %pK that never
resulted in any actual improvement anywhere.

%pK was the "sprinkle some crack on him, let's get out of here"
approach to security. It's bogus shit. Don't do it.

Seriously. It's been sprinkled around randomly just to make random
people feel like they did something. IT DID NOTHING.

The 'K' literally stands for "krack". Because spelling wasn't the
strong part of the thing either.

> I'm still a bit confused by the above. Because kallsyms which is your
> example of how to do it right, still uses kptr_restrict. I get that it
> also checks kallsyms_for_perf(), but that's only in the
> kptr_restrict = 0 case.

Yeah, it was probably a mistake, but I didn't want to change the old behavior.

> Anyway, I'll do a patch for vmallocinfo to do the CAP_SYSLOG check at
> open time, and use that to decide if it should print 0 or the address.

.. don't use CAP_SYSLOG, at least without thihnking about it.  That
was just another mistake of mine in thinking that "let's keep the old
behavior" is a good idea.

Seriously, what does CAP_SYSLOG have to do with kernel address
debugging? Nothing, really.

I suspect CAP_SYS_ADMIN is a much saner thing to use.

Ask yourself: who really should get access to vmalloc addresses?

                 Linus
