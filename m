Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <563d8e71-b119-f76d-3784-20f24e43f44d@linux.intel.com>
References: <20170104221630.831-1-thgarnie@google.com> <20170105081114.GD2098@gmail.com>
 <4dffd167-9cfd-dfcc-6556-05d7ca8f4595@linux.intel.com> <CAJcbSZFjurkb7dpN40XpVQLziQVxPWCt9iRfnzbRa+TWYTdq8w@mail.gmail.com>
 <563d8e71-b119-f76d-3784-20f24e43f44d@linux.intel.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 5 Jan 2017 11:00:20 -0800
Message-ID: <CAJcbSZGwqMgr79SndxHBVsyPZvefGRRR+bHembgHPXny8k506w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 10:56 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 1/5/2017 8:40 AM, Thomas Garnier wrote:
>>
>> Well, it happens only when KASLR memory randomization is enabled. Do
>> you think it should have a separate config option?
>
>
> no I would want it a runtime option.... "sgdt from ring 3" is going away
> with UMIP (and is already possibly gone in virtual machines, see
> https://lwn.net/Articles/694385/) and for those cases it would be a shame
> to lose the randomization
>

That's correct. When UMIP is enabled, we should disable fixed location
for both GDT and IDT. Glad to do that when UMIP support is added.

-- 
Thomas
