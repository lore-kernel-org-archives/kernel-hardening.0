Date: Mon, 14 Aug 2017 10:21:50 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170814162150.ccq574wyt5ucuazn@smitten>
References: <20170809200755.11234-11-tycho@docker.com>
 <201708130449.P9mhc7yi%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201708130449.P9mhc7yi%fengguang.wu@intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 10/10] lkdtm: Add test for XPFO
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Aug 13, 2017 at 04:24:23AM +0800, kbuild test robot wrote:
> Hi Juerg,
> 
> [auto build test ERROR on arm64/for-next/core]
> [also build test ERROR on v4.13-rc4]
> [cannot apply to next-20170811]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Tycho-Andersen/Add-support-for-eXclusive-Page-Frame-Ownership/20170813-035705
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
> config: x86_64-randconfig-x016-201733 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/misc/lkdtm_xpfo.c: In function 'read_user_with_flags':
> >> drivers/misc/lkdtm_xpfo.c:31:14: error: implicit declaration of function 'user_virt_to_phys' [-Werror=implicit-function-declaration]
>      phys_addr = user_virt_to_phys(user_addr);
>                  ^~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors

These are both the same error, looks like I forgot a dummy prototype
in the non CONFIG_XPFO case, I'll fix it in the next version.

Tycho
