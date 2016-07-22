Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 22 Jul 2016 12:21:05 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160722102105.GA20771@gmail.com>
References: <cover.1468270393.git.luto@kernel.org>
 <cover.1468270393.git.luto@kernel.org>
 <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
 <5741.1469162592@turing-police.cc.vt.edu>
 <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd,
 don't set the pgd entry until it's populated
To: Andy Lutomirski <luto@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> On 07/21/2016 09:43 PM, Valdis.Kletnieks@vt.edu wrote:
> >On Mon, 11 Jul 2016 13:53:36 -0700, Andy Lutomirski said:
> >>This avoids pointless races in which another CPU or task might see a
> >>partially populated global pgd entry.  These races should normally
> >>be harmless, but, if another CPU propagates the entry via
> >>vmalloc_fault and then populate_pgd fails (due to memory allocation
> >>failure, for example), this prevents a use-after-free of the pgd
> >>entry.
> >>
> >>Signed-off-by: Andy Lutomirski <luto@kernel.org>
> >>---
> >> arch/x86/mm/pageattr.c | 9 ++++++---
> >> 1 file changed, 6 insertions(+), 3 deletions(-)
> >
> >I just bisected a failure to boot down to this patch.  On my Dell Latitude
> >laptop, it results in the kernel being loaded and then just basically sitting
> >there dead in the water - as far as I can tell, it dies before the kernel
> >ever gets going far enough to do any console I/O (even with ignore_loglevel).
> >Nothing in /sys/fs/pstore either.  I admit not understanding the VM code
> >at all, so I don't have a clue *why* this causes indigestion...
> >
> >CPU is an Intel Core i5-3340M in case that matters....
> >
> 
> How much memory do you have and what's your config?  My code is obviously
> buggy, but I'm wondering why neither I nor the 0day bot caught this.
> 
> The attached patch is compile-tested only.  (Even Thunderbird doesn't want
> to send non-flowed text right now, sigh.)
> 
> --Andy

> From 6589ddf69a1369e1ecb95f0af489d90b980e256e Mon Sep 17 00:00:00 2001
> Message-Id: <6589ddf69a1369e1ecb95f0af489d90b980e256e.1469165371.git.luto@kernel.org>
> From: Andy Lutomirski <luto@kernel.org>
> Date: Thu, 21 Jul 2016 22:22:02 -0700
> Subject: [PATCH] x86/mm: Fix populate_pgd()
> 
> I make an obvious error in populate_pgd() -- it would fail to correctly
> populate the page tables when it allocated a new pud page.

JFYI, on allnoconfig it gives:

  arch/x86/mm/pageattr.c:1016:20: error: implicit declaration of function ‘pud_index’ [-Werror=implicit-function-declaration]

Thanks,

	Ingo
