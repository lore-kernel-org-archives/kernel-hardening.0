Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 23:07:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622190739.GB14351@albatros>
References: <20110622095341.GA3353@albatros>
 <1308760683.10423.16.camel@Joe-Laptop>
 <20110622191022.66135615@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622191022.66135615@lxorguk.ukuu.org.uk>
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Alan,

On Wed, Jun 22, 2011 at 19:10 +0100, Alan Cox wrote:
> If that is set you shouldn't be filtering out unicode, just control codes.

OK.

> Minor other nit is that you might want to allow BEL through and you
> certainly want to allow tab through.

In what situation do you think BEL makes sense in kernel log?  I cannot
image the situation.  Alarms should use KERN_EMERG/KERN_ALERT log level.

> The core code should not be hardcoding policy assumptions about symbol
> sets and ASCII, for an awful lot of consoles today that assumption is
> just plain wrong, for others it makes sense

No problem, I don't insist.

> So with tty maintainer hat on - NAK to the current approach but a good
> idea to do it properly.


The final check should be:

    if (iscntrl(c) && (c != '\n') && (c != '\t'))

Any comments against this variant?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
