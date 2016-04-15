Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Apr 2016 19:17:03 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
Message-ID: <20160415191703.7a3212de@tukaani.org>
In-Reply-To: <1460672954-32567-7-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
	<1460672954-32567-7-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 06/21] x86, KASLR: Update description for
 decompressor worst case size
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2016-04-14 Kees Cook wrote:
> + * Above analysis is for decompressing gzip compressed kernel only. Up to
> + * now 6 different decompressor are supported all together.

There are six decompressors in Linux now, but the number can change and
the comment become outdated, so I suggest omitting the exact number here.

> And among them
> + * xz stores data in chunks and has maximum chunk of 64K. Hence safety
> + * margin should be updated to cover all decompressors so that we don't
> + * need to deal with each of them separately. Please check
> + * the description in lib/decompressor_xxx.c for specific information.
> + *
> + * extra_bytes = (uncompressed_size >> 12) + 65536 + 128.

lib/decompress_xxx.c, not lib/decompressor_xxx.c.

Referring to those files is problematic because only decompress_unxz.c
talks about the safety margin. The explanation of the safety margin for
gzip is still in misc.c instead of decompress_inflate.c.

I suspect that safety margin calculations haven't been made for other
compressors in Linux, so there is nothing that people could read for
more information. At least such information isn't present in the
comments or commit messages.

For example (and a bit off-topic), there is a possible sign of too small
safety margin in decompress_unlzo.c, where a memcpy call can get
overlapping dest and src buffers:

    /* When the input data is not compressed at all,
     * lzo1x_decompress_safe will fail, so call memcpy()
     * instead */
    if (unlikely(dst_len == src_len))
            memcpy(out_buf, in_buf, src_len);

The overlap can only happen if there's enough incompressible data near
the end of the kernel image. It still works in practice as long as
memcpy works with overlapping buffers for dest < src.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
