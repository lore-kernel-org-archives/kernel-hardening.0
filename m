Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
	<1459281207-24377-2-git-send-email-sbauer@eng.utah.edu>
Date: Thu, 31 Mar 2016 15:25:16 -0500
In-Reply-To: <1459281207-24377-2-git-send-email-sbauer@eng.utah.edu> (Scott
	Bauer's message of "Tue, 29 Mar 2016 13:53:24 -0600")
Message-ID: <87wpoie6oj.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v4 1/4] SROP Mitigation: Architecture independent code for signal cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, wmealing@redhat.com, torvalds@linux-foundation.org, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

Scott Bauer <sbauer@eng.utah.edu> writes:

> This patch adds a per-process secret to the task struct which
> will be used during signal delivery and during a sigreturn.
> Also, logic is added in signal.c to generate, place, extract,
> clear and verify the signal cookie.
>
> Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
> Signed-off-by: Scott Bauer <sbauer@plzdonthack.me>
> Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 60bba7e..1828fb8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1502,6 +1502,13 @@ struct task_struct {
>  	unsigned long stack_canary;
>  #endif
>  	/*
> +	 * Canary value for signal frames placed on user stack.
> +	 * This helps mitigate "Signal Return oriented program"
> +	 * exploits in userland.
> +	 */
> +	unsigned long sig_cookie;


I suspect we want this to be a per-mm attribute rather than a per-thread
attribute.

Otherwise you are breaking anything that uses a N-M threading model.
Which I suspect means that this implementation choice breaks all go
programs on linux.

> +	/*
>  	 * pointers to (original) parent process, youngest child, younger sibling,
>  	 * older sibling, respectively.  (p->father can be replaced with
>  	 * p->real_parent->pid)

Eric
