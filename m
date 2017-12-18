Date: Mon, 18 Dec 2017 18:43:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171218184324.527ffd0e@gandalf.local.home>
In-Reply-To: <1513636889.2482269.1209330464.6971721E@webmail.messagingengine.com>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
	<1513554812-13014-2-git-send-email-me@tobin.cc>
	<5b86abe3-2c9d-1396-777d-a5a8f19555ef@nbd.name>
	<1513636889.2482269.1209330464.6971721E@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/3] kallsyms: don't leak address when symbol not found
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Felix Fietkau <nbd@nbd.name>, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 19 Dec 2017 09:41:29 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> Current suggestion on list is to remove this function. Do you have a use
> case in mind where debugging will break? We could add a fix to this
> series if so. Otherwise next version will likely drop
> string_is_no_symbol()

What about adding a kernel command line parameter that lets one put
back the old behavior.

"insecure_print_all_symbols" ?

-- Steve
