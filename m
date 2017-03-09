Date: Thu, 9 Mar 2017 09:42:08 +0100
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20170309084208.ims3ehcnieo7uqew@pd.tnic>
References: <20170309012456.5631-1-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170309012456.5631-1-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
To: Thomas Garnier <thgarnie@google.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?utf-8?B?UmVuw6k=?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andre Przywara <andre.przywara@arm.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 08, 2017 at 05:24:53PM -0800, Thomas Garnier wrote:
> @@ -191,6 +191,22 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  	SYSCALL_METADATA(sname, x, __VA_ARGS__)			\
>  	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>  
> +asmlinkage void verify_pre_usermode_state(void);
> +
> +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> +static inline bool has_user_ds(void) {
> +	bool ret = segment_eq(get_fs(), USER_DS);
> +	// Prevent re-ordering the call

This is not the kernel comments style. Use /* */ instead.

> +	barrier();
> +	return ret;
> +}
> +#else
> +static inline bool has_user_ds(void) {
> +	return false;
> +}
> +#endif

... and then you could slim down the ifdeffery a bit:

static inline bool has_user_ds(void) {
	bool ret = false;

#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
	ret = segment_eq(get_fs(), USER_DS);
	/* Prevent re-ordering the call. */
	barrier();
#endif

	return ret;
}

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
