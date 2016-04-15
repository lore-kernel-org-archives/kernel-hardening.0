Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 10:09:56 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415080956.GE30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
 <1460672954-32567-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460672954-32567-5-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v5 04/21] x86, boot: Move compressed kernel to end of
 decompression buffer
To: Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> 
> This change makes later calculations about where the kernel is located
> easier to reason about. To better understand this change, we must first
> clarify what VO and ZO are. They were introduced in commits by hpa:
> 
> 77d1a49 x86, boot: make symbols from the main vmlinux available
> 37ba7ab x86, boot: make kernel_alignment adjustable; new bzImage fields
> 
> Specifically:
> 
> VO:
> - uncompressed kernel image
> - size: VO__end - VO__text ("VO_INIT_SIZE" define)
> 
> ZO:
> - bootable compressed kernel image (boot/compressed/vmlinux)
> - head text + compressed kernel (VO and relocs table) + decompressor code
> - size: ZO__end - ZO_startup_32 ("ZO_INIT_SIZE" define, though see below)
> 
> The INIT_SIZE definition is used to find the larger of the two image sizes:
> 
>  #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
>  #define VO_INIT_SIZE    (VO__end - VO__text)
>  #if ZO_INIT_SIZE > VO_INIT_SIZE
>  #define INIT_SIZE ZO_INIT_SIZE
>  #else
>  #define INIT_SIZE VO_INIT_SIZE
>  #endif

Please also harmonize all the prefixes, i.e. use VO__/ZO__ everywhere (rename 
things where necessary), instead of this mixed up VO_/ZO_/VO__/ZO__ mess.

Thanks,

	Ingo
