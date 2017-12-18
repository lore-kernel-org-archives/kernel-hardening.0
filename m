From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <1513554812-13014-1-git-send-email-me@tobin.cc>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
Date: Mon, 18 Dec 2017 16:31:25 +1100
Message-ID: <87o9mwa9g2.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH 0/3] kallsyms: don't leak address
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

"Tobin C. Harding" <me@tobin.cc> writes:

> This set plugs a kernel address leak that occurs if kallsyms symbol
> look up fails. This set was prompted by a leaking address found using
> scripts/leaking_addresses.pl on a PowerPC machine in the wild.

Any details on that? I haven't heard about it.

cheers
