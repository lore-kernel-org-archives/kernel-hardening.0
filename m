Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 29 Jun 2016 20:28:25 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160629202825.a158189c63860099c076e911@gmail.com>
In-Reply-To: <20160629175222.GA8517@leverpostej>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628125748.GK31744@leverpostej>
	<20160628181456.21c1f567271b6f19fac1d886@gmail.com>
	<CAGXu5jLa20aqna_RW6Egd7Y1Wd4yajkZpj8rP5BWWZyUkfWbKQ@mail.gmail.com>
	<20160629082137.GA16387@leverpostej>
	<20160629175222.GA8517@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v1 0/2] Introduce the initify gcc
 plugin
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 Jun 2016 18:52:27 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> On Wed, Jun 29, 2016 at 09:21:37AM +0100, Mark Rutland wrote:
> > On Tue, Jun 28, 2016 at 01:46:04PM -0700, Kees Cook wrote:
> > > On Tue, Jun 28, 2016 at 9:14 AM, Emese Revfy <re.emese@gmail.com> wrote:
> > > > On Tue, 28 Jun 2016 13:57:49 +0100
> > > > Mark Rutland <mark.rutland@arm.com> wrote:
> > > >
> > > >> On Tue, Jun 28, 2016 at 01:34:07PM +0200, Emese Revfy wrote:
> > > >> > This patch set is based on the "Add support for complex gcc plugins that
> > > >> > don't fit in a single file" patch set (git/kees/linux.git#kspp HEAD:
> > > >> > e5d4798b284cd192c8b).
> > > >>
> > > >> I was hoping to give this a spin on arm/arm64, but I couldn't find the
> > > >> prerequisite branch/tag/commit in that tree:
> > > >>
> > > >> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?id=e5d4798b284cd192c8b
> > > >>
> > > >> Where should I be looking?
> > > >
> > > > Sorry, this commit was disappear. You can apply these patches to this tree:
> > > > https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next.git (initify branch)
>
> g++: fatal error: no input files
> compilation terminated.
> make[1]: *** [scripts/gcc-plugins/initify_plugin.so] Error 4
> make: *** [gcc-plugins] Error 2

Hi,

There are some missing patches from Kees tree that's why I suggested my tree above.

-- 
Emese
