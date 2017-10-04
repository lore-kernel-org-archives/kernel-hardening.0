MIME-Version: 1.0
In-Reply-To: <1506972007-80614-3-git-send-email-keescook@chromium.org>
References: <1506972007-80614-1-git-send-email-keescook@chromium.org> <1506972007-80614-3-git-send-email-keescook@chromium.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Wed, 4 Oct 2017 23:33:38 +0900
Message-ID: <CAK7LNARhoqX0Z--gFEP1xbvcEeg4aDD9rkV0SeUCa3icc1MN8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 2/3] Makefile: Move stackprotector availability out of Kconfig
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,


2017-10-03 4:20 GMT+09:00 Kees Cook <keescook@chromium.org>:
> Various portions of the kernel, especially per-architecture pieces,
> need to know if the compiler is building it with the stack protector.
> This was done in the arch/Kconfig with 'select', but this doesn't
> allow a way to do auto-detected compiler support. In preparation for
> creating an on-if-available default, move the logic for the definition of
> CONFIG_CC_STACKPROTECTOR into the Makefile.
>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Michal Marek <mmarek@suse.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Makefile     | 7 +++++--
>  arch/Kconfig | 8 --------
>  2 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index d1119941261c..e122a9cf0399 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -688,8 +688,11 @@ else
>    stackp-flag := $(call cc-option, -fno-stack-protector)
>  endif
>  endif
> -# Find arch-specific stack protector compiler sanity-checking script.
> -ifdef CONFIG_CC_STACKPROTECTOR
> +ifdef stackp-name
> +  # If the stack protector has been selected, inform the rest of the build.
> +  KBUILD_CFLAGS += -DCONFIG_CC_STACKPROTECTOR
> +  KBUILD_AFLAGS += -DCONFIG_CC_STACKPROTECTOR
> +  # Find arch-specific stack protector compiler sanity-checking script.
>    stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
>    stackp-check := $(wildcard $(stackp-path))
>  endif


I have not tested this series,
but I think this commit is bad (with the follow-up patch applied).


I thought of this scenario:

[1] Kernel is configured with CONFIG_CC_STACKPROTECTOR_AUTO

[2] Kernel is built with a compiler without stack protector support.

[3] CONFIG_CC_STACKPROTECTOR is not defined,
    so __stack_chk_fail() is not compiled.

[4] Out-of-tree modules are compiled with a compiler with
    stack protector support.
    __stack_chk_fail() is inserted to functions of the modules.

[5] insmod fails because reference to __stack_chk_fail()
    can not be resolved.




I think "select CC_STACKPROTECTOR" should be kept in Kconfig.




-- 
Best Regards
Masahiro Yamada
