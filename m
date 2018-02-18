Date: Sun, 18 Feb 2018 23:13:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
Message-ID: <20180218221352.GA6651@ravnborg.org>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Ulf Magnusson <ulfalizer@gmail.com>, Michal Marek <michal.lkml@markovi.net>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>, "H. Peter Anvin" <hpa@zytor.com>, user-mode-linux-devel@lists.sourceforge.net, Yoshinori Sato <ysato@users.sourceforge.jp>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>, user-mode-linux-user@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>, Michael Ellerman <mpe@ellerman.id.au>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Masahiro.

On Sat, Feb 17, 2018 at 03:38:28AM +0900, Masahiro Yamada wrote:
> I brushed up the implementation in this version.
> 
> In the previous RFC, CC_HAS_ was described by using 'option shell=',
> like this:
> 
> config CC_HAS_STACKPROTECTOR
>         bool
>         option shell="$CC -Werror -fstack-protector -c -x c /dev/null"
> 
> After I thought a bit more, the following syntax is more grammatical,
> and flexible.
> 
> config CC_HAS_STACKPROTECTOR
>         bool
>         default $(shell $CC -Werror -fstack-protector -c -x c /dev/null)

Looks good - but maybe we should go one step further.

So we in the syntax explicit handles:
- shell commands
- other commands, defined as strings
- environment variables
- config variables

Each case is explicit - so the reader is not confused what is used when.

$(shell foo)	- output of the shell command foo. Uses $SHELL as the shell.
		  May include optional paramters.
		  foo may be a config variable referenced using ${} or a config variable prefixed with $
		Example:

		config BUILD_DIR
			string
			default $(shell cd ${objtree}; pwd)

$(call bar)	- output of the bar command that may take optional parameters.
		  bar may be a text string, a config variable or an environment variable
		   The definition of bar may reference the parameters using $(1), $(2)
		   In this context a config variable needs to be prefixed with $

		Example:

		config reverse
			string
			default $(2) $(1)

		config NEW_ORDER
			string
			$(call $reverse, A, B)	# Will assign REVERSE the value "B A"


		Example2:

		config CC_OPTION
			string
			default $(shell ${srctree}/scripts/cc-option ${CC} $(1) $(2))

		config CC_OPTIMIZE
			string
			$(call $CC_OPTION, -Oz, -Os)


${FOO}		- environment variable

The above is inspired by how make implement similar functionality.

I'm not happy that we in one context can reference CONFIG variables
directly, but inside the $(call ...) and $(shell ...) needs the $ prefix.
But I could not come up with something un-ambigious where this could be avoided.

The above proposal include the functionality of the macro stuff proposed in this patch-set.
But with a simpler syntax and we keep all the other kconfig logic (depends on etc) - so
users will not be limited in their creativity.

> Current limitations:
> 
> Dependency on outside scripts.
> Inter-option dependency:
> Functions are evaluated statically:

Same limitations exists with the syntax suggested above.

	Sam
