Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 22:29:56 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160628222956.8142716b310953fa6b1af1c4@gmail.com>
In-Reply-To: <87h9cdi1b5.fsf@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<1467131708.24287.29.camel@perches.com>
	<1467139734.24287.45.camel@perches.com>
	<87h9cdi1b5.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>, kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Jun 2016 21:02:54 +0200
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> It'll get placed in multiple sections by the compiler, and nothing bad
> happens. String deduplication is something the linker does to sections
> equipped with appropriate flags. So in this case that of course means

Note that I didn't add such flags to my sections yet, but I have it on my todo list.

> that the kernel image itself would be slightly bigger, while the used
> data after init would be the same. But I don't think there's a lot of
> these cases. (Also, "initfunc" would at least vanish).

-- 
Emese
