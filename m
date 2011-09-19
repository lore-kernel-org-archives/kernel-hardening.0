Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2011 08:42:46 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
In-Reply-To: <20110918170512.GA2351@albatros>
Message-ID: <alpine.DEB.2.00.1109190841580.8771@router.home>
References: <20110910164001.GA2342@albatros> <20110910164134.GA2442@albatros> <20110914192744.GC4529@outflux.net> <20110918170512.GA2351@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 18 Sep 2011, Vasiliy Kulikov wrote:

> > Reviewed-by: Kees Cook <kees@ubuntu.com>
>
> Looks like the members of the previous slabinfo discussion don't object
> against the patch now and it got two other Reviewed-by responses.  Can
> you merge it as-is or should I probably convince someone else?

The patch is incomplete. If you want to restrict access to this
information then /sys/kernel/slab needs to have a similar
restriction.
