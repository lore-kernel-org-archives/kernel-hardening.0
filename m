Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 21:48:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622174812.GA13392@albatros>
References: <20110622095341.GA3353@albatros>
 <1308760683.10423.16.camel@Joe-Laptop>
 <20110622165355.GB11803@albatros>
 <1308762841.10423.28.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308762841.10423.28.camel@Joe-Laptop>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 10:14 -0700, Joe Perches wrote:
> On Wed, 2011-06-22 at 20:53 +0400, Vasiliy Kulikov wrote:
> > On Wed, Jun 22, 2011 at 09:38 -0700, Joe Perches wrote:
> > > > +	if ((c >= ' ' && c < 127) || c == '\n')
> > > 	if (isprint(c))
> > #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
> > It slightly differs from what I've written.  It (1) lacks '\n',
> 
> You still need tab,

Correct.

> so:
> 
> if (isprint(c) || isspace(c))

No, it also allows vertical tabs.  Looking into __ctype only ' ', '\n' and
'\t' should be allowed among all _S, so

if (isprint(c) || (c == '\n') || (c == '\t'))


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
