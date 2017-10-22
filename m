Date: Sun, 22 Oct 2017 15:11:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20171022131157.GB3165@worktop.lehotels.local>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v5 0/5] Introduce the STACKLEAK feature and a test
 for it
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 22, 2017 at 03:22:48AM +0300, Alexander Popov wrote:
 
> These numbers were obtained for the 4th version of the patch series.
> 
> Size of vmlinux (x86_64_defconfig):
>  file size:
>   - STACKLEAK disabled: 35014784 bytes
>   - STACKLEAK enabled: 35044952 bytes (+0.086%)
>  .text section size (calculated by size utility):
>   - STACKLEAK disabled: 10752983
>   - STACKLEAK enabled: 11062221 (+2.876%)

Why no runtime costs? This should not be hard to measure.

> Further work
> =============
> 
>  - Rewrite erase_kstack() in C (if Ingo Molnar insists).

Aside from legacy, is there any sane reason that stuff is in ASM? That
is, I too will insist it being in C unless you can provide good
arguments on why it needs be asm. All it does is memzero() right? And I
would think architectures already have fairly optimized implementations
of that around.
