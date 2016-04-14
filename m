Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Apr 2016 23:06:41 +0800
From: Baoquan He <bhe@redhat.com>
Message-ID: <20160414150641.GA2599@x1.redhat.com>
References: <1458631937-14593-1-git-send-email-bhe@redhat.com>
 <20160405015613.GA4654@x1.redhat.com>
 <CAGXu5jKtXndmfLNt1PZvL1oE5BXHDHsAcGBy=0V-nHg=6CA8HA@mail.gmail.com>
 <20160413101950.GC9482@gmail.com>
 <CAGXu5jL21Jk7tKYnVULDskOKeq-QgQM6E0z6EuzmDMp5Sa2iBA@mail.gmail.com>
 <CAGXu5jJFcT9CgKvJSJ9rDOz4D8fJRhDbxBGwOpQhUA2OyYPAzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJFcT9CgKvJSJ9rDOz4D8fJRhDbxBGwOpQhUA2OyYPAzg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 00/20] x86, boot: kaslr cleanup and 64bit kaslr support
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/13/16 at 11:02pm, Kees Cook wrote:
> On Wed, Apr 13, 2016 at 7:11 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Apr 13, 2016 at 3:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> * Kees Cook <keescook@chromium.org> wrote:
> >>
> >>> FWIW, I've also had this tree up in my git branches, and the 0day
> >>> tester hasn't complained at all about it in the last two weeks. I'd
> >>> really like to see this in -next to fix the >4G (mainly kexec) issues
> >>> and get us to feature parity with the arm64 kASLR work (randomized
> >>> virtual address).
> 
> So, I've done this and suddenly realized I hadn't boot-tested i386. It
> doesn't work, unfortunately. (Which I find strange: I'd expect 0day to
> have noticed...)
> 
> Baoquan, have you tested this on 32-bit systems? I get a variety of
> failures. Either it boots okay, it reboots, or I get tons of pte
> errors like this:

Hi Kees,

I am sorry I didn't notice the change impacts i386. I got a i386 machine
and had tests. Found i386 can't take separate randomzation since there's
difference between i386 and x86_64. 

x86_64 has phys_base and can translate virt addr and phys addr according
to below formula:

paddr = vaddr - __START_KERNEL_map + phys_base;

However i386 can only do like this:

paddr = vaddr - PAGE_OFFSET;

Besides i386 has to reserve 128M for VMALLOC at the end of kernel
virtual address. So for i386 area 768M is the upper limit for
randomization. But I am fine with the KERNEL_IMAGE_SIZE, the old default
value. What do you say about this?

So the plan should be keeping the old style of randomization for i386
system:

1) Disable virtual address randomization in i386 case because it's
useless. This should be done in patch:
 x86, KASLR: Randomize virtual address separately

2) Add an upper limit for physical randomization if it's i386 system.
 x86, KASLR: Add physical address randomization >4G

I just got a test machine in office, and haven't had time to change
code. You can change it directly, or I will do it tomorrow.

Thanks

> 
> [    0.000000] clearing pte for ram above max_low_pfn: pfn: 37dcc pmd:
> f9144f7c pmd phys: 39144f7c pte: f9a1b730 pte phys: 39a1b730
> 
> Can you confirm? I suspect relocation problems, but ran out of time
> today to debug it.
> 
> I have the entire series with cleaned up changelogs and various other
> refactorings up here now:
> 
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr/highmem
> 
> Thanks!
> 
> -Kees
> 
> -- 
> Kees Cook
> Chrome OS & Brillo Security
