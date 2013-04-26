Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <517AF5D6.1040800@zytor.com>
Date: Fri, 26 Apr 2013 14:47:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/6] x86: kaslr: move CPU flags out of cpucheck
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/26/2013 12:03 PM, Kees Cook wrote:
> +
> +static inline void cpuid(u32 id, u32 *a, u32 *b, u32 *c, u32 *d)
> +{
> +	/* Handle x86_32 PIC using ebx. */
> +	asm volatile("movl %%ebx, %%edi	\n\t"
> +		     "cpuid		\n\t"
> +		     "xchgl %%edi, %%ebx\n\t"
> +		    : "=a" (*a),
> +		      "=D" (*b),
> +		      "=c" (*c),
> +		      "=d" (*d)
> +		    : "a" (id)
> +	);
> +}

Please don't constrain registers unnecessarily.

You can use "=r" there and let gcc assign whatever free register it pleases.

You can also limit that to only:

#if defined(__i386__) && defined(__PIC__)

	-hpa
