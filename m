Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 22 Jun 2011 19:10:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110622191022.66135615@lxorguk.ukuu.org.uk>
In-Reply-To: <1308760683.10423.16.camel@Joe-Laptop>
References: <20110622095341.GA3353@albatros>
	<1308760683.10423.16.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Joe Perches <joe@perches.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 22 Jun 2011 09:38:03 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2011-06-22 at 13:53 +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().

I think this is fundamentally wrong.

It makes sense for some interfaces but not others and arbitarily doing it
makes a nasty mess of anything like file name printing in non English
languages.

The right way to do this IMHO is for the console device itself to have a
filter function, the default would be the 0x20-0x7E but for example with
any console which has an accompanying tty device the right behaviour
depends upon the port UTF8 flag (IUTF8).

If that is set you shouldn't be filtering out unicode, just control codes.

Minor other nit is that you might want to allow BEL through and you
certainly want to allow tab through.

The core code should not be hardcoding policy assumptions about symbol
sets and ASCII, for an awful lot of consoles today that assumption is
just plain wrong, for others it makes sense

So with tty maintainer hat on - NAK to the current approach but a good
idea to do it properly.
