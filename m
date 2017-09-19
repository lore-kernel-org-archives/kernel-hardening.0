Date: Tue, 19 Sep 2017 19:16:00 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170919171600.GA31441@openwall.com>
References: <20170524155751.424-1-riel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524155751.424-1-riel@redhat.com>
Subject: Re: [kernel-hardening] [PATCH v2 0/5] stackprotector: ascii armor the stack canary
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, danielmicay@gmail.com, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 24, 2017 at 11:57:46AM -0400, riel@redhat.com wrote:
> Zero out the first byte of the stack canary value on 64 bit systems,
> in order to mitigate unterminated C string overflows.
> 
> The null byte both prevents C string functions from reading the
> canary, and from writing it if the canary value were guessed or
> obtained through some other means.
>     
> Reducing the entropy by 8 bits is acceptable on 64-bit systems,
> which will still have 56 bits of entropy left, but not on 32
> bit systems, so the "ascii armor" canary is only implemented on
> 64-bit systems.
> 
> Inspired by the "ascii armor" code in execshield and Daniel Micay's
> linux-hardened tree.
> 
> Also see https://github.com/thestinger/linux-hardened/

Brad trolls us all lightly with this trivia question:

https://twitter.com/grsecurity/status/905246423591084033

"For #trivia can you describe one scenario where this change actually
helps exploitation using similar C string funcs?"

I suppose the expected answer is:

The change helps exploitation when the overwriting string ends just
before the canary.  Its NUL overwriting the NUL byte in the canary would
go undetected.  Before this change, there would be a 255/256 chance of
detection.

I hope this was considered.  The change might still be a good tradeoff,
or it might not, depending on which scenarios are more likely (leak of
canary value or the string required in an exploit ending at that exact
byte location), and we probably lack such statistics.

I am not proposing to revert the change.  I had actually contemplated
speaking up when this was discussed, but did not for lack of a better
suggestion.  We could put/require a NUL in the middle of the canary, but
with the full canary being only 64-bit at most that would also make some
attacks easier.

So this is JFYI.  No action needed on it, I think.

Alexander
