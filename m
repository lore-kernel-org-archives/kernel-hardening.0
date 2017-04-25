MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <58FF3273.2718.1C99E5A3@pageexec.freemail.hu>
References: <20170421220939.GA65363@beast> <CAGXu5jK5s0KBAfwHPhobiSCn6b0QA4Wb=w=eJG4KyukwbdHTzg@mail.gmail.com>
 <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net> <58FF3273.2718.1C99E5A3@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Apr 2017 09:36:17 -0700
Message-ID: <CAGXu5j+PrB73FW9eYAaK4v0QBN01-_WLzq+oX2nUB2uuA4jXPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: PaX Team <pageexec@freemail.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 25, 2017 at 4:26 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 25 Apr 2017 at 0:01, Peter Zijlstra wrote:
>> How is the below not useful fodder for an exploit? It might be a less
>> common bug, and perhaps a bit more fiddly to make work, but afaict its
>> still a full use-after-free and therefore useful.
>>
>> ---
>>
>> Thread-A                                        Thread-B
>>
>> if(dec_and_test(&obj->ref)) { // true, ref==0
>>
>>                                                 inc(&obj->ref) // ref: 0->1
>>
>>         kfree(obj);
>> }
>
> ... and tell me why an attacker would let Thread-B do that increment
> (that you're trying to detect) *before* the underlying memory gets
> reused and thus the 0 changed to something else? hint: he'll do everything
> in his power to prevent that, either by winning the race or if there's
> no race (no refcount users outside his control), he'll win every time.
> IOW, checking for 0 is pointless and you kinda proved it yourself now.

Right, having a deterministic protection (checking for overflow) is
best since it stops all exploits using that path. Hoping that an
attacker is unlucky and hits a notification after they've already
landed their corruption is not a very useful defense. It certainly has
a non-zero value, but stopping overflow 100% is better. Especially
when we can do it with no meaningful change in performance which lets
us actually do the atomic_t -> refcount_t conversion everywhere.

-Kees

-- 
Kees Cook
Pixel Security
