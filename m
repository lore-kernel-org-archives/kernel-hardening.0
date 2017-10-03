Date: Tue, 3 Oct 2017 11:04:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171003100433.GA4931@leverpostej>
References: <1506972007-80614-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506972007-80614-1-git-send-email-keescook@chromium.org>
Subject: Re: [kernel-hardening] [PATCH 0/3] Makefile: Introduce
 CONFIG_CC_STACKPROTECTOR_AUTO
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Laura Abbott <labbott@redhat.com>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Mon, Oct 02, 2017 at 12:20:04PM -0700, Kees Cook wrote:
> As described in the final patch:
> 
> Nearly all modern compilers support a stack-protector option, and nearly
> all modern distributions enable the kernel stack-protector, so enabling
> this by default in kernel builds would make sense. However, Kconfig does
> not have knowledge of available compiler features, so it isn't safe to
> force on, as this would unconditionally break builds for the compilers
> or architectures that don't have support. Instead, this introduces a new
> option, CONFIG_CC_STACKPROTECTOR_AUTO, which attempts to discover the best
> possible stack-protector available, and will allow builds to proceed even
> if the compiler doesn't support any stack-protector.
> 
> This option is made the default so that kernels built with modern
> compilers will be protected-by-default against stack buffer overflows,
> avoiding things like the recent BlueBorne attack. Selection of a specific
> stack-protector option remains available, including disabling it.

I gave this a spin atop of v4.14-rc3 with a few arm64 toolchains I had
installed:

* Linaro 17.08 GCC 7.1    // strong
* Linaro 17.05 GCC 6.1    // strong
* Linaro 15.08 GCC 5.1    // strong
* Linaro 14.09 GCC 4.9    // strong
* Linaro 13.06 GCC 4.8    // none
* Linaro 13.01 GCC 4.7    // none

AFAICT, the detection is correct, and arm64 toolchains only gained stack
protector support in GCC 4.9. I manually tested GCC 4.8 and 4.7, and
got:

  warning: -fstack-protector not supported for this target [enabled by default]

... so that looks good to me.

One thing I noticed was taht even when the build system detects no
support for stack-protector, it still passes -DCONFIG_CC_STACKPROTECTOR
to the toolchain. Is that expected?

Thanks,
Mark.
