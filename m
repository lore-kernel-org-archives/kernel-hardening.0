Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 27 Jun 2011 22:38:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110627183829.GA16033@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627104058.45e93c41@pyx>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2011 at 10:40 +0100, Alan Cox wrote:
> 
> Go back and read what I said originally, and think about it.
> 
> You have to look at the IUTF bit of the relevant console you are logging
> to.

The knowledge of what specific console is relevant is unknown at the
moment of printk().  Do you approve only filtering on klogd side?

> But arbitarily blocking anything non ASCII is going to make a mess in
> anything non American. Even English needs UTF-8.

Sure, I don't propose it anymore (v2 goes without it).


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
