From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 25 Apr 2017 13:26:43 +0200
MIME-Version: 1.0
Message-ID: <58FF3273.5306.1C99E565@pageexec.freemail.hu>
In-reply-to: <20170425102337.ocdi2v7ivue7x7cc@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>, <20170425102337.ocdi2v7ivue7x7cc@hirez.programming.kicks-ass.net>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Apr 2017 at 12:23, Peter Zijlstra wrote:

> So what avoids this:

simple, you noted it yourself in your previous mail:

> Well, your setup (panic_on_warn et al) would have it panic the box. That
> will effectively stop the exploit by virtue of stopping everything.

with that in mind the actual code looks like this:

>	CPU0				CPU1
>
>
>	lock inc %[val]; # 0x7fffffff
>	jo  2f
>1:	...
>
>					lock dec %[val]; # 0x80000000
>					jo  2f
>				1:	...
>
>
>
>
>2:	mov $0x7fffffff, %[val]

	panic()

>	jmp 1b
>
>				2:	mov $0x80000000, %[val]

					panic()

>					jmp 1b
>

... and we never get this far.
