MIME-Version: 1.0
References: <20190424203408.GA11386@beast> <20190424205117.GA5291@brain-police>
In-Reply-To: <20190424205117.GA5291@brain-police>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 24 Apr 2019 13:54:24 -0700
Message-ID: <CAGXu5jJzzku0xjJAyD3T5SDeeoxVtA51wfHPGPrejjn_tNfJ4w@mail.gmail.com>
Subject: Re: [PATCH v2] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
Content-Type: text/plain; charset="UTF-8"
To: Will Deacon <will.deacon@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Jason Gunthorpe <jgg@mellanox.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 24, 2019 at 1:51 PM Will Deacon <will.deacon@arm.com> wrote:
> Don't you need to hack fs/compat_binfmt_elf.c to pick this up, or am I
> missing some trick? Should just be something like below.
>
> Will
>
> --->8
>
> diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
> index 15f6e96b3bd9..694bc3ee77eb 100644
> --- a/fs/compat_binfmt_elf.c
> +++ b/fs/compat_binfmt_elf.c
> @@ -116,6 +116,11 @@
>  #define        arch_setup_additional_pages compat_arch_setup_additional_pages
>  #endif
>
> +#ifdef compat_elf_read_implies_exec
> +#undef elf_read_implies_exec
> +#define elf_read_implies_exec compat_elf_read_implies_exec
> +#endif
> +
>  /*
>   * Rename a few of the symbols that binfmt_elf.c will define.
>   * These are all local so the names don't really matter, but it

Argh. I thought I already saw stuff like this somewhere, but I think I
must have been looking at some other compat silliness. I'll fix this
and split up the series...

-- 
Kees Cook
