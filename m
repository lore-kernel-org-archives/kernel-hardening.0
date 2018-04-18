Date: Wed, 18 Apr 2018 12:50:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fork: Unconditionally clear stack on fork
Message-Id: <20180418125008.203632feeaf0cac4e51c5b79@linux-foundation.org>
In-Reply-To: <CAGXu5j+PmPUg9-gx3769X+kjXJo+markuPA3FwredM7jU8CdXg@mail.gmail.com>
References: <20180221021659.GA37073@beast>
	<20180221102933.GD2231@dhcp22.suse.cz>
	<20180221125914.dc95830eada5fb958c13e36b@linux-foundation.org>
	<CAGXu5j+dc=y+1M=unyvEvCo+QrX3MCW5Hm=2Z+q0a6iC3pgN6g@mail.gmail.com>
	<CAGXu5j+PmPUg9-gx3769X+kjXJo+markuPA3FwredM7jU8CdXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Rasmus Villemoes <rasmus.villemoes@prevas.dk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 18 Apr 2018 09:38:07 -0700 Kees Cook <keescook@chromium.org> wrote:

> >> So some quite careful quantitative testing is needed here, methinks.
> >
> > Well, I did some more with perf and cycle counts on running 100,000
> > execs of /bin/true.
> >
> > before:
> > Cycles: 218858861551 218853036130 214727610969 227656844122 224980542841
> > Mean:  221015379122.60
> > Std Dev: 4662486552.47
> >
> > after:
> > Cycles: 213868945060 213119275204 211820169456 224426673259 225489986348
> > Mean:  217745009865.40
> > Std Dev: 5935559279.99
> >
> > It continues to look like it's faster, though the deviation is rather
> > wide, but I'm not sure what I could do that would be less noisy. I'm
> > open to ideas!
> 
> Friendly ping. Andrew, can you add this to -mm?

I did so on Feb 21 but didn't merge it up because I'd told myself that
careful perf testing is needed.  I guess we've sufficiently ticked that
box.  Kind of.  Maybe.

Oh well, it's easy enough to revert.  I'll add it to the next
batch-for-Linus.
