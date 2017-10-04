Date: Wed, 4 Oct 2017 19:15:54 +0200
From: Greg KH <greg@kroah.com>
Message-ID: <20171004171554.GA10047@kroah.com>
References: <1506972007-80614-1-git-send-email-keescook@chromium.org>
 <1506972007-80614-3-git-send-email-keescook@chromium.org>
 <CAK7LNARhoqX0Z--gFEP1xbvcEeg4aDD9rkV0SeUCa3icc1MN8g@mail.gmail.com>
 <20171004151312.GA20938@kroah.com>
 <CAGXu5jKqt=DgMVKS8znL05scbXdxRhgkaf7D5ipYA3Q=csLB5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKqt=DgMVKS8znL05scbXdxRhgkaf7D5ipYA3Q=csLB5A@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 2/3] Makefile: Move stackprotector
 availability out of Kconfig
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 04, 2017 at 09:22:24AM -0700, Kees Cook wrote:
> Do you want me to send this patch, or should we allow it to fail with
> the "missing reference" (which may actually be more expressive...) I
> think the way it is right now is better, but I'm open to either.

I think the current way is fine.

And nice work on the patchset.

greg k-h
