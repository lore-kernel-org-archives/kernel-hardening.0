MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>
References: <20170421220939.GA65363@beast> <20170424083250.h2wv2exbi4ytigac@hirez.programming.kicks-ass.net>
 <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Apr 2017 13:33:11 -0700
Message-ID: <CAGXu5jLDybHn_K=vpXOhrsBE_-EtPA+jbXCqHmm3tUgbK24BOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: PaX Team <pageexec@freemail.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 4:00 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 24 Apr 2017 at 10:32, Peter Zijlstra wrote:
>
>> On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
>> > This patch ports the x86-specific atomic overflow handling from PaX's
>> > PAX_REFCOUNT to the upstream refcount_t API. This is an updated version
>> > from PaX that eliminates the saturation race condition by resetting the
>> > atomic counter back to the INT_MAX saturation value on both overflow and
>> > underflow. To win a race, a system would have to have INT_MAX threads
>> > simultaneously overflow before the saturation handler runs.
>
> note that the above is wrong (and even contradicting itself and the code).

True, this changelog could be more accurate (it resets to INT_MAX on
overflow and INT_MIN on underflow). I think I'm right in saying that a
system would need INT_MAX threads running a refcount_inc() (and a
refcount_dec_and_test() at exactly the right moment) before the reset
handler got scheduled, though, yes?

I'll attempt to clarify this.

-Kees

-- 
Kees Cook
Pixel Security
