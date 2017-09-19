MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170919171600.GA31441@openwall.com>
References: <20170524155751.424-1-riel@redhat.com> <20170919171600.GA31441@openwall.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 19 Sep 2017 13:22:52 -0700
Message-ID: <CAGXu5jJqhhMjOVHDFnDO9oETEf-qsScR3f_NXJGgQg9wDy1ARQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v2 0/5] stackprotector: ascii armor the
 stack canary
To: Solar Designer <solar@openwall.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, Ted Ts'o <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-sh <linux-sh@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 19, 2017 at 10:16 AM, Solar Designer <solar@openwall.com> wrote:
> On Wed, May 24, 2017 at 11:57:46AM -0400, riel@redhat.com wrote:
>> Zero out the first byte of the stack canary value on 64 bit systems,
>> in order to mitigate unterminated C string overflows.
>>
>> The null byte both prevents C string functions from reading the
>> canary, and from writing it if the canary value were guessed or
>> obtained through some other means.
>>
>> Reducing the entropy by 8 bits is acceptable on 64-bit systems,
>> which will still have 56 bits of entropy left, but not on 32
>> bit systems, so the "ascii armor" canary is only implemented on
>> 64-bit systems.
>>
>> Inspired by the "ascii armor" code in execshield and Daniel Micay's
>> linux-hardened tree.
>>
>> Also see https://github.com/thestinger/linux-hardened/
>
> Brad trolls us all lightly with this trivia question:
>
> https://twitter.com/grsecurity/status/905246423591084033
>
> "For #trivia can you describe one scenario where this change actually
> helps exploitation using similar C string funcs?"
>
> I suppose the expected answer is:
>
> The change helps exploitation when the overwriting string ends just
> before the canary.  Its NUL overwriting the NUL byte in the canary would
> go undetected.  Before this change, there would be a 255/256 chance of
> detection.
>
> I hope this was considered.  The change might still be a good tradeoff,
> or it might not, depending on which scenarios are more likely (leak of
> canary value or the string required in an exploit ending at that exact
> byte location), and we probably lack such statistics.
>
> I am not proposing to revert the change.  I had actually contemplated
> speaking up when this was discussed, but did not for lack of a better
> suggestion.  We could put/require a NUL in the middle of the canary, but
> with the full canary being only 64-bit at most that would also make some
> attacks easier.
>
> So this is JFYI.  No action needed on it, I think.

Agreed. And prior to this:
https://git.kernel.org/linus/5ea30e4e58040cfd6434c2f33dc3ea76e2c15b05
the same kernels had 4 NULL bytes in a row. ;) So it's all an improvement, IMO.

-Kees

-- 
Kees Cook
Pixel Security
