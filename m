Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1467158049.24287.90.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jun 2016 16:54:09 -0700
In-Reply-To: <47053.1467151621@turing-police.cc.vt.edu>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	 <1467150555.24287.77.camel@perches.com>
	 <47053.1467151621@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc
 plugin
To: Valdis.Kletnieks@vt.edu, kernel-hardening@lists.openwall.com
Cc: Emese Revfy <re.emese@gmail.com>, Matt Davis <mattdavis9@gmail.com>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-06-28 at 18:07 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 28 Jun 2016 14:49:15 -0700, Joe Perches said:
> 
> > 
> > Another potentially useful plugin, especially for embedded systems,
> > would be to compress any string literal marked with
> > 
> > 	 __attribute__((format(printf, string-index,)))
> > 
> > and decompress the compressed format on the stack in lib/vsprintf.c
> > vsnprintf just before use.
> Are there enough such strings in the kernel to make it worth the effort?
> I'm assuming that the string literals in printk("some string here") are
> automatically so marked?

Yes, that's the concept.

> Is there a minimum length under which the compression overhead actually
> makes it larger?

No, compression would have to be possible, otherwise it'd
be stored directly.  Compression would use a special
"compressed string" header with a 2 byte overhead and
then stored with no trailing \0.

Something like struct compressed_format_header {
	u8	flag;	/* Must be ASCII STX or "\b" */
	u8	length;
}

Depends on the config of course, but it could reduce total
image size ~50k on an x86-32 defconfig
