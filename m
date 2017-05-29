Date: Mon, 29 May 2017 01:39:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170529083903.GA17735@infradead.org>
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com>
 <20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
 <CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 27, 2017 at 12:58:14PM -0700, Kees Cook wrote:
> FAST_REFCOUNT=n: use function-based refcount_t with cmpxvhg and
> full-verification
> FAST_REFCOUNT=y without arch-specific implementation: use atomic_t
> with no verification (i.e. no functional change from now)
> FAST_REFCOUNT=y with arch-specific implementation: use atomic_t with
> overflow protection
> 
> which means FAST_REFCOUNT would need to be default-on so that mm,
> block, net users will remain happy.
> 
> Does that sound reasonable?

I'd rather turn the options around so that the atomic_t or fast
arch implementations are the defaul.  But either way it needs to
be configurable.  Once that is done we can spread refcount_t everywhere
and everyone will be better off, if only for the documentation value
of the type when they use the atomic_t based implementation.
