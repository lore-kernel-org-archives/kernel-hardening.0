Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <201605130033.YOkcowB0%fengguang.wu@intel.com>
References: <1463069340-117401-4-git-send-email-thgarnie@google.com>
	<201605130033.YOkcowB0%fengguang.wu@intel.com>
Date: Thu, 12 May 2016 09:57:26 -0700
Message-ID: <CAJcbSZFJD3JU2NMVfvNoAqvwE1L1pC-C6kfs7k6-DFk5pN3r4g@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Sorry about that. I will fix and send a new iteration this afternoon.

Thomas

On Thu, May 12, 2016 at 9:27 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi,
>
> [auto build test ERROR on next-20160512]
> [cannot apply to tip/x86/core v4.6-rc7 v4.6-rc6 v4.6-rc5 v4.6-rc7]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Thomas-Garnier/x86-boot-KASLR-memory-randomization/20160513-001319
> config: i386-tinyconfig (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> Note: the linux-review/Thomas-Garnier/x86-boot-KASLR-memory-randomization/20160513-001319 HEAD cc523b95f012eb1d78508133b5b19b0a561ed3e1 builds fine.
>       It only hurts bisectibility.
>
> All errors (new ones prefixed by >>):
>
>    arch/x86/mm/init.c: In function 'init_mem_mapping':
>>> arch/x86/mm/init.c:595:2: error: 'trampoline_pgd_entry' undeclared (first use in this function)
>      trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
>      ^~~~~~~~~~~~~~~~~~~~
>    arch/x86/mm/init.c:595:2: note: each undeclared identifier is reported only once for each function it appears in
>>> arch/x86/mm/init.c:595:25: error: 'init_level4_pgt' undeclared (first use in this function)
>      trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
>                             ^~~~~~~~~~~~~~~
>
> vim +/trampoline_pgd_entry +595 arch/x86/mm/init.c
>
>    589  #endif
>    590
>    591          /* the ISA range is always mapped regardless of memory holes */
>    592          init_memory_mapping(0, ISA_END_ADDRESS);
>    593
>    594          /* Default trampoline pgd value */
>  > 595          trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
>    596
>    597          /* Init the trampoline page table if needed for KASLR memory */
>    598          kaslr_trampoline_init();
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
