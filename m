MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180331053434.akno723avvcri654@gmail.com>
References: <20180326221554.GA45166@beast> <20180327054748.jx6mzywguuqfkqpv@gmail.com>
 <CAGXu5jK74cVQPigf2Q23E2pjonfzq+MMxhbqTNvzbWFxP4aGig@mail.gmail.com> <20180331053434.akno723avvcri654@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 31 Mar 2018 06:37:37 -0700
Message-ID: <CAGXu5jKrE+oejudtV1SKFgTMd0cEaPv_y=iw16LnGUUX0R8M8Q@mail.gmail.com>
Subject: Re: [PATCH v6] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 30, 2018 at 10:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Mar 26, 2018 at 10:47 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> In the effort to remove all VLAs from the kernel[1], it is desirable to
>> >> build with -Wvla. However, this warning is overly pessimistic, in that
>> >> it is only happy with stack array sizes that are declared as constant
>> >> expressions, and not constant values. One case of this is the evaluation
>> >> of the max() macro which, due to its construction, ends up converting
>> >> constant expression arguments into a constant value result.
>> >>
>> >> All attempts to rewrite this macro with __builtin_constant_p() failed with
>> >> older compilers (e.g. gcc 4.4)[2]. However, Martin Uecker constructed[3] a
>> >> mind-shattering solution that works everywhere. Cthulhu fhtagn!
>> >>
>> >> This patch updates the min()/max() macros to evaluate to a constant
>> >> expression when called on constant expression arguments. This removes
>> >> several false-positive stack VLA warnings from an x86 allmodconfig
>> >> build when -Wvla is added:
>> >
>> > Cool!
>> >
>> > Acked-by: Ingo Molnar <mingo@kernel.org>
>> >
>> > How many warnings are left in an allmodconfig build?
>>
>> For -Wvla? Out of the original 112 files with VLAs, 42 haven't had a
>> patch applied yet. Doing a linux-next allmodconfig build with the
>> max() patch and my latest ecc patch, we've gone from 316 warning
>> instances to 205. More than half of those are in
>> include/crypto/skcipher.h and include/crypto/hash.h.
>
> Great - once the number of warnings is zero, is the plan to enable the warning
> unconditionally?

That's the plan, yes. Like inbox-zero but for VLAs. ;)

-Kees

-- 
Kees Cook
Pixel Security
