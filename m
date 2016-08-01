Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <1465336628-18219-4-git-send-email-keescook@chromium.org>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org> <1465336628-18219-4-git-send-email-keescook@chromium.org>
Date: Mon, 01 Aug 2016 22:37:24 +1000
Message-ID: <87h9b4oebf.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Linker segfault on powerpc when CONFIG_LKDTM=y (was Re: [kernel-hardening] [PATCH 3/5] lkdtm: add function for testing .rodata section)
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.orglinuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> This adds a function that lives in the .rodata section. The section
> flags are corrected using objcopy since there is no way with gcc to
> declare section flags in an architecture-agnostic way.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/misc/Makefile       |  7 +++++++
>  drivers/misc/lkdtm.h        |  6 ++++++
>  drivers/misc/lkdtm_core.c   | 24 +++++++++++++++++-------
>  drivers/misc/lkdtm_rodata.c | 10 ++++++++++
>  4 files changed, 40 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/misc/lkdtm.h
>  create mode 100644 drivers/misc/lkdtm_rodata.c

This is blowing up my linker :(

  scripts/link-vmlinux.sh: line 52: 36260 Segmentation fault      (core dumped) ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2} -T ${lds} ${KBUILD_VMLINUX_INIT} --start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}

Haven't had a chance to debug it further.

cheers
