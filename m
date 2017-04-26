MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <58FFFF78.5586.1FBAC458@pageexec.freemail.hu>
References: <1493160997-126108-1-git-send-email-keescook@chromium.org> <58FFFF78.5586.1FBAC458@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Apr 2017 20:59:10 -0700
Message-ID: <CAGXu5j+N9x+jXB4ozDPnTSXT4EHTjuQ8mOuCmAtBEpwe8bLusQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 0/2] x86, refcount: Implement fast refcount overflow
To: PaX Team <pageexec@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 25, 2017 at 7:01 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 25 Apr 2017 at 15:56, Kees Cook wrote:
>
>> This protection is a modified version of the x86 PAX_REFCOUNT
>> implementation from PaX/grsecurity. This speeds up the refcount_t API by
>> duplicating the existing atomic_t implementation with a single instruction
>> added to detect if the refcount has wrapped past INT_MAX (or below 0)
>> resulting in a signed value.
>
> 'signed value' sounds somewhat ambiguous given that in C a signed type (such
> as the one beneath refcount_t) can have both negative and positive values yet
> you didn't mean the latter here i guess.

Yeah, the language for the CPU "sign flag" confuses this. I will
attempt to clarify for future versions.

>> Various differences from PaX:
>> - uses "js" instead of "jo" to trap all signed results instead of just
>>   under/overflow transitions
>
> there're differences in my 4.11 port but this isn't one of them.

Any changes you'd suggest for upstreaming?

-Kees

-- 
Kees Cook
Pixel Security
