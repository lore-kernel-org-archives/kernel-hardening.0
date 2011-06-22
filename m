Reply-To: kernel-hardening@lists.openwall.com
From: Joe Perches <joe@perches.com>
In-Reply-To: <20110622165355.GB11803@albatros>
References: <20110622095341.GA3353@albatros>
	 <1308760683.10423.16.camel@Joe-Laptop>  <20110622165355.GB11803@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 10:14:01 -0700
Message-ID: <1308762841.10423.28.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2011-06-22 at 20:53 +0400, Vasiliy Kulikov wrote:
> On Wed, Jun 22, 2011 at 09:38 -0700, Joe Perches wrote:
> > > +	if ((c >= ' ' && c < 127) || c == '\n')
> > 	if (isprint(c))
> #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
> It slightly differs from what I've written.  It (1) lacks '\n',

You still need tab, so:

if (isprint(c) || isspace(c))

> (2) passes non-ASCII symbols.
> How would non-ASCII symbols look like if
> terminal doesn't support it?  (I don't know, merely asking).

I believe most would work fine.

Are there any lp01's or la36's still connected
to a serial console?

I don't know what would happen to a 7 bit
ascii only device.
