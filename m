Date: Fri, 7 Apr 2017 11:36:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170407093648.k2hl6dswzlz5ashh@hirez.programming.kicks-ass.net>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-9-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490811363-93944-9-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [RFC v2][PATCH 08/11] ARM: Implement
 __arch_rare_write_begin/end()
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 11:16:00AM -0700, Kees Cook wrote:
> +static inline unsigned long __arch_rare_write_end(void)
> +{
> +	BUG_ON(test_domain(DOMAIN_WR_RARE, DOMAIN_CLIENT));
> +	modify_domain(DOMAIN_WR_RARE, DOMAIN_CLIENT);
> +	preempt_enable_no_resched();

NAK

> +	return 0;
> +}
