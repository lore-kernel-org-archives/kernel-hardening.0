From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 26 Apr 2017 04:14:06 +0200
MIME-Version: 1.0
Message-ID: <5900026E.29602.1FC65392@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJF0g7Yw+2PDw_woyv0GsCOrX61noMu00p-hSO4Thi65Q@mail.gmail.com>
References: <20170421220939.GA65363@beast>, <58FF3273.8060.1C99E526@pageexec.freemail.hu>, <CAGXu5jJF0g7Yw+2PDw_woyv0GsCOrX61noMu00p-hSO4Thi65Q@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Apr 2017 at 9:39, Kees Cook wrote:

> On Tue, Apr 25, 2017 at 4:26 AM, PaX Team <pageexec@freemail.hu> wrote:
> > INT_MAX threads would be needed when the leaking path is locked so
> > that it can only be exercised once and you'll need to get normal
> > (balanced) paths preempted just after the increment. if the leaking
> > path is lockless (can be exercised in parallel without bounds) then
> > 2 threads are enough where the one triggering the signed overflow
> > would have to be preempted while the other one does INT_MAX increments
> > and trigger the UAF. this is where the other mechanisms i talked about
> > in the past become relevant: preemption or interrupts can be disabled
> > or negative refcount values can be detected and acted upon (your blind
> > copy-pasting effort passed upon this latter opportunity by not
> > specializing the 'jo' into 'js' for the refcount case).
> 
> Well, it's not "blind" -- I'm trying to bring the code as-is to
> upstream for discussion/examination with as little functional
> differences as possible so it's easier to compare apples to apples.

you copied code from a version which is at least 2 major kernel revisions
behind (so much for those apples), you chose the one version which had a
bug that you didn't spot nor fix properly, you didn't realize the opportunity
that a special refcount type represents, you claimed refcount underflows
aren't exploitable but copied code that would detect signed underflow, you
didn't understand the limits and edge cases i explained above... need i go
on? doesn't leave one with great confidence in your ability to understand
and maintain this code...
