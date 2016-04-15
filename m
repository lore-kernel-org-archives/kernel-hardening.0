Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 11:05:15 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415090514.GA9314@gmail.com>
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

> When INIT_SIZE is bigger than VO_INIT_SIZE (uncommon but possible),
> the copied ZO occupies the memory from extract_offset to the end of
> decompression buffer. It overlaps with the soon-to-be-uncompressed kernel
> like this:
> 
>                             |-----compressed kernel image------|
>                             V                                  V
> 0                       extract_offset                      +INIT_SIZE
> |-----------|---------------|-------------------------|--------|
>             |               |                         |        |
>           VO__text      startup_32 of ZO          VO__end    ZO__end
>             ^                                         ^
>             |-------uncompressed kernel image---------|
> 
> When INIT_SIZE is equal to VO_INIT_SIZE (likely) there's still space
> left from end of ZO to the end of decompressing buffer, like below.
> 
>                             |-compressed kernel image-|
>                             V                         V
> 0                       extract_offset                      +INIT_SIZE
> |-----------|---------------|-------------------------|--------|
>             |               |                         |        |
>           VO__text      startup_32 of ZO          ZO__end    VO__end
>             ^                                                  ^
>             |------------uncompressed kernel image-------------|
> 
> To simplify calculations and avoid special cases, it is cleaner to
> always place the compressed kernel image in memory so that ZO__end
> is at the end of the decompression buffer, instead of placing that
> start extract_offset as is currently done.

Btw., it would be nice to also put such a visualization (of the current layout of 
these values) into the code itself.

Thanks,

	Ingo
