MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5900026E.29602.1FC65392@pageexec.freemail.hu>
References: <20170421220939.GA65363@beast> <58FF3273.8060.1C99E526@pageexec.freemail.hu>
 <CAGXu5jJF0g7Yw+2PDw_woyv0GsCOrX61noMu00p-hSO4Thi65Q@mail.gmail.com> <5900026E.29602.1FC65392@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Apr 2017 21:42:39 -0700
Message-ID: <CAGXu5jJDQKCiMpqDaLyDQ74ZH7LZ=zwB68+k2arGpWNeq9f1aA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: PaX Team <pageexec@freemail.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 25, 2017 at 7:14 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 25 Apr 2017 at 9:39, Kees Cook wrote:
>
>> On Tue, Apr 25, 2017 at 4:26 AM, PaX Team <pageexec@freemail.hu> wrote:
>> > INT_MAX threads would be needed when the leaking path is locked so
>> > that it can only be exercised once and you'll need to get normal
>> > (balanced) paths preempted just after the increment. if the leaking
>> > path is lockless (can be exercised in parallel without bounds) then
>> > 2 threads are enough where the one triggering the signed overflow
>> > would have to be preempted while the other one does INT_MAX increments
>> > and trigger the UAF. this is where the other mechanisms i talked about
>> > in the past become relevant: preemption or interrupts can be disabled
>> > or negative refcount values can be detected and acted upon (your blind
>> > copy-pasting effort passed upon this latter opportunity by not
>> > specializing the 'jo' into 'js' for the refcount case).
>>
>> Well, it's not "blind" -- I'm trying to bring the code as-is to
>> upstream for discussion/examination with as little functional
>> differences as possible so it's easier to compare apples to apples.
>
> you copied code from a version which is at least 2 major kernel revisions
> behind (so much for those apples)

Hmm, this was from your 4.9 port. Linus hasn't quite released 4.11
yet, so that's actually "at most 2 major kernel revisions behind". :)
Regardless, I'd be happy to refresh the port. Will you share a URL to
your latest rebase against upstream?

> you chose the one version which had a
> bug that you didn't spot nor fix properly, you didn't realize the opportunity
> that a special refcount type represents, you claimed refcount underflows
> aren't exploitable but copied code that would detect signed underflow, you
> didn't understand the limits and edge cases i explained above... need i go

As I said, I was trying to minimize changes to your implementation,
which included the bug and the other issues. The point of this was to
share it with others, and work collaboratively on it. I think this
clearly succeeded with benefits to both upstream and PaX: Jann spotted
the fix for the bug causing weird crashes I saw when doing initial
testing, you pointed out the benefit of using js over jo, I've
reorganized the RMWcc macros for more easily adding trailing
instructions, Peter is thinking about ways around the protection, etc.

> on? doesn't leave one with great confidence in your ability to understand
> and maintain this code...

Well, that's your opinion. I think the patch and its discussion helped
several people, including myself, understand this code. Since many
people will share its maintenance, I think this is the right way to
handle upstreaming these kinds of things. I don't claim to be
omniscient, just persistent. Getting this protection into upstream
means every Linux user will benefit from what you created, which I
think is awesome; this whole class of refcount flaws goes away. Thank
you for writing it, sharing it, and discussing it!

-Kees

-- 
Kees Cook
Pixel Security
