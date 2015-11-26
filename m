Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 26 Nov 2015 01:15:11 +0100
MIME-Version: 1.0
Message-ID: <56564F0F.3158.108D0B78@pageexec.freemail.hu>
In-reply-to: <1448494286-16029-3-git-send-email-keescook@chromium.org>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>, <1448494286-16029-3-git-send-email-keescook@chromium.org>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v2 2/4] introduce post-init read-only memory
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Nov 2015 at 15:31, Kees Cook wrote:

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index c4bd0e2c173c..772c784ba763 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -256,6 +256,7 @@
>   .rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
>    VMLINUX_SYMBOL(__start_rodata) = .;			\
>    *(.rodata) *(.rodata.*)					\
> +		*(.data..ro_after_init)	/* Read only after init */	\
   ^^^^^^^^^^^
looks like it's tabs vs. spaces...

> +/*
> + * __read_only is used to mark things that are read-only after init (i.e.
      ^^^^^^^^^^^
i know you liked the old name but probably this one needs to change too :P

> + * after mark_rodata_ro() has been called). These are effectively read-only,
> + * but may get written to during init, so can't live in .rodata (via "const").
> + */
> +#ifndef __ro_after_init
> +#define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
> +#endif
