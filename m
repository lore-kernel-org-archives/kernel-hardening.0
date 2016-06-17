Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Jun 2016 22:30:45 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160617203045.GB3842@pd.tnic>
References: <cover.1466192946.git.luto@kernel.org>
 <3336bb02792d56c49d18e2f7a435fd194a4a22e4.1466192946.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3336bb02792d56c49d18e2f7a435fd194a4a22e4.1466192946.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v2 03/13] x86/cpa: Warn if kernel_unmap_pages_in_pgd is
 used inappropriately
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2016 at 01:00:39PM -0700, Andy Lutomirski wrote:
> It's currently only used in the EFI code, which is safe AFAICT.

"It is basically useful for a pagetable hierarchy which is not init_mm."

> Warn if anyone tries to use it on the normal kernel pgd.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/mm/pageattr.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 6a8026918bf6..e9b9c5cedbb8 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -1996,6 +1996,9 @@ out:
>  void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
>  			       unsigned numpages)
>  {
> +	/* Unmapping kernel entries from init_mm's pgd is not allowed. */
> +	WARN_ON(root == init_mm.pgd);

We can also return and not do the unmapping:

	if (WARN_ON(root == init_mm.pgd))
		return;

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
