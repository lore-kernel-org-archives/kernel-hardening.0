Date: Thu, 7 Feb 2019 13:17:29 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 02/27] x86: Use symbol name in jump table for PIE
 support
Message-ID: <20190207121729.GE2414@zn.tnic>
References: <20190131192533.34130-1-thgarnie@chromium.org>
 <20190131192533.34130-3-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190131192533.34130-3-thgarnie@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Garnier <thgarnie@google.com>, Nadav Amit <namit@vmware.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 11:24:09AM -0800, Thomas Garnier wrote:
> Replace the %c constraint with %P. The %c is incompatible with PIE
> because it implies an immediate value whereas %P reference a symbol.

How so?

AFAIK, %c requires a constant operand and if %P is used to print a
constant, it simply drops syntax-specific prefixes and does a bare
constant.

I guess that here

https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#x86Operandmodifiers

is not entirely correct as it should not say "If used for a constant"
for %P but say "symbol or constant".

But before/after asm doesn't show any difference. So what gives?

before:
# 39 "./arch/x86/include/asm/jump_label.h" 1
        1:
        .byte 0xe9
         .long .L241 - 2f       #
        2:
        .pushsection __jump_table,  "aw" 
         .balign 8 
        .long 1b - ., .L241 - .         #
         .quad __use_tsc + 1 - .        #,
        .popsection

after:
# 39 "./arch/x86/include/asm/jump_label.h" 1
        1:
        .byte 0xe9
         .long .L241 - 2f       #
        2:
        .pushsection __jump_table,  "aw" 
         .balign 8 
        .long 1b - ., .L241 - .         #
         .quad __use_tsc+1 - .  #
        .popsection 

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
