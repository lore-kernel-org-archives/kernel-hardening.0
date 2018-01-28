Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:06:52 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128090652.344ji6p6yapre6ej@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703973427.26578.15693075353773519333.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703973427.26578.15693075353773519333.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 04/12] x86: introduce __uaccess_begin_nospec and ifence
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> For '__get_user' paths, do not allow the kernel to speculate on the
> value of a user controlled pointer. In addition to the 'stac'
> instruction for Supervisor Mode Access Protection, an 'ifence' causes
> the 'access_ok' result to resolve in the pipeline before the cpu might
> take any speculative action on the pointer value.
> 
> Since __get_user is a major kernel interface that deals with user
> controlled pointers, the '__uaccess_begin_nospec' mechanism will prevent
> speculative execution past an 'access_ok' permission check. While
> speculative execution past 'access_ok' is not enough to lead to a kernel
> memory leak, it is a necessary precondition.
> 
> To be clear, '__uaccess_begin_nospec' is addressing a class of potential
> problems near '__get_user' usages.
> 
> Note, that while ifence is used to protect '__get_user', pointer masking
> will be used for 'get_user' since it incorporates a bounds check near
> the usage.
> 
> There are no functional changes in this patch.

The style problems/inconsistencies of the #2 patch are repeated here too.

Also, please split this patch into two patches:

 - #1 introducing ifence() and using it where it was open coded before
 - #2 introducing the _nospec() uaccess variants

> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Andi Kleen <ak@linux.intel.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/include/asm/barrier.h |    4 ++++
>  arch/x86/include/asm/msr.h     |    3 +--
>  arch/x86/include/asm/uaccess.h |    9 +++++++++
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
> index 30419b674ebd..5f11d4c5c862 100644
> --- a/arch/x86/include/asm/barrier.h
> +++ b/arch/x86/include/asm/barrier.h
> @@ -46,6 +46,10 @@ static inline unsigned long array_idx_mask(unsigned long idx, unsigned long sz)
>  	return mask;
>  }
>  
> +/* prevent speculative execution past this barrier */

Please use consistent capitalization in comments.

Thanks,

	Ingo
