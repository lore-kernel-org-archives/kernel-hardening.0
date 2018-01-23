Message-ID: <1516732614.5438.0.camel@linux.intel.com>
From: Alan Cox <alan@linux.intel.com>
Date: Tue, 23 Jan 2018 18:36:54 +0000
In-Reply-To: <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
References: 
	<503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
	 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

> And if we ever get CPU's that have this all fixed, we can re-visit
> introducing the fastpath. But this is all very messy and it doesn't
> seem worth it right now.

We already have CPUs it doesn't affect - older Atom for one and I
believe some or all of the VIA ones (still trying to get a definitive
confirmation).

Alan
