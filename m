Date: Fri, 7 Apr 2017 13:29:30 -0600
From: Eddie Kovsky <ewk@edkovsky.org>
Message-ID: <20170407192930.GA1526@athena>
References: <20170406033550.32525-3-ewk@edkovsky.org>
 <201704070155.EM9TWkdW%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201704070155.EM9TWkdW%fengguang.wu@intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 2/2] extable: verify address is read-only
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 04/07/17, kbuild test robot wrote:
> Hi Eddie,
> 
> [auto build test ERROR on next-20170330]
> [cannot apply to linus/master linux/master jeyu/modules-next v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eddie-Kovsky/module-verify-address-is-read-only/20170407-004322
> config: i386-randconfig-x010-201714 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    kernel/extable.c: In function 'core_kernel_rodata':
> >> kernel/extable.c:169:29: error: '__start_ro_after_init' undeclared (first use in this function)
>      if (addr >= (unsigned long)__start_ro_after_init &&
>                                 ^~~~~~~~~~~~~~~~~~~~~
>    kernel/extable.c:169:29: note: each undeclared identifier is reported only once for each function it appears in
> >> kernel/extable.c:170:28: error: '__end_ro_after_init' undeclared (first use in this function)
>          addr < (unsigned long)__end_ro_after_init)
>                                ^~~~~~~~~~~~~~~~~~~
> 
> vim +/__start_ro_after_init +169 kernel/extable.c
> 
>    163	int core_kernel_rodata(unsigned long addr)
>    164	{
>    165		if (addr >= (unsigned long)__start_rodata &&
>    166		    addr < (unsigned long)__end_rodata)
>    167			return 1;
>    168	
>  > 169		if (addr >= (unsigned long)__start_ro_after_init &&
>  > 170		    addr < (unsigned long)__end_ro_after_init)
>    171			return 1;
>    172	
>    173		return 0;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


This looks like a false alarm.

The test build is based on next-20170330. Kees' patch for the section
names [start|end]_ro_after_init didn't appear in next until 20170403.

I cannot reproduce the build error using this config on recent versions
of next. Am I missing something here?

Eddie
