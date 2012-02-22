Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4F448C13.1040407@zytor.com>
Date: Tue, 21 Feb 2012 22:32:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1329845435-2313-1-git-send-email-wad@chromium.org> <1329845435-2313-5-git-send-email-wad@chromium.org>
In-Reply-To: <1329845435-2313-5-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v10 05/11] seccomp: add system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 02/21/2012 09:30 AM, Will Drewry wrote:
> +
> +/**
> + * struct seccomp_data - the format the BPF program executes over.
> + * @args: up to 6 system call arguments.  When the calling convention is
> + *        32-bit, the arguments will still be at each args[X] offset.
> + * @instruction_pointer: at the time of the system call.
> + * @arch: indicates system call convention as an AUDIT_ARCH_* value
> + *        as defined in <linux/audit.h>.
> + * @nr: the system call number
> + */
> +struct seccomp_data {
> +	__u64 args[6];
> +	__u64 instruction_pointer;
> +	__u32 arch;
> +	int nr;
> +};
>  

This got flipped around for some reason... that is a problem if we ever
need to extend this to more than 6 arguments (I thought we had at least
one architecture which supported 7 arguments already, but I could just
be delusional.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
