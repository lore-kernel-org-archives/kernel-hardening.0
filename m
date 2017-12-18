References: <1513554812-13014-1-git-send-email-me@tobin.cc>
 <1513554812-13014-2-git-send-email-me@tobin.cc>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <5b86abe3-2c9d-1396-777d-a5a8f19555ef@nbd.name>
Date: Mon, 18 Dec 2017 10:55:34 +0100
MIME-Version: 1.0
In-Reply-To: <1513554812-13014-2-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/3] kallsyms: don't leak address when symbol not found
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-12-18 00:53, Tobin C. Harding wrote:
> Currently if kallsyms_lookup() fails to find the symbol then the address
> is printed. This potentially leaks sensitive information. Instead of
> printing the address we can return an error, giving the calling code the
> option to print the address or print some sanitized message.
> 
> Return error instead of printing address to argument buffer. Leave
> buffer in a sane state.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
I think there should be a way to keep the old behavior for debugging.

- Felix
