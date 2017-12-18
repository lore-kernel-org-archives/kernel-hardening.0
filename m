Message-Id: <1513636889.2482269.1209330464.6971721E@webmail.messagingengine.com>
From: "Tobin C. Harding" <me@tobin.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
Date: Tue, 19 Dec 2017 09:41:29 +1100
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
 <1513554812-13014-2-git-send-email-me@tobin.cc>
 <5b86abe3-2c9d-1396-777d-a5a8f19555ef@nbd.name>
In-Reply-To: <5b86abe3-2c9d-1396-777d-a5a8f19555ef@nbd.name>
Subject: [kernel-hardening] Re: [PATCH 1/3] kallsyms: don't leak address when symbol not found
To: Felix Fietkau <nbd@nbd.name>, kernel-hardening@lists.openwall.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 18, 2017, at 20:55, Felix Fietkau wrote:
> On 2017-12-18 00:53, Tobin C. Harding wrote:
> > Currently if kallsyms_lookup() fails to find the symbol then the address
> > is printed. This potentially leaks sensitive information. Instead of
> > printing the address we can return an error, giving the calling code the
> > option to print the address or print some sanitized message.
> > 
> > Return error instead of printing address to argument buffer. Leave
> > buffer in a sane state.
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> I think there should be a way to keep the old behavior for debugging.

That was the intended use of

EXPORT_SYMBOL(string_is_no_symbol);

in patch 2 of this series. Then if debugging behaviour is adversely
effected one could use string_is_no_symbol() on a case by case basis to
add back in the original behaviour. 

Current suggestion on list is to remove this function. Do you have a use
case in mind where debugging will break? We could add a fix to this
series if so. Otherwise next version will likely drop
string_is_no_symbol()

thanks,
Tobin. 
