Message-ID: <1498069466.13083.20.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 21 Jun 2017 14:24:26 -0400
In-Reply-To: <20170621173201.GA114489@beast>
References: <20170621173201.GA114489@beast>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] binfmt_elf: Use ELF_ET_DYN_BASE only for PIE
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Andy Lutomirski <luto@amacapital.net>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-06-21 at 10:32 -0700, Kees Cook wrote:

> To allow for a lower ELF_ET_DYN_BASE, loaders (ET_DYN without INTERP)
> are loaded into the mmap region, leaving space available for either
> an
> ET_EXEC binary with a fixed location or PIE being loaded into mmap by
> the
> loader. Only PIE programs are loaded offset from ELF_ET_DYN_BASE,
> which
> means architectures can now safely lower their values without risk of
> loaders colliding with their subsequently loaded programs.
> 
> For 64-bit, ELF_ET_DYN_BASE is best set to 4GB to allow runtimes to
> use
> the entire 32-bit address space for 32-bit pointers.
> 
> Thanks to PaX Team, Daniel Micay, and Rik van Riel for inspiration
> and
> suggestions on how to implement this solution.
> 
> Fixes: d1fd836dcf00 ("mm: split ET_DYN ASLR from mmap ASLR")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Rik van Riel <riel@redhat.com>
