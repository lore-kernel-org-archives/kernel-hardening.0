MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com> <20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 27 May 2017 12:58:14 -0700
Message-ID: <CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 3, 2017 at 4:23 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 20 Feb 2017 13:29:46 +0200 Elena Reshetova <elena.reshetova@intel.com> wrote:
>
>> Now when new refcount_t type and API are finally merged
>> (see include/linux/refcount.h), the following
>> patches convert various refcounters in the ipc susystem from atomic_t
>> to refcount_t. By doing this we prevent intentional or accidental
>> underflows or overflows that can led to use-after-free vulnerabilities.
>>
>> The below patches are fully independent and can be cherry-picked separately.
>> Since we convert all kernel subsystems in the same fashion, resulting
>> in about 300 patches, we have to group them for sending at least in some
>> fashion to be manageable. Please excuse the long cc list.
>
> Again, the refcount_t operations are much more expensive than the bare
> atomic_t operations.  I'm reluctant to merge any of these conversions

Since Manfred did a recent refactor of IPC RCU, and the refcount usage
is minimal, it seemed a good time to ask after these patches again.
(And send an updated one for the refactor.)

> without either
>
> a) a convincing demonstration that the performance impact is
>    sufficiently small (ie: unmeasurable) or

I've sent a few versions of a much faster refcount implementation
which has no measurable difference to atomic_t operations (based on
the PaX implementation). Getting more eyes on that would be nice; I'll
include you on CC when I send the next version.

> b) a compile-time option to disable the refcount_t operations (make
>    them generate the same code as the bare atomic_t ops).  Along with
>    some suitably reliable means of preventing people from accidentally
>    enabling the debug code in production builds.

Since the speed-ups will likely be arch-specific, should my proposed
CONFIG_FAST_REFCOUNT be made arch-indep when no arch-specific
implementation available (via totally unchecked atomic_t ops)? i.e.:

FAST_REFCOUNT=n: use function-based refcount_t with cmpxvhg and
full-verification
FAST_REFCOUNT=y without arch-specific implementation: use atomic_t
with no verification (i.e. no functional change from now)
FAST_REFCOUNT=y with arch-specific implementation: use atomic_t with
overflow protection

which means FAST_REFCOUNT would need to be default-on so that mm,
block, net users will remain happy.

Does that sound reasonable?

-Kees

-- 
Kees Cook
Pixel Security
