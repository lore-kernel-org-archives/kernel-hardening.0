MIME-Version: 1.0
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com> <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net> <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net> <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net> <6f60afc9-0fed-7f95-a11a-9a2eef33094c@gmail.com>
 <CALCETrXNckT9W288VXx-6inO5qYn-6dUPocKGcBT0GCO3xi3ZQ@mail.gmail.com> <17a007eb-43ea-e4da-b066-0d8c502f5f6e@huawei.com>
In-Reply-To: <17a007eb-43ea-e4da-b066-0d8c502f5f6e@huawei.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Nov 2018 10:35:53 -0800
Message-ID: <CALCETrVaPTbgycjzSB0fLUeGL=j1srUh-cL0qsKn6fw6UQgj7Q@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <nadav.amit@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 13, 2018 at 10:26 AM Igor Stoppa <igor.stoppa@huawei.com> wrote:
>
> On 13/11/2018 19:16, Andy Lutomirski wrote:
>
> > should be
> > entirely abstracted away by an appropriate API, so neither SELinux nor
> > IMA need to be aware that there's an mm_struct involved.
>
> Yes, that is fine. In my proposal I was thinking about tying it to the
> core/thread that performs the actual write.
>
> The high level API could be something like:
>
> wr_memcpy(void *src, void *dst, uint_t size)
>
> >  It's also
> > entirely possible that some architectures won't even use an mm_struct
> > behind the scenes -- x86, for example, could have avoided it if there
> > were a kernel equivalent of PKRU.  Sadly, there isn't.
>
> The mm_struct - or whatever is the means to do the write on that
> architecture - can be kept hidden from the API.
>
> But the reason why I was proposing to have one mm_struct per writer is
> that, iiuc, the secondary mapping is created in the secondary mm_struct
> for each writer using it.
>
> So the updating of IMA measurements would have, theoretically, also
> write access to the SELinux AVC. Which I was trying to avoid.
> And similarly any other write rare updater. Is this correct?

If you call a wr_memcpy() function with the signature you suggested,
then you can overwrite any memory of this type.  Having a different
mm_struct under the hood makes no difference.  As far as I'm
concerned, for *dynamically allocated* rare-writable memory, you might
as well allocate all the paging structures at the same time, so the
mm_struct will always contain the mappings.  If there are serious bugs
in wr_memcpy() that cause it to write to the wrong place, we have
bigger problems.

I can imagine that we'd want a *typed* wr_memcpy()-like API some day,
but that can wait for v2.  And it still doesn't obviously need
multiple mm_structs.

>
> >> 2) Iiuc, the purpose of the 2 pages being remapped is that the target of
> >> the patch might spill across the page boundary, however if I deal with
> >> the modification of generic data, I shouldn't (shouldn't I?) assume that
> >> the data will not span across multiple pages.
> >
> > The reason for the particular architecture of text_poke() is to avoid
> > memory allocation to get it working.  i think that prmem/rare_write
> > should have each rare-writable kernel address map to a unique user
> > address, possibly just by offsetting everything by a constant.  For
> > rare_write, you don't actually need it to work as such until fairly
> > late in boot, since the rare_writable data will just be writable early
> > on.
>
> Yes, that is true. I think it's safe to assume, from an attack pattern,
> that as long as user space is not started, the system can be considered
> ok. Even user-space code run from initrd should be ok, since it can be
> bundled (and signed) as a single binary with the kernel.
>
> Modules loaded from a regular filesystem are a bit more risky, because
> an attack might inject a rogue key in the key-ring and use it to load
> malicious modules.

If a malicious module is loaded, the game is over.

>
> >> If the data spans across multiple pages, in unknown amount, I suppose
> >> that I should not keep interrupts disabled for an unknown time, as it
> >> would hurt preemption.
> >>
> >> What I thought, in my initial patch-set, was to iterate over each page
> >> that must be written to, in a loop, re-enabling interrupts in-between
> >> iterations, to give pending interrupts a chance to be served.
> >>
> >> This would mean that the data being written to would not be consistent,
> >> but it's a problem that would have to be addressed anyways, since it can
> >> be still read by other cores, while the write is ongoing.
> >
> > This probably makes sense, except that enabling and disabling
> > interrupts means you also need to restore the original mm_struct (most
> > likely), which is slow.  I don't think there's a generic way to check
> > whether in interrupt is pending without turning interrupts on.
>
> The only "excuse" I have is that write_rare is opt-in and is "rare".
> Maybe the enabling/disabling of interrupts - and the consequent switch
> of mm_struct - could be somehow tied to the latency configuration?
>
> If preemption is disabled, the expectations on the system latency are
> anyway more relaxed.
>
> But I'm not sure how it would work against I/O.

I think it's entirely reasonable for the API to internally break up
very large memcpys.
