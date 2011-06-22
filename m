Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 20:53:55 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622165355.GB11803@albatros>
References: <20110622095341.GA3353@albatros>
 <1308760683.10423.16.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308760683.10423.16.camel@Joe-Laptop>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 09:38 -0700, Joe Perches wrote:
> On Wed, 2011-06-22 at 13:53 +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().
> 
> []
> 
> > diff --git a/kernel/printk.c b/kernel/printk.c
> []
> > +static void emit_log_char_escaped(char c)
> > +{
> > +	char buffer[8];
> > +	int i, len;
> > +
> > +	if ((c >= ' ' && c < 127) || c == '\n')
> 
> 	if (isprint(c))

#define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)

It slightly differs from what I've written.  It (1) lacks '\n', (2)
passes non-ASCII symbols.  How would non-ASCII symbols look like if
terminal doesn't support it?  (I don't know, merely asking).


But if >159 (the number got from _ctype[]) is not an issue then
(isprint(c) || (c == '\n')) looks really better.

> Why not add this to emit_log_char?

No real need, but someone may want to explicitly bypass the check, it
should use emit_log_char() instead of emit_log_char_escaped().


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
