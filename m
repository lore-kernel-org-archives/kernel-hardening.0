Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:14:37 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128091437.4lbll5bev7mgdpug@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703973427.26578.15693075353773519333.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703973427.26578.15693075353773519333.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 04/12] x86: introduce __uaccess_begin_nospec and ifence
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -124,6 +124,11 @@ extern int __get_user_bad(void);
>  
>  #define __uaccess_begin() stac()
>  #define __uaccess_end()   clac()
> +#define __uaccess_begin_nospec()	\
> +({					\
> +	stac();				\
> +	ifence();			\
> +})

BTW., wouldn't it be better to switch the barrier order here, i.e. to do:

	ifence();			\
	stac();				\

?

The reason is that stac()/clac() is usually paired, so there's a chance with short 
sequences that it would resolve with 'no externally visible changes to flags'.

Also, there's many cases where flags are modified _inside_ the STAC/CLAC section, 
so grouping them together inside a speculation atom could be beneficial.

The flip side is that if the MFENCE stalls the STAC that is ahead of it could be 
processed for 'free' - while it's always post barrier with my suggestion.

But in any case it would be nice to see a discussion of this aspect in the 
changelog, even if the patch does not change.

Thanks,

	Ingo
