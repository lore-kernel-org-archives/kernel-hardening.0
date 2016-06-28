Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 18:14:56 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160628181456.21c1f567271b6f19fac1d886@gmail.com>
In-Reply-To: <20160628125748.GK31744@leverpostej>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628125748.GK31744@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v1 0/2] Introduce the initify gcc
 plugin
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Jun 2016 13:57:49 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> On Tue, Jun 28, 2016 at 01:34:07PM +0200, Emese Revfy wrote:
> > This patch set is based on the "Add support for complex gcc plugins that
> > don't fit in a single file" patch set (git/kees/linux.git#kspp HEAD:
> > e5d4798b284cd192c8b).
> 
> I was hoping to give this a spin on arm/arm64, but I couldn't find the
> prerequisite branch/tag/commit in that tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?id=e5d4798b284cd192c8b
> 
> Where should I be looking?

Sorry, this commit was disappear. You can apply these patches to this tree:
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next.git (initify branch)

-- 
Emese
