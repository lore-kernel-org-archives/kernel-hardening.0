Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160713075314.GA32700@gmail.com>
References: <cover.1468270393.git.luto@kernel.org> <8d36dd9b2430b61db64333af7b911d0bca7d5d2f.1468270393.git.luto@kernel.org>
 <20160713075314.GA32700@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 13 Jul 2016 11:42:35 -0700
Message-ID: <CALCETrW9B=MAGaLAV0Y86MQ2==pjoShHdOPNM_8ZR1OKZDy2ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v5 14/32] x86/mm/64: Enable vmapped stacks
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 13, 2016 at 12:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@kernel.org> wrote:
>
>> This allows x86_64 kernels to enable vmapped stacks.  There are a
>> couple of interesting bits.
>
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -92,6 +92,7 @@ config X86
>>       select HAVE_ARCH_TRACEHOOK
>>       select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>>       select HAVE_EBPF_JIT                    if X86_64
>> +     select HAVE_ARCH_VMAP_STACK             if X86_64
>
> So what is the performance impact?

Seems to be a very slight speedup (0.5 =C2=B5s or so) on my silly benchmark
(pthread_create, pthread_join in a loop).  It should be a small
slowdown on workloads that create many threads all at once, thus
defeating the stack cache.  It should be a *large* speedup on any
workload that would trigger compaction on clone() to satisfy the
high-order allocation.

>
> Because I think we should consider enabling this feature by default on x8=
6 - but
> the way it's selected here it will be default-off.
>
> On the plus side: the debuggability and reliability improvements are real=
 and
> making it harder for exploits to use kernel stack overflows is a nice bon=
us as
> well. There's two performance effects:

Agreed.  At the very least, I want to wait until after net-next gets
pulled to flip the default to y.  I'm also a bit concerned about more
random driver issues that I haven't found yet.  I suppose we could
flip the default to y for a few -rc releases and see what, if
anything, shakes loose.

--Andy
