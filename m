Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 9 Mar 2016 09:32:05 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160309083204.GA30365@gmail.com>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
Subject: [kernel-hardening] Re: [PATCH v3 1/3] SROP Mitigation: Architecture independent code
 for signal cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Scott Bauer <sbauer@eng.utah.edu> wrote:

> This patch adds a per-process secret to the task struct which
> will be used during signal delivery and during a sigreturn.
> Also, logic is added in signal.c to generate, place, extract,
> clear and verify the signal cookie.

>  	/*
> +	 * Canary value for signal frames placed on user stack.
> +	 * This helps mitigate "Signal Return oriented program"
> +	 * exploits in userland.
> +	 */
> +	unsigned long sig_cookie;

Could you please add a high level description in Documentation
that explains the attack and the way how this mitigation code
prevents that kind of attack?

Also, the first changelogs should contain more high level
description as well. For example, what does the 'verification'
of the signal cookie mean, and how does it prevent an SROP
attempt?

All of these patches seem to assume that people reading this code
know what SROP is and how we defend against it - that is not so.

Thanks,

	Ingo
