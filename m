Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 13 May 2016 00:27:37 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201605130033.YOkcowB0%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1463069340-117401-4-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v4 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: Thomas Garnier <thgarnie@google.com>
Cc: kbuild-all@01.org, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[auto build test ERROR on next-20160512]
[cannot apply to tip/x86/core v4.6-rc7 v4.6-rc6 v4.6-rc5 v4.6-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Thomas-Garnier/x86-boot-KASLR-memory-randomization/20160513-001319
config: i386-tinyconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: the linux-review/Thomas-Garnier/x86-boot-KASLR-memory-randomization/20160513-001319 HEAD cc523b95f012eb1d78508133b5b19b0a561ed3e1 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   arch/x86/mm/init.c: In function 'init_mem_mapping':
>> arch/x86/mm/init.c:595:2: error: 'trampoline_pgd_entry' undeclared (first use in this function)
     trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
     ^~~~~~~~~~~~~~~~~~~~
   arch/x86/mm/init.c:595:2: note: each undeclared identifier is reported only once for each function it appears in
>> arch/x86/mm/init.c:595:25: error: 'init_level4_pgt' undeclared (first use in this function)
     trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
                            ^~~~~~~~~~~~~~~

vim +/trampoline_pgd_entry +595 arch/x86/mm/init.c

   589	#endif
   590	
   591		/* the ISA range is always mapped regardless of memory holes */
   592		init_memory_mapping(0, ISA_END_ADDRESS);
   593	
   594		/* Default trampoline pgd value */
 > 595		trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
   596	
   597		/* Init the trampoline page table if needed for KASLR memory */
   598		kaslr_trampoline_init();

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--6c2NcOVqGQ03X4Wi
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--6c2NcOVqGQ03X4Wi--
