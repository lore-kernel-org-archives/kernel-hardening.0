Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 18 Apr 2016 16:46:05 +0200
From: Joerg Roedel <jroedel@suse.de>
Message-ID: <20160418144605.GF3886@suse.de>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
 <1460757793-59020-4-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460757793-59020-4-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [RFC v1 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: Thomas Garnier <thgarnie@google.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 15, 2016 at 03:03:12PM -0700, Thomas Garnier wrote:
> +#if defined(CONFIG_KASAN)
> +static const unsigned long memory_rand_end = KASAN_SHADOW_START;
> +#elfif defined(CONFIG_X86_ESPFIX64)
> +static const unsigned long memory_rand_end = ESPFIX_BASE_ADDR;
> +#elfif defined(CONFIG_EFI)
> +static const unsigned long memory_rand_end = EFI_VA_START;
> +#else
> +static const unsigned long memory_rand_end = __START_KERNEL_map;
> +#endif

That #elfif is a typo, right?


	Joerg
