Reply-To: kernel-hardening@lists.openwall.com
References: <1462225276-106993-1-git-send-email-thgarnie@google.com>
 <1462225276-106993-4-git-send-email-thgarnie@google.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <5727CE13.6090308@linux.intel.com>
Date: Mon, 2 May 2016 15:00:51 -0700
MIME-Version: 1.0
In-Reply-To: <1462225276-106993-4-git-send-email-thgarnie@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: Thomas Garnier <thgarnie@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/02/2016 02:41 PM, Thomas Garnier wrote:
> -#define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
> +#define __PAGE_OFFSET_BASE      _AC(0xffff880000000000, UL)
> +#ifdef CONFIG_RANDOMIZE_MEMORY
> +#define __PAGE_OFFSET           page_offset_base
> +#else
> +#define __PAGE_OFFSET           __PAGE_OFFSET_BASE
> +#endif /* CONFIG_RANDOMIZE_MEMORY */

Do you have any data about the performance impact of this change?  It's
not necessary to have it to merge something like this, I'm just curious
how bad it is.
