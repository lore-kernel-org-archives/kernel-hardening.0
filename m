Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrVKzUh_RYBoogWsEjYMe89en-NeNQhnWomy4LD=DaKfWQ@mail.gmail.com>
References: <cover.1468270393.git.luto@kernel.org> <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
 <5741.1469162592@turing-police.cc.vt.edu> <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
 <20160722102105.GA20771@gmail.com> <CALCETrVKzUh_RYBoogWsEjYMe89en-NeNQhnWomy4LD=DaKfWQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 22 Jul 2016 11:31:15 -0700
Message-ID: <CALCETrWqYBFvBemm8wqr3ZY0--rpOvuAgug0-510L+a72XNqpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd,
 don't set the pgd entry until it's populated
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 22, 2016 at 11:21 AM, Andy Lutomirski <luto@amacapital.net> wro=
te:
> On Fri, Jul 22, 2016 at 3:21 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Andy Lutomirski <luto@kernel.org> wrote:
>>
>>> On 07/21/2016 09:43 PM, Valdis.Kletnieks@vt.edu wrote:
>>> >On Mon, 11 Jul 2016 13:53:36 -0700, Andy Lutomirski said:
>>> >>This avoids pointless races in which another CPU or task might see a
>>> >>partially populated global pgd entry.  These races should normally
>>> >>be harmless, but, if another CPU propagates the entry via
>>> >>vmalloc_fault and then populate_pgd fails (due to memory allocation
>>> >>failure, for example), this prevents a use-after-free of the pgd
>>> >>entry.
>>> >>
>>> >>Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>> >>---
>>> >> arch/x86/mm/pageattr.c | 9 ++++++---
>>> >> 1 file changed, 6 insertions(+), 3 deletions(-)
>>> >
>>> >I just bisected a failure to boot down to this patch.  On my Dell Lati=
tude
>>> >laptop, it results in the kernel being loaded and then just basically =
sitting
>>> >there dead in the water - as far as I can tell, it dies before the ker=
nel
>>> >ever gets going far enough to do any console I/O (even with ignore_log=
level).
>>> >Nothing in /sys/fs/pstore either.  I admit not understanding the VM co=
de
>>> >at all, so I don't have a clue *why* this causes indigestion...
>>> >
>>> >CPU is an Intel Core i5-3340M in case that matters....
>>> >
>>>
>>> How much memory do you have and what's your config?  My code is obvious=
ly
>>> buggy, but I'm wondering why neither I nor the 0day bot caught this.
>>>
>>> The attached patch is compile-tested only.  (Even Thunderbird doesn't w=
ant
>>> to send non-flowed text right now, sigh.)
>>>
>>> --Andy
>>
>>> From 6589ddf69a1369e1ecb95f0af489d90b980e256e Mon Sep 17 00:00:00 2001
>>> Message-Id: <6589ddf69a1369e1ecb95f0af489d90b980e256e.1469165371.git.lu=
to@kernel.org>
>>> From: Andy Lutomirski <luto@kernel.org>
>>> Date: Thu, 21 Jul 2016 22:22:02 -0700
>>> Subject: [PATCH] x86/mm: Fix populate_pgd()
>>>
>>> I make an obvious error in populate_pgd() -- it would fail to correctly
>>> populate the page tables when it allocated a new pud page.
>>
>> JFYI, on allnoconfig it gives:
>>
>>   arch/x86/mm/pageattr.c:1016:20: error: implicit declaration of functio=
n =E2=80=98pud_index=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>
> As it happens, my fix interacts badly with the steaming pile of crap
> that is Linux's support for <4 page table levels.  Can you just revert
> the offending patch and I'll redo it differently?

No, don't revert it.  The result doesn't work.  I'll send something.
