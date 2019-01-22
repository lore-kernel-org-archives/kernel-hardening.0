From: Julian Stecklina <jsteckli@amazon.de>
Subject: Re: [RFC] x86/speculation: add L1 Terminal Fault / Foreshadow demo
References: <1548076208-6442-1-git-send-email-jsteckli@amazon.de>
	<20190121183618.GP6118@tassilo.jf.intel.com>
	<20190121191541.GB4026@kroah.com>
	<CAGXu5j+h9RKAND8+SJR6P6CQY_YO3ezjsnfuzLGsQbY=O4XCuw@mail.gmail.com>
Date: Tue, 22 Jan 2019 16:34:18 +0200
In-Reply-To: <CAGXu5j+h9RKAND8+SJR6P6CQY_YO3ezjsnfuzLGsQbY=O4XCuw@mail.gmail.com>
	(Kees Cook's message of "Tue, 22 Jan 2019 09:42:13 +1300")
Message-ID: <ciirm8va2gg3rp.fsf@u54ee758033e858cfa736.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Liran Alon <liran.alon@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Tue, Jan 22, 2019 at 8:15 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Mon, Jan 21, 2019 at 10:36:18AM -0800, Andi Kleen wrote:
>> > > +   /* Check the start address: needs to be page-aligned.. */
>> > > +-  if (start & ~PAGE_MASK)
>> > > ++  if (start & ~PAGE_MASK) {
>> > > ++
>> > > ++          /*
>> > > ++           * XXX Hack
>> > > ++           *
>> > > ++           * We re-use this error case to show case a cache load gadget:
>> > > ++           * There is a mispredicted branch, which leads to prefetching
>> > > ++           * the cache with attacker controlled data.
>> > > ++           */
>> > > ++          asm volatile (
>> >
>> > Obviously that can never be added to a standard kernel.
>>
>> No, that's why it is a patch, right?

Yes, this is obviously only for experimenting.

>> People want to test things, it's nice to have a way to easily do
>> this.
>
> What about adding something like it to drivers/misc/lkdtm/ instead?
>
> It's not a "production" module, but it regularly get built for selftest builds.

For people who want to test L1TF hardening patches in the kernel (e.g.
XPFO) it's certainly nice to not have to manually patch the kernel to add
an easy to reach cache load gadget. It's also nice if you quickly want
to test whether a random Intel CPU has this vulnerability.

The cache load gadget as it is right now is mostly to show a reasonably
realistic scenario of speculatively executed code fetching memory into
the L1 cache. I didn't want to make this a completely crafted example
where I just literally execute a prefetch instruction.

But what I could do is add a bit of code in lkdtm that exposes a debugfs
file with this functionality.

Thoughts?

Julian
