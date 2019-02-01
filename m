MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-21-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-21-thgarnie@chromium.org>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 1 Feb 2019 11:27:22 -0800
Message-ID: <CALCETrVcU_9cczwbfVg6E2cey5B8O9k4j+jYgp0T-CiX9HELtA@mail.gmail.com>
Subject: Re: [PATCH v6 20/27] x86: Support global stack cookie
Content-Type: text/plain; charset="UTF-8"
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Juergen Gross <jgross@suse.com>, Joerg Roedel <jroedel@suse.de>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tim Chen <tim.c.chen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 11:29 AM Thomas Garnier <thgarnie@chromium.org> wrote:
>
> Add an off-by-default configuration option to use a global stack cookie
> instead of the default TLS. This configuration option will only be used
> with PIE binaries.
>
> For kernel stack cookie, the compiler uses the mcmodel=kernel to switch
> between the fs segment to gs segment. A PIE binary does not use
> mcmodel=kernel because it can be relocated anywhere, therefore the
> compiler will default to the fs segment register. This is fixed on the
> latest version of gcc.

I hate all these gcc-sucks-so-we-hack-it-and-change-nasty-semantics
options.  How about just preventing use of both stack protector and
PIE unless the version of gcc in use is new enough.

Also, does -mstack-protector-guard-reg not solve this?  See
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81708.  Or is there
another bug?  Or are you worried about gcc versions that don't have
that feature yet?
