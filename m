Date: Mon, 18 Dec 2017 17:00:48 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171218060048.GD4627@eros>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
 <87o9mwa9g2.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o9mwa9g2.fsf@concordia.ellerman.id.au>
Subject: Re: [kernel-hardening] [PATCH 0/3] kallsyms: don't leak address
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: kernel-hardening@lists.openwall.com, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 18, 2017 at 04:31:25PM +1100, Michael Ellerman wrote:
> "Tobin C. Harding" <me@tobin.cc> writes:
> 
> > This set plugs a kernel address leak that occurs if kallsyms symbol
> > look up fails. This set was prompted by a leaking address found using
> > scripts/leaking_addresses.pl on a PowerPC machine in the wild.
> 
> Any details on that? I haven't heard about it.

I have an account on a server in USA. I'm not sure how much detail I
should give on the mailing list in case it is sensitive information. I
will email you off list. Responding here for the benefit of the list.

If this is not the correct way to handle this please say so.

thanks,
Tobin.
