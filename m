From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5j+QU7OXWA_oMaLUsDnS4yyfNx8-1f_ywHX=o88kqE7=JQ@mail.gmail.com>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org> <20170720091106.kigtr6zy7pjgk2s6@gmail.com> <20170721142255.586224f0db9cf0714e654859@linux-foundation.org> <CAGXu5j+QU7OXWA_oMaLUsDnS4yyfNx8-1f_ywHX=o88kqE7=JQ@mail.gmail.com>
Date: Mon, 24 Jul 2017 16:38:06 +1000
Message-ID: <87zibujq5t.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v6 0/2] x86: Implement fast refcount overflow protection
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:
> On Fri, Jul 21, 2017 at 2:22 PM, Andrew Morton
>>
>> Do we have a feeling for how feasible/difficult it will be for other
>> architectures to implement such a thing?
>
> The PaX atomic_t overflow protection this is heavily based on was
> ported to a number of architectures (arm, powerpc, mips, sparc), so I
> suspect it shouldn't be too hard to adapt those for the more narrow
> refcount_t protection:
> https://forums.grsecurity.net/viewtopic.php?f=7&t=4173

The ppc code there appears to be 32-bit only and has other issues so
probably isn't something we'd use.

I don't think there should be any fundamental problem implementing it.

What I'm not entirely clear on is what the best trade off is in terms of
overhead vs checks. The summary of behaviour between the fast and full
versions you promised Ingo will help there I think.

cheers
