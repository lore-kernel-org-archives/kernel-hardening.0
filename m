Date: Mon, 14 Aug 2017 21:38:34 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170815033834.2qbjj2of62udqyz3@smitten>
References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing
 the kernel stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 12, 2017 at 09:17:51PM +0300, Alexander Popov wrote:
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used track_stack(void)
> +{
> +	unsigned long sp = (unsigned long)&sp;
> +
> +	if (sp < current->thread.lowest_stack &&
> +	    sp >= (unsigned long)task_stack_page(current) +
> +					2 * sizeof(unsigned long)) {
> +		current->thread.lowest_stack = sp;
> +	}
> +
> +	if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))

I think this check is wrong, the lhs should be
(sp & (THREAD_SIZE - 1)). Otherwise, we just check that the upper bits
of the stack are < THREAD_SIZE / 16, which they never will be.

Tycho
