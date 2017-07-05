MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170629175647.pufnks75fqy627jv@smitten>
References: <20170623015010.GA137429@beast> <CAGXu5jJEi_CS-CB=-4369TFRyeN4oQdmGS+HV-zoi4rSPpq3Jw@mail.gmail.com>
 <alpine.DEB.2.20.1706291204460.17478@east.gentwo.org> <CAGXu5jLLFKnboaLJKGcGT-Ra80ZzAf3jZ=zex6vd8uDQamBJxg@mail.gmail.com>
 <1498758853.6130.2.camel@redhat.com> <20170629175647.pufnks75fqy627jv@smitten>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 5 Jul 2017 16:30:56 -0700
Message-ID: <CAGXu5j+6Bq1YW9EPWGxjbz4bWWf7PvoKi5pbp6sNz8fvkq9ncw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v2] mm: Add SLUB free list pointer obfuscation
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>, Tycho Andersen <tycho@docker.com>, Laura Abbott <labbott@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 29, 2017 at 10:56 AM, Tycho Andersen <tycho@docker.com> wrote:
> On Thu, Jun 29, 2017 at 01:54:13PM -0400, Rik van Riel wrote:
>> On Thu, 2017-06-29 at 10:47 -0700, Kees Cook wrote:
>> > On Thu, Jun 29, 2017 at 10:05 AM, Christoph Lameter <cl@linux.com>
>> > wrote:
>> > > On Sun, 25 Jun 2017, Kees Cook wrote:
>> > >
>> > > > The difference gets lost in the noise, but if the above is
>> > > > sensible,
>> > > > it's 0.07% slower. ;)
>> > >
>> > > Hmmm... These differences add up. Also in a repetative benchmark
>> > > like that
>> > > you do not see the impact that the additional cacheline use in the
>> > > cpu
>> > > cache has on larger workloads. Those may be pushed over the edge of
>> > > l1 or
>> > > l2 capacity at some point which then causes drastic regressions.
>> >
>> > Even if that is true, it may be worth it to some people to have the
>> > protection. Given that is significantly hampers a large class of heap
>> > overflow attacks[1], I think it's an important change to have. I'm
>> > not
>> > suggesting this be on by default, it's cleanly behind
>> > CONFIG-controlled macros, and is very limited in scope. If you can
>> > Ack
>> > it we can let system builders decide if they want to risk a possible
>> > performance hit. I'm pretty sure most distros would like to have this
>> > protection.
>>
>> I could certainly see it being useful for all kinds of portable
>> and network-connected systems where security is simply much
>> more important than performance.
>
> Indeed, I believe we would enable this in our kernels.

Andrew and Christoph,

What do you think about carrying this for -mm, since people are
interested in it and it's a very narrow change behind a config (with a
large impact on reducing the expoitability of freelist pointer
overwrites)?

-Kees

-- 
Kees Cook
Pixel Security
