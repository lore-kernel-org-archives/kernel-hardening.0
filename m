Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160714083411.GA15437@gmail.com>
References: <cover.1468270393.git.luto@kernel.org> <8d36dd9b2430b61db64333af7b911d0bca7d5d2f.1468270393.git.luto@kernel.org>
 <20160713075314.GA32700@gmail.com> <CALCETrW9B=MAGaLAV0Y86MQ2==pjoShHdOPNM_8ZR1OKZDy2ZQ@mail.gmail.com>
 <20160714083411.GA15437@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 14 Jul 2016 09:51:29 -0700
Message-ID: <CALCETrUk9Ae-kGixsoqZZG3gb+=JCpQ-zbuNU8R+V6TFg4ymeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v5 14/32] x86/mm/64: Enable vmapped stacks
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 14, 2016 at 1:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Wed, Jul 13, 2016 at 12:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Andy Lutomirski <luto@kernel.org> wrote:
>> >
>> >> This allows x86_64 kernels to enable vmapped stacks.  There are a
>> >> couple of interesting bits.
>> >
>> >> --- a/arch/x86/Kconfig
>> >> +++ b/arch/x86/Kconfig
>> >> @@ -92,6 +92,7 @@ config X86
>> >>       select HAVE_ARCH_TRACEHOOK
>> >>       select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>> >>       select HAVE_EBPF_JIT                    if X86_64
>> >> +     select HAVE_ARCH_VMAP_STACK             if X86_64
>> >
>> > So what is the performance impact?
>>
>> Seems to be a very slight speedup (0.5 =E7=9B=9C or so) on my silly benc=
hmark
>> (pthread_create, pthread_join in a loop). [...]
>
> Music to my ears - although TBH there's probably two opposing forces: adv=
antages
> from the cache versus (possibly very minor, if measurable at all) disadva=
ntages
> from the 4K granularity.

True.  It's also plausible that there will be different lock
contention issues on very large system with vmalloc vs using the page
allocator.

And there's one other issue.  The patchset will considerably increase
the frequency with which vmap gets called, which will make the giant
hole in Chris Metcalf's isolation series more apparent.  But that's
not really a regression -- the problem is pre-existing, and I've
pointed it out a few times before.  Arguably it's even a benefit --
someone will have to *fix* it now :)

> So I'd prefer the following approach: to apply it to a v4.8-rc1 base in ~=
2 weeks
> and keep it default-y for much of the next development cycle. If no serio=
us
> problems are found in those ~2 months then send it to Linus in that fashi=
on. We
> can still turn it off by default (or re-spin the whole approach) if it tu=
rns out
> to be too risky.
>
> Exposing it as default-n for even a small amount of time will massively r=
educe the
> testing we'll get, as most people will just use the N setting (often with=
out
> noticing).
>
> Plus this also gives net-next and other preparatory patches applied direc=
tly to
> maintainer trees time to trickle upstream.

Works for me.

If you think it makes sense, I can split out a bunch of the x86 and mm
preparatory patches and, if it reorders cleanly and still works, the
THREAD_INFO_IN_TASK thing.  Those could plausibly go in 4.7.  Would
you like me to see how that goes?  (I'll verify that it builds, that
the 0day bot likes it, and that the final result of the patchset is
exactly identical to what I already sent.)

--Andy
