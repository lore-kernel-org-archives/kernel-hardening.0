Date: Fri, 24 Mar 2017 09:14:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20170323203419.GA62859@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170323203419.GA62859@beast>
Message-Id: <20170324081450.GA5891@osiris>
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add bad USER_DS test
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 23, 2017 at 01:34:19PM -0700, Kees Cook wrote:
> This adds CORRUPT_USER_DS to check that the get_fs() test on syscall return
> still sees USER_DS during the new VERIFY_PRE_USERMODE_STATE checks.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

...

> +void lkdtm_CORRUPT_USER_DS(void)
> +{
> +	/*
> +	 * Test that USER_DS has been set correctly on exiting a syscall.
> +	 * Since setting this higher than USER_DS (TASK_SIZE) would introduce
> +	 * an exploitable condition, we lower it instead, since that should
> +	 * not create as large a problem on an unprotected system.
> +	 */
> +	mm_segment_t lowfs;
> +#ifdef MAKE_MM_SEG
> +	lowfs = MAKE_MM_SEG(TASK_SIZE - PAGE_SIZE);
> +#else
> +	lowfs = TASK_SIZE - PAGE_SIZE;
> +#endif
> +
> +	pr_info("setting bad task size limit\n");
> +	set_fs(lowfs);
> +}

This won't work on architectures where the set_fs() argument does not
contain an address but an address space identifier. This is true e.g. for
s390 and as far as I know also for sparc.
On s390 we have complete distinct address spaces for kernel and user space
that each start at address zero.
