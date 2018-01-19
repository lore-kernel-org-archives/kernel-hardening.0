MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAG48ez0Y97-gyzWBmcVbUyLuzUG42To=Mm8PAKuzWma6XbFmew@mail.gmail.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632010687.21271.12004432287640499992.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAG48ez0Y97-gyzWBmcVbUyLuzUG42To=Mm8PAKuzWma6XbFmew@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Jan 2018 10:18:53 -0800
Message-ID: <CA+55aFw-RNg4diZ0RCVkEYAANDp22YDskNOR913vKQEBdarJSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4 02/10] asm/nospec, array_ptr:
 sanitize speculative array de-references
To: Jann Horn <jannh@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, the arch/x86 maintainers <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 19, 2018 at 2:20 AM, Jann Horn <jannh@google.com> wrote:
>> +                                                                       \
>> +       __u._ptr = _arr + (_i & _mask);                                 \
>> +       __u._bit &= _mask;                                              \
>
> AFAICS, if `idx` is out of bounds, you first zero out the index
> (`_i & _mask`) and then immediately afterwards zero out
> the whole pointer (`_u._bit &= _mask`).
> Is there a reason for the `_i & _mask`, and if so, can you
> add a comment explaining that?

I think that's just leftovers from my original (untested) thing that
also did the access itself. So that __u._bit masking wasn't masking
the pointer, it was masking the value that was *read* from the
pointer, so that you could know that an invalid access returned
0/NULL, not just the first value in the array.

                  Linus
