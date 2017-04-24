From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 24 Apr 2017 13:00:18 +0200
MIME-Version: 1.0
Message-ID: <58FDDAC2.11341.175B5A99@pageexec.freemail.hu>
In-reply-to: <20170424083250.h2wv2exbi4ytigac@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>, <20170424083250.h2wv2exbi4ytigac@hirez.programming.kicks-ass.net>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 24 Apr 2017 at 10:32, Peter Zijlstra wrote:

> On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
> > This patch ports the x86-specific atomic overflow handling from PaX's
> > PAX_REFCOUNT to the upstream refcount_t API. This is an updated version
> > from PaX that eliminates the saturation race condition by resetting the
> > atomic counter back to the INT_MAX saturation value on both overflow and
> > underflow. To win a race, a system would have to have INT_MAX threads
> > simultaneously overflow before the saturation handler runs.

note that the above is wrong (and even contradicting itself and the code).

> And is this impossible? Highly unlikely I'll grant you, but absolutely
> impossible?

here's my analysis from a while ago:
http://www.openwall.com/lists/kernel-hardening/2017/01/05/19

> Also, you forgot nr_cpus in your bound. Afaict the worst case here is
> O(nr_tasks + 3*nr_cpus).

what does nr_cpus have to do with winning the race?

> Because PaX does it, is not a correctness argument. And this really
> wants one.

heh, do you want to tell me about how checking for a 0 refcount prevents
exploiting a bug?
