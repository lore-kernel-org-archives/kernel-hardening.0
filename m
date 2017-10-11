Message-ID: <1507694810.3552.45.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 10 Oct 2017 21:06:50 -0700
In-Reply-To: <1507693696-3777-1-git-send-email-me@tobin.cc>
References: <1507693696-3777-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-10-11 at 14:48 +1100, Tobin C. Harding wrote:
> Currently there are many places in the kernel where addresses are being
> printed using an unadorned %p. Kernel pointers should be printed using
> %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> gives attackers sensitive information about the kernel layout in memory.
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1591,6 +1591,35 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
>  	return widen_string(buf, buf - buf_start, end, spec);
>  }
>  
> +static long get_random_odd_long(void)
> +{
> +	long val = 0;
> +
> +	while((val & 1) == 0) {
> +		val = get_random_long();
> +	}
> +
> +	return val;
> +}

Perhaps

static long get_random_odd_long(void)
{
	return get_random_long() | 1L;
}
