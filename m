From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CA+55aFwQEd_d40g4mUCSsVRZzrFPUJt74vc6PPpb675hYNXcKw@mail.gmail.com>
References: <20171201200819.GA25519@linux.vnet.ibm.com> <1512158945-27269-2-git-send-email-paulmck@linux.vnet.ibm.com> <bc07683158334e8f90573bbd77e037a3@AcuMS.aculab.com> <20171204134203.GR7829@linux.vnet.ibm.com> <f51c8864617a45d3aabef7106ae7a9f1@AcuMS.aculab.com> <20171204161100.GT7829@linux.vnet.ibm.com> <CAHp75VcJKYnW2grD6jViNFU3z6+fJoTmqs+ZP3Xm6YB3C8ZH1Q@mail.gmail.com> <CA+55aFwQEd_d40g4mUCSsVRZzrFPUJt74vc6PPpb675hYNXcKw@mail.gmail.com>
Date: Tue, 12 Dec 2017 16:26:02 +1100
Message-ID: <87wp1sa55h.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Long live %pK (was Re: [PATCH tip/core/rcu 02/20] torture: Prepare scripting for shift from %p to %pK)
To: Linus Torvalds <torvalds@linux-foundation.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Laight <David.Laight@aculab.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "dipankar@in.ibm.com" <dipankar@in.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "edumazet@google.com" <edumazet@google.com>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "oleg@redhat.com" <oleg@redhat.com>, kernel-hardening@lists.openwall.comkernel-hardening@lists.openwall.com, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Sun, Dec 10, 2017 at 4:52 AM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>>>
>>>> Perhaps it should have printed a fixed, non-zero value for non-zero
>>>> pointers.
>>>
>>> I must leave this to the people who have a dog in that contest.  ;-)
>>
>> Since there is an ongoing discussion with security people near to %pK
>> and alike, I added Kees and Linus to Cc list.
>>
>> The proposed change can be done easily, though I have no knowledge
>> about possible implications.
>
> I'd rather make %pK act more like %p than have gratuitous differences.

But %pK has one crucial feature that %p does not, which is that %pK can
actually show the real value.

> I also think %pK is kind of pointless in general. It has not been a
> big success, and the whole "root or not" is kind of nasty anyway. Root
> in a container? Things like that.

At least with docker, root in a container doesn't get CAP_SYSLOG by
default, and so %pK works perfectly.

That is, root in the container can't see %pK things, but root on the
host can.

So consider /proc/vmallocinfo:

> So I think that if people worry  about leaking pointers, they should
> primarily go for:
>
>  - just use %p and now get the hashed value

Hopefully we can agree that the hashed value is not very useful when
you're looking at vmallocinfo. You're almost always trying to determine
if a value from an oops or elsewhere is contained within one of the
mappings, and for that you need to know the address ranges.

>  - if the hashed value is pointless, ask yourself whether the pointer
> itself is important. Maybe it should be removed?

A real bug we hit yesterday, a bad page fault in a *guest* that appears
to be trying to dereference a vmalloc address from the *host* (obviously
that should not happen). First step in debugging is to check if the
address lies within a valid mapping in /proc/vmallocinfo on the host. To
do that you need the pointers.

>  - as a last option, if you really  think the true pointer value is
> important, why is root so special, and maybe you should use %px and
> make sure you have proper sensible permissions.

/proc/vmallocinfo is already 0400.

But we definitely do not want to use %px for vmallocinfo, because that
would expose the values to root in containers.

> ..and %pK just isn't really the answer in any of those cases.

So in this case it seems %pK is a better answer than %p or %px.

I understand that the CAP_SYSLOG checking that %pK does is kind of
gross, but it does work in at least some useful cases like this.

What am I missing?

cheers
