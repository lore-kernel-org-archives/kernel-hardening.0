From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 25 Apr 2017 13:26:43 +0200
MIME-Version: 1.0
Message-ID: <58FF3273.8060.1C99E526@pageexec.freemail.hu>
In-reply-to: <CAGXu5jLDybHn_K=vpXOhrsBE_-EtPA+jbXCqHmm3tUgbK24BOw@mail.gmail.com>
References: <20170421220939.GA65363@beast>, <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>, <CAGXu5jLDybHn_K=vpXOhrsBE_-EtPA+jbXCqHmm3tUgbK24BOw@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 24 Apr 2017 at 13:33, Kees Cook wrote:

> On Mon, Apr 24, 2017 at 4:00 AM, PaX Team <pageexec@freemail.hu> wrote:
> > On 24 Apr 2017 at 10:32, Peter Zijlstra wrote:
> >
> >> On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
> >> > This patch ports the x86-specific atomic overflow handling from PaX's
> >> > PAX_REFCOUNT to the upstream refcount_t API. This is an updated version
> >> > from PaX that eliminates the saturation race condition by resetting the
> >> > atomic counter back to the INT_MAX saturation value on both overflow and
> >> > underflow. To win a race, a system would have to have INT_MAX threads
> >> > simultaneously overflow before the saturation handler runs.
> >
> > note that the above is wrong (and even contradicting itself and the code).
> 
> True, this changelog could be more accurate (it resets to INT_MAX on
> overflow and INT_MIN on underflow). I think I'm right in saying that a
> system would need INT_MAX threads running a refcount_inc() (and a
> refcount_dec_and_test() at exactly the right moment) before the reset
> handler got scheduled, though, yes?

there's no uniform answer to this as there're several conditions
that can affect the effectiveness of the refcount protection.

e.g., how many independent leaking paths can the attacker exercise
(typically one), are these paths under some kind of locks (would
already prevent unbounded leaks/increments should the overflow
detecting thread be preempted), are negative refcounts allowed and
checked for or only signed overflow, etc.

INT_MAX threads would be needed when the leaking path is locked so
that it can only be exercised once and you'll need to get normal
(balanced) paths preempted just after the increment. if the leaking
path is lockless (can be exercised in parallel without bounds) then
2 threads are enough where the one triggering the signed overflow
would have to be preempted while the other one does INT_MAX increments
and trigger the UAF. this is where the other mechanisms i talked about
in the past become relevant: preemption or interrupts can be disabled
or negative refcount values can be detected and acted upon (your blind
copy-pasting effort passed upon this latter opportunity by not
specializing the 'jo' into 'js' for the refcount case).
