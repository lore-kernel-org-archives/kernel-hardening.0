Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Apr 2016 12:08:30 +0800
From: Baoquan He <bhe@redhat.com>
Message-ID: <20160415040830.GB2631@x1.redhat.com>
References: <1458631937-14593-1-git-send-email-bhe@redhat.com>
 <20160405015613.GA4654@x1.redhat.com>
 <CAGXu5jKtXndmfLNt1PZvL1oE5BXHDHsAcGBy=0V-nHg=6CA8HA@mail.gmail.com>
 <20160413101950.GC9482@gmail.com>
 <CAGXu5jL21Jk7tKYnVULDskOKeq-QgQM6E0z6EuzmDMp5Sa2iBA@mail.gmail.com>
 <CAGXu5jJFcT9CgKvJSJ9rDOz4D8fJRhDbxBGwOpQhUA2OyYPAzg@mail.gmail.com>
 <20160414150641.GA2599@x1.redhat.com>
 <CAGXu5jLEDekACCizQaDinLZ63oc=40VpXfwBP5thagA3pCOOOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLEDekACCizQaDinLZ63oc=40VpXfwBP5thagA3pCOOOA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 00/20] x86, boot: kaslr cleanup and 64bit kaslr support
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/14/16 at 10:56am, Kees Cook wrote:
> On Thu, Apr 14, 2016 at 8:06 AM, Baoquan He <bhe@redhat.com> wrote:
> > On 04/13/16 at 11:02pm, Kees Cook wrote:
> >> On Wed, Apr 13, 2016 at 7:11 AM, Kees Cook <keescook@chromium.org> wrote:
> >> > On Wed, Apr 13, 2016 at 3:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >>
> >> >> * Kees Cook <keescook@chromium.org> wrote:
> >> >>
> >> >>> FWIW, I've also had this tree up in my git branches, and the 0day
> >> >>> tester hasn't complained at all about it in the last two weeks. I'd
> >> >>> really like to see this in -next to fix the >4G (mainly kexec) issues
> >> >>> and get us to feature parity with the arm64 kASLR work (randomized
> >> >>> virtual address).
> >>
> >> So, I've done this and suddenly realized I hadn't boot-tested i386. It
> >> doesn't work, unfortunately. (Which I find strange: I'd expect 0day to
> >> have noticed...)
> >>
> >> Baoquan, have you tested this on 32-bit systems? I get a variety of
> >> failures. Either it boots okay, it reboots, or I get tons of pte
> >> errors like this:
> >
> > Hi Kees,
> >
> > I am sorry I didn't notice the change impacts i386. I got a i386 machine
> > and had tests. Found i386 can't take separate randomzation since there's
> > difference between i386 and x86_64.
> >
> > x86_64 has phys_base and can translate virt addr and phys addr according
> > to below formula:
> >
> > paddr = vaddr - __START_KERNEL_map + phys_base;
> >
> > However i386 can only do like this:
> >
> > paddr = vaddr - PAGE_OFFSET;
> >
> > Besides i386 has to reserve 128M for VMALLOC at the end of kernel
> > virtual address. So for i386 area 768M is the upper limit for
> > randomization. But I am fine with the KERNEL_IMAGE_SIZE, the old default
> > value. What do you say about this?
> >
> > So the plan should be keeping the old style of randomization for i386
> > system:
> >
> > 1) Disable virtual address randomization in i386 case because it's
> > useless. This should be done in patch:
> >  x86, KASLR: Randomize virtual address separately
> >
> > 2) Add an upper limit for physical randomization if it's i386 system.
> >  x86, KASLR: Add physical address randomization >4G
> >
> > I just got a test machine in office, and haven't had time to change
> > code. You can change it directly, or I will do it tomorrow.
> 
> I was thinking about the physical vs virtual on i386 as I woke up
> today. :) Thanks for confirming! These changes appear to make the
> series boot reliably on i386 (pardon any gmail-induced whitespace
> damage...):
> 
> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> index 5bae54b50d4c..3a58fe8acb8e 100644
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -347,6 +347,10 @@ static void process_e820_entry(struct e820entry *entry,
>         if (entry->type != E820_RAM)
>                 return;
> 
> +       /* On 32-bit, ignore entries entirely above our maximum. */
> +       if (IS_ENABLED(CONFIG_X86_32) && entry->addr >= KERNEL_IMAGE_SIZE)
> +               return;
> +
>         /* Ignore entries entirely below our minimum. */
>         if (entry->addr + entry->size < minimum)
>                 return;
> @@ -372,6 +376,11 @@ static void process_e820_entry(struct e820entry *entry,
>                 /* Reduce size by any delta from the original address. */
>                 region.size -= region.start - start_orig;
> 
> +               /* On 32-bit, reduce region size to fit within max size. */
> +               if (IS_ENABLED(CONFIG_X86_32) &&
> +                   region.start + region.size > KERNEL_IMAGE_SIZE)
> +                       region.size = KERNEL_IMAGE_SIZE - region.start;
> +
>                 /* Return if region can't contain decompressed kernel */
>                 if (region.size < image_size)
>                         return;
> @@ -488,6 +497,8 @@ void choose_kernel_location(unsigned char *input,
>         }
> 
>         /* Pick random virtual address starting from LOAD_PHYSICAL_ADDR. */
> -       random = find_random_virt_offset(LOAD_PHYSICAL_ADDR, output_size);
> +       if (IS_ENABLED(CONFIG_X86_64))
> +               random = find_random_virt_offset(LOAD_PHYSICAL_ADDR,
> +                                                output_size);
>         *virt_offset = (unsigned char *)random;
>  }
> 
> 
> I will split these chunks up into the correct patches and resend the
> series. If you get a chance, can you double-check this?

Yes, these changes sounds great. I checked the series you posted, and
have to say you make them look much better. The change logs are perfect
and great code refactoring. Just one little bit thing, here:

[kees: rewrote changelog, refactored goto into while, limit 32-bit to 1G]
in patch [PATCH v5 19/21] x86, KASLR: Add physical address randomization >4G

In i386 KERNEL_IMAGE_SIZE is kept to be 0x20000000, namely 512M, w/o kaslr
enabled. So here I guess it's a typo, should be "limit 32-bit to 1G". And
what I said is wrong about upper limit yesterday, in fact i386 can put kernel
in [16M, 896M), not 768M. But KERNEL_IMAGE_SIZE is good enough for i386 for
now.
