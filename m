Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160616060538.GA3923@osiris>
References: <cover.1466036668.git.luto@kernel.org> <20160616060538.GA3923@osiris>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Jun 2016 10:50:09 -0700
Message-ID: <CALCETrUTwG+fNgJQP8wYsAbxzjzARUwJ05jaRs0XfFPDHTB+ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 11:05 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Wed, Jun 15, 2016 at 05:28:22PM -0700, Andy Lutomirski wrote:
>> Since the dawn of time, a kernel stack overflow has been a real PITA
>> to debug, has caused nondeterministic crashes some time after the
>> actual overflow, and has generally been easy to exploit for root.
>>
>> With this series, arches can enable HAVE_ARCH_VMAP_STACK.  Arches
>> that enable it (just x86 for now) get virtually mapped stacks with
>> guard pages.  This causes reliable faults when the stack overflows.
>>
>> If the arch implements it well, we get a nice OOPS on stack overflow
>> (as opposed to panicing directly or otherwise exploding badly).  On
>> x86, the OOPS is nice, has a usable call trace, and the overflowing
>> task is killed cleanly.
>
> Do you have numbers which reflect the performance impact of this change?
>

Hmm.  My attempt to benchmark it caused some of the vmalloc core code
to hang.  I'll dig around.

FWIW, I expect some overhead on clone/fork (if it's high, then that
would be a good reason to improve vmalloc) and a small
workload-dependent overhead due to increased TLB pressure.

--Andy
