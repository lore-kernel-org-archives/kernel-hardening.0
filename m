MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jK0t0Xfj1oTUg51USEaJ7je+KMNoE0irfYNon2aAmhg7g@mail.gmail.com>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
 <20170720091106.kigtr6zy7pjgk2s6@gmail.com> <CAGXu5jK0t0Xfj1oTUg51USEaJ7je+KMNoE0irfYNon2aAmhg7g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 20 Jul 2017 15:53:25 -0700
Message-ID: <CAGXu5jKM_gThfVoTxPE8vX-9GhBMd+ZYbwky5jUKJNevYxd50Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v6 0/2] x86: Implement fast refcount overflow protection
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 20, 2017 at 10:15 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 20, 2017 at 2:11 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> Could you please also create a tabulated quick-comparison of the three variants,
>> of all key properties, about behavior, feature and tradeoff differences?
>>
>> Something like:
>>
>>                                 !ARCH_HAS_REFCOUNT      ARCH_HAS_REFCOUNT=y     REFCOUNT_FULL=y
>>
>> avg fast path instructions:     5                       3                       10
>> behavior on overflow:           unsafe, silent          safe,   verbose         safe,   verbose
>> behavior on underflow:          unsafe, silent          unsafe, verbose         unsafe, verbose
>> ...
>>
>> etc. - note that this table is just a quick mockup with wild guesses. (Please add
>> more comparisons of other aspects as well.)
>>
>> Such a comparison would make it easier for arch, subsystem and distribution
>> maintainers to decide on which variant to use/enable.
>
> Sure, I can write this up. I'm not sure "safe"/"unsafe" is quite that
> clean. The differences between -full and -fast are pretty subtle, but
> I think I can describe it using the updated LKDTM tests I've written
> to compare the two. There are conditions that -fast doesn't catch, but
> those cases aren't actually useful for the overflow defense.
>
> As for "avg fast path instructions", do you mean the resulting
> assembly for each refcount API function? I think it's going to look
> something like "1   2   45", but I'll write it up.

So, doing a worst-case timing of a loop of inc() to INT_MAX and then
dec_and_test() back to zero, I see this out of perf:

atomic
25255.114805      task-clock (msec)
 82249267387      cycles
 11208720041      instructions

refcount-fast
25259.577583      task-clock (msec)
 82211446892      cycles
 15486246572      instructions

refcount-full
44625.923432      task-clock (msec)
144814735193      cycles
105937495952      instructions

I'll still summarize all this in the v7 series, but I think that
really clarifies the differences: 1.5x more instructions in -fast, but
nearly identical cycles and clock. Using -full sees a large change (as
expected).

-Kees

-- 
Kees Cook
Pixel Security
