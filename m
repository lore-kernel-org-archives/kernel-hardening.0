Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 11 May 2016 08:24:42 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160511062442.GA24803@gmail.com>
References: <1462900755-20005-1-git-send-email-keescook@chromium.org>
 <1462900755-20005-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462900755-20005-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v8 1/4] x86/KASLR: Clarify identity map interface
To: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> +/*
> + * Mapping information structure passed to kernel_ident_mapping_init().
> + * Due to relocation, pointers must be assigned at run time not build time.
> + */
> +static struct x86_mapping_info mapping_info = {
> +	.pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
> +};

> +void initialize_identity_maps(void)
>  {
> +	/* Init mapping_info with run-time function/buffer pointers. */
> +	mapping_info.alloc_pgt_page = alloc_pgt_page;
> +	mapping_info.context = &pgt_data;

Could you please outline the precise failure mode? What gets executed when, which 
pointer gets relocated and which not, and exactly when does it pose a problem, 
etc.

Thanks,

	Ingo
