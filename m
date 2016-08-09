Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 9 Aug 2016 15:30:04 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <alpine.LNX.2.00.1608091457370.22028@cbobk.fhfr.pm>
Message-ID: <alpine.LNX.2.00.1608091525540.22028@cbobk.fhfr.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <alpine.LRH.2.00.1608091121120.19185@gjva.wvxbf.pm> <CAJZ5v0iAiQwpBgY=4hH-RsBB54tD8FY4C8pWbjNNRmAjJ9Xg+Q@mail.gmail.com> <alpine.LNX.2.00.1608091457370.22028@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux PM list <linux-pm@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 9 Aug 2016, Jiri Kosina wrote:

> > 210e7a43fa90 mm: SLUB freelist randomization
> > 7c00fce98c3e mm: reorganize SLAB freelist randomization
> > 4ff5308744f5 x86/mm: Do not reference phys addr beyond kernel
> > 90397a417796 x86/mm: Add memory hotplug support for KASLR memory randomization
> > a95ae27c2ee1 x86/mm: Enable KASLR for vmalloc memory regions
> > 021182e52fe0 x86/mm: Enable KASLR for physical mapping memory regions
> 
> Okay, I did one-by-one reverts, and the one above, i.e.
> 
> 	commit 021182e52fe01c1f7b126f97fd6ba048dc4234fd
> 	Author: Thomas Garnier <thgarnie@google.com>
> 	Date:   Tue Jun 21 17:47:03 2016 -0700
> 
> 	    x86/mm: Enable KASLR for physical mapping memory regions
> 
> is the one that is the culprit on my machine. With this one reverted, 
> resume hibernation doesn't reboot (tripple fault?), but proceeds 
> succesfully.

As discussed with Rafael privately, I also tried this very patch 
(x86/power/64: Always create temporary identity mapping correctly) on top 
of the reverted revert of 021182e52fe01c1f7b1 (see the full log below), 
but such kernel triple faults on resume as well.

87c38d2 x86/power/64: Always create temporary identity mapping correctly
3cb504a Revert "Revert "x86/mm: Enable KASLR for physical mapping memory regions""
758850d Revert "x86/mm: Enable KASLR for physical mapping memory regions"
4a02dfb Revert "x86/mm: Enable KASLR for vmalloc memory regions"
037863f Revert "x86/mm: Add memory hotplug support for KASLR memory randomization"
3416a21 Revert "x86/mm: Do not reference phys addr beyond kernel"
69227be Revert "mm: reorganize SLAB freelist randomization"
a1d8d71 Revert "mm: SLUB freelist randomization"

IOW, 021182e52f introduces a bug for which there is no existing fix yet.

-- 
Jiri Kosina
SUSE Labs
