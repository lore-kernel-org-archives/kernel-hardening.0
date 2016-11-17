Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <201611160623.afRvXZ5d%fengguang.wu@intel.com>
References: <201611160623.afRvXZ5d%fengguang.wu@intel.com>
Date: Thu, 17 Nov 2016 21:53:31 +1100
Message-ID: <87bmxextqs.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] lkdtm: Add tests for LIST_POISON and ZERO_SIZE_PTR
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

kbuild test robot <lkp@intel.com> writes:
> [auto build test ERROR on char-misc/char-misc-testing]
> [also build test ERROR on v4.9-rc5]
> [cannot apply to next-20161115]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Michael-Ellerman/lkdtm-Add-tests-for-LIST_POISON-and-ZERO_SIZE_PTR/20161115-235441
> config: i386-randconfig-i0-201646 (attached as .config)
> compiler: gcc-4.8 (Debian 4.8.4-1) 4.8.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: "mmap_min_addr" [drivers/misc/lkdtm.ko] undefined!

I couldn't see what was causing this, but of course it's just that
mmap_min_addr is not exported, and in that config LKDTM is a module.

I always build it in which is why I didn't notice.

I'm not sure we want to EXPORT_SYMBOL mmap_min_addr just for this test
do we? I could change the test to use mmap_min_addr if LKDTM is
built-in, and otherwise just map at zero. Dunno.

cheers
