Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1467150555.24287.77.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jun 2016 14:49:15 -0700
In-Reply-To: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Matt Davis <mattdavis9@gmail.com>
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-06-28 at 13:34 +0200, Emese Revfy wrote:
> I would like to introduce the initify gcc plugin. The kernel already has
> a mechanism to free up code and data memory that is only used during kernel
> or module initialization.
> This plugin will teach the compiler to find more such code and data that
> can be freed after initialization. It reduces memory usage.
> The initify gcc plugin can be useful for embedded systems.

Another potentially useful plugin, especially for embedded systems,
would be to compress any string literal marked with

	 __attribute__((format(printf, string-index,)))

and decompress the compressed format on the stack in lib/vsprintf.c
vsnprintf just before use.

I've started to experiment with that.
