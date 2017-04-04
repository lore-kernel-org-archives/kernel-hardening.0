References: <20170404174727.35478-1-thgarnie@google.com>
 <20170404174727.35478-2-thgarnie@google.com>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <b2b1b4fe-18ea-7643-09c0-312fd8f4b4d8@zytor.com>
Date: Tue, 4 Apr 2017 11:11:03 -0700
MIME-Version: 1.0
In-Reply-To: <20170404174727.35478-2-thgarnie@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
To: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 04/04/17 10:47, Thomas Garnier wrote:
> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for x86.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>  
> +	/*
> +	 * If address limit is not based on user-mode, jump to slow path for
> +	 * additional security checks.
> +	 */
> +	movq	$TASK_SIZE_MAX, %rcx
> +	cmp	%rcx, TASK_addr_limit(%r11)
> +	jnz	1f
> +
>  	LOCKDEP_SYS_EXIT

Nitpick: use jne not jnz when comparing for equality.  Same instruction
but more readable.

	-hpa
