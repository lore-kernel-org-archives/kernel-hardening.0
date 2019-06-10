Date: Mon, 10 Jun 2019 13:40:52 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/5] x86/vsyscall: Document odd #PF's error code for
 vsyscalls
Message-ID: <201906101340.AE18F49@keescook>
References: <cover.1560198181.git.luto@kernel.org>
 <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 10, 2019 at 01:25:29PM -0700, Andy Lutomirski wrote:
>  tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-

Did this hunk end up in the wrong patch? (It's not mentioned in the
commit log and the next patch has other selftest changes...)

-- 
Kees Cook
