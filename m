Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2011 20:55:41 +0100
From: Alan Cox <alan@linux.intel.com>
Message-ID: <20110919205541.1c44f1a3@bob.linux.org.uk>
In-Reply-To: <14082.1316461507@turing-police.cc.vt.edu>
References: <20110910164001.GA2342@albatros>
	<20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
	<CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
	<20110919144657.GA5928@albatros>
	<14082.1316461507@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
To: Valdis.Kletnieks@vt.edu
Cc: Vasiliy Kulikov <segoon@openwall.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Jesper Juhl <jj@chaosbits.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 19 Sep 2011 15:45:07 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Mon, 19 Sep 2011 18:46:58 +0400, Vasiliy Kulikov said:
> 
> > One note: only to _kernel_ developers.  It means it is a strictly
> > debugging feature, which shouldn't be enabled in the production
> > systems.
> 
> Until somebody at vendor support says "What does 'cat /proc/slabinfo'
> say?"
> 
> Anybody who thinks that debugging tools should be totally disabled on
> "production" systems probably hasn't spent enough time actually
> running production systems.

Agreed - far better it is simply set root only. At that point if you
can read it you've bypassed DAC anyway so either you already control
the box or something like SELinux or SMACK is in the way in which case
*it* can manage extra policy just fine.
