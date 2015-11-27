Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <565876F3.21515.18F8DF8F@pageexec.freemail.hu>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <5656F7A2.738.131F89C0@pageexec.freemail.hu> <20151127080554.GB24991@gmail.com>
 <565876F3.21515.18F8DF8F@pageexec.freemail.hu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Nov 2015 08:30:44 -0800
Message-ID: <CALCETrUMKXH1jWKGKAnzzzOh9_vcyTamHg9C3ywDk5H8n3mZXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: PaX Team <pageexec@freemail.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 27, 2015 at 7:29 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 27 Nov 2015 at 9:05, Ingo Molnar wrote:
>
>> * PaX Team <pageexec@freemail.hu> wrote:
>>
>> > On 26 Nov 2015 at 11:42, Ingo Molnar wrote:
>> >
>> > > * PaX Team <pageexec@freemail.hu> wrote:
>> > that's actually not the typical case in my experience, but rather these two:
>> >
>> > 1. initial mistake: someone didn't actually check whether the given object can
>> >    be __read_only
>> >
>> > 2. code evolution: an object that was once written by __init code only (and
>> >    thus proactively subjected to __read_only) gets modified by non-init code
>> >    due to later changes
>> >
>> > what you described above is a third case where there's a latent bug to begin
>> > (unintended write) with that __read_only merely exposes but doesn't create
>> > itself, unlike the two cases above (intended writes getting caught by wrong use
>> > of __read_only).
>>
>> You are right, I concede this part of the argument - what you describe is probably
>> the most typical way to get ro-faults.
>>
>> I do maintain the (sub-)argument that oopsing or relying on tooling help years
>> down the line is vastly inferior to fixing up the problem and generating a
>> one-time stack dump so that kernel developers have a chance to fix the bug. The
>> sooner we detect and dump such information the more likely it is that such bugs
>> don't get into end user kernel versions.
>
> i don't see the compile time vs. runtime detection as 'competing' approaches,
> both have their own role. in general, i think it's safe to say that compile
> time problem detection is preferred to the runtime one since it subjects less
> users to the side effects of the bug. runtime detection is needed to augment
> (even complete) the coverage that compile time detection may not be able to
> provide.
>
> that said, for __read_only related problems the compiler can actually do a
> pretty good job, basically it could detect most of them except special cases
> where the 'bad' write is somehow hidden from it. the only examples i recall
> are like the one that Mathias already mentioned where the 'bad' write was
> done from asm code or out-of-kernel code (think UEFI runtime services) that
> is obviously not visible to the compiler (the resume/mmu_cr4_features problem
> also happens to be an example where runtime detection did not help due to the
> circumstances).
>
> so let me summarize how i expect the runtime detection part to work:
>
> 1. in normal use any write attempt to read-only kernel data should only
>    be reported as usual (the oops info already has rip/cr2/backtrace),
>    but no smart recovery attempts should be made since they may end up
>    actually helping a real exploit attempt.
>
> 2. if necessary for debugging purposes (i.e., when the above reporting
>    mechanism didn't produce the necessary logs and the problem is
>    reproducible and wasn't an attack), a kernel command line option can
>    be used to make an attempt at smart recovery instead of oopsing (but
>    the same information would still be reported of course).
>
>    for this smart recovery we differ(ed?) in opinion, i say that allowing
>    the write in this case (vs. ignoring it) is the least likely to introduce
>    a logic bug (and its cascading effects) since the expected problem is
>    to be case #1 or #2 above (i.e., the write is intended but prevented
>    by __read_only).
>

So maybe we should think about doing this recovery as part of oops
processing.  That is, we oops as usual, but rather than killing the
task or spinning, we allow the post-oops code to try to recover (if
enabled).  That recovery step decodes the instruction and takes some
action.  In this example, if it's a write to ro-after-init memory,
then maybe we un-write-protect it and resume.

I agree with Linus' old sentiment as least insofar as trying to decode
things pre-OOPS is a bad idea: we don't want that decoding to
interfere with our primary goal, which is printing the OOPS.

I would argue that, if this is okay, we do exactly the same thing for
failed msr access.  We still oops, but we try to march on.

We could consider a default setting in which we "recover" from oops
until init starts and then we revert to old behavior (oopses kill the
task).

--Andy
