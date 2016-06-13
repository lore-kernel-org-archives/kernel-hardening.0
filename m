Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 13 Jun 2016 08:52:10 +0100
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Message-ID: <20160613075210.GB2031@sudip-tp>
References: <20160611161212.GA29370@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160611161212.GA29370@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: disable under COMPILE_TEST
To: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Emese Revfy <re.emese@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 11, 2016 at 09:12:12AM -0700, Kees Cook wrote:
> Since adding the gcc plugin development headers is required for the
> gcc plugin support, we should ease into this new kernel build dependency
> more slowly. For now, disable the gcc plugins under COMPILE_TEST so that
> all*config builds will skip it.

But don't you think that people who are actually building the kernel
with allmodconfig or allyesconfig and/or with COMPILE_TEST enabled are
just doing that to build test the kernel. Atleast for me, when I am
testing i will always do allmodconfig but when I am building which is
to be deployed somewhere then I am building with a particular config.

Regards
Sudip
