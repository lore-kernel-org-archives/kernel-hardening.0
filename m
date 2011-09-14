Reply-To: kernel-hardening@lists.openwall.com
From: Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20110914154229.GA9776@albatros>
References: <20110910164001.GA2342@albatros>
	 <20110910164134.GA2442@albatros> <20110914131630.GA7001@albatros>
	 <1316013505.4478.50.camel@nimitz>  <20110914154229.GA9776@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 11:24:40 -0700
Message-ID: <1316024680.4478.61.camel@nimitz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2011-09-14 at 19:42 +0400, Vasiliy Kulikov wrote:
> > In other words, I dunno.  If we do this in the kernel, can we at least
> > do something like CONFIG_INSECURE to both track these kinds of things
> > and make it easy to get them out of a developer's way?
> 
> What do you think about adding your user to the slabinfo's group or
> chmod it - quite the opposite Ubuntu currently does?  I think it is more
> generic (e.g. you may chmod 0444 to allow all users to get debug
> information or just 0440 and chgrp admin to allow only trusted users to
> do it) and your local policy doesn't touch the kernel.

That obviously _works_.  I'd be happy to ack your patch.  As I said,
it's pretty minimally painful, even to folks who care about slabinfo
like me.

-- Dave
