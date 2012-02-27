Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 27 Feb 2012 18:11:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120227171132.GB10608@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org> <1330140111-17201-7-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330140111-17201-7-git-send-email-wad@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v11 07/12] seccomp: add SECCOMP_RET_ERRNO
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 02/24, Will Drewry wrote:
>
>  static u32 seccomp_run_filters(int syscall)
>  {
>  	struct seccomp_filter *f;
> -	u32 ret = SECCOMP_RET_KILL;
>  	static const struct bpf_load_fn fns = {
>  		bpf_load,
>  		sizeof(struct seccomp_data),
>  	};
> +	u32 ret = SECCOMP_RET_ALLOW;
>  	const void *sc_ptr = (const void *)(uintptr_t)syscall;
>  
> +	/* Ensure unexpected behavior doesn't result in failing open. */
> +	if (unlikely(current->seccomp.filter == NULL))
> +		ret = SECCOMP_RET_KILL;

Is "seccomp.filter == NULL" really possible?

Oleg.
