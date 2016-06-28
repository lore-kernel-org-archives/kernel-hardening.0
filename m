Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628133520.5baf644afca97c464b9cdb17@gmail.com>
Date: Tue, 28 Jun 2016 23:05:56 +0200
In-Reply-To: <20160628133520.5baf644afca97c464b9cdb17@gmail.com> (Emese
	Revfy's message of "Tue, 28 Jun 2016 13:35:20 +0200")
Message-ID: <87vb0tgh1n.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v1 1/2] Add the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28 2016, Emese Revfy <re.emese@gmail.com> wrote:

> The kernel already has a mechanism to free up code and data memory that
> is only used during kernel or module initialization.
> This plugin will teach the compiler to find more such code and data that
> can be freed after initialization.
> It has two passes. The first one tries to find all functions that
> can be become __init/__exit. The second one moves string constants
> (local variables and function string arguments marked by
> the nocapture attribute) only referenced in __init/__exit functions
> to the __initconst/__exitconst sections.
> It reduces memory usage. This plugin can be useful for embedded systems.

May I suggest, as a followup patch, a debug option/plugin parameter to
put the strings in a section which will not be reaped after init, but
just marked inaccessible, with graceful handling of bad accesses (print
a big fat warning, make the page(s) readable, continue)?

Rasmus
