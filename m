Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<1467131708.24287.29.camel@perches.com>
	<1467139734.24287.45.camel@perches.com>
Date: Tue, 28 Jun 2016 21:02:54 +0200
In-Reply-To: <1467139734.24287.45.camel@perches.com> (Joe Perches's message of
	"Tue, 28 Jun 2016 11:48:54 -0700")
Message-ID: <87h9cdi1b5.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: Joe Perches <joe@perches.com>
Cc: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28 2016, Joe Perches <joe@perches.com> wrote:

>> What happens to string deduplication when one string
>> is in an init function and the same string is also used
>> in a non-init function in the same compilation unit?
>> 
>> foo.c
>> 
>> __init void initfunc(void)
>> {
>> 	pr_info("%s: I'm here\n", __func__);
>> }
>> 
>> void runtimefunc(void)
>> {
>> 	pr_info("I'm here: %s\n", __func__);
>> }
>> 
>> In what section does the string "I'm here: %s\n" get placed
>> or does it get placed into multiple sections?

It'll get placed in multiple sections by the compiler, and nothing bad
happens. String deduplication is something the linker does to sections
equipped with appropriate flags. So in this case that of course means
that the kernel image itself would be slightly bigger, while the used
data after init would be the same. But I don't think there's a lot of
these cases. (Also, "initfunc" would at least vanish).
