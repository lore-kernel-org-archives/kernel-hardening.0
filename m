Message-ID: <1505855453.17261.165.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 19 Sep 2017 17:10:53 -0400
In-Reply-To: <20170919171600.GA31441@openwall.com>
References: <20170524155751.424-1-riel@redhat.com>
	 <20170919171600.GA31441@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v2 0/5] stackprotector: ascii armor
 the stack canary
To: Solar Designer <solar@openwall.com>, riel@redhat.com
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> Brad trolls us all lightly with this trivia question:
> 
> https://twitter.com/grsecurity/status/905246423591084033

I'll respond to your proposed scenario rather than guessing at what is
being suggested there and if it's actually the same thing as what you've
brought up.

They've stated many times that stack canaries are near useless and
enabling PaX UDEREF on i386 actually disabled stack canaries and
presumably still does after the last public patches:

+	select HAVE_CC_STACKPROTECTOR		if X86_64 || !PAX_MEMORY_UDEREF

Making the kernel more vulnerable to remote stack overflow exploits like
this month's overhyped Bluetooth bug to improve security against local
exploits seems like much more of a compromise. Not that i386 has any
real relevance anymore, but I think that's some interesting context...

It's not like upstream has a monopoly on needing to make hard choices
for security features, I don't see this as one of those hard choices
like whether sacrificing availability for SIZE_OVERFLOW makes sense.

> "For #trivia can you describe one scenario where this change actually
> helps exploitation using similar C string funcs?"
> 
> I suppose the expected answer is:
> 
> The change helps exploitation when the overwriting string ends just
> before the canary.  Its NUL overwriting the NUL byte in the canary
> would
> go undetected.  Before this change, there would be a 255/256 chance of
> detection.
>
> I hope this was considered.  The change might still be a good
> tradeoff,
> or it might not, depending on which scenarios are more likely (leak of
> canary value or the string required in an exploit ending at that exact
> byte location), and we probably lack such statistics.

It was considered that guaranteeing some forms of string overflows are
contained within the frame can have a negative impact but I don't think
it's significant.

There would need to be something worth overwriting between the source of
the overflow and the canary. Since SSP reorders local variables within
the stack frame based on risk of overflow, the targets would be locals
that Clang/GCC considers to have a higher risk of overflow. An array can
only have other arrays between it and the canary and there's ordering by
size (small vs. large at least) within the array section. If there was a
zero byte in any of that other data between the source of the overflow
and the canary, this wouldn't make a difference anyway.

Since the canary is only checked on return, it's also only relevant if
control flow still makes it to the function epilogue and it still
matters after the attacker has accomplished their goal.

The chance of there being a zero as a leading byte is already 1/256, but
there could also be a NUL elsewhere in the canary compromising a subset
of the entropy for this kind of scenario too so it's a tiny bit higher
than a 1/256 chance already. Not much resistance to brute force if it
really does ever end up mattering, unless canaries with NUL in leading
positions were actually *rejected*...

There's a more substantial compromise between zero and non-zero poison
on free but for production use. This was part of a set of changes where
CopperheadOS switched from non-zero fill -> zero fill on free for the
kernel and userspace and added a leading zero byte on 64-bit for heap
and stack canaries in the production builds while keeping around the old
way of doing things for some forms of debug builds. Non-zero fill on
free ended up causing too much harm by turning benign bugs into bugs
that might have been exploitable even beyond DoS in some cases tied to
non-NUL-terminated strings where non-zero poisoning got rid of zeroes
that were otherwise all over the heap containing them or when it broke
code wrongly depending on uninitialized data being zero in practice. I
think there's more of an argument to be had about poison-on-free as a
mitigation. This leading zero byte? Not so much, beyond perhaps wanting
the option to turn it off for bug finding... but there are better tools
for that now.

> I am not proposing to revert the change.  I had actually contemplated
> speaking up when this was discussed, but did not for lack of a better
> suggestion.  We could put/require a NUL in the middle of the canary,
> but
> with the full canary being only 64-bit at most that would also make
> some
> attacks easier.
> 
> So this is JFYI.  No action needed on it, I think.

It might make sense to put it in the middle, but a scenario where it
matters seems unlikely and as you mention it would make it weaker it
some other cases. I think it's already the best choice right now.

I'd choose XOR canaries over a leading zero byte if it could only be one
or the other, but I'm not really convinced that there's any significant
loss compared to the normal canaries.
