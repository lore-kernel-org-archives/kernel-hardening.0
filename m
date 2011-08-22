Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 22 Aug 2011 13:53:54 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110822095354.GA13836@openwall.com>
References: <20110817191550.GA18554@albatros> <20110820142723.GA5708@albatros> <20110820163120.GA7256@openwall.com> <20110822092429.GA29597@albatros> <20110822093819.GA13665@openwall.com> <20110822094558.GA2620@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822094558.GA2620@albatros>
Subject: Re: [kernel-hardening] kmalloc() nofail allocations
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Aug 22, 2011 at 01:45:58PM +0400, Vasiliy Kulikov wrote:
> On Mon, Aug 22, 2011 at 13:38 +0400, Solar Designer wrote:
> > On Mon, Aug 22, 2011 at 01:24:29PM +0400, Vasiliy Kulikov wrote:
> > > Major problem with the idea in general:
> > ...
> > > Unlikely, but fully possible case - we want some memory and the OOM killer
> > > kills us for our wish.
> > 
> > How/why is this a major problem with the idea in general?  I am probably
> > missing something.
> 
> Initially I wanted to "wrap" kmalloc calls, which cannot fail in any
> case.  This would not change any mm code, but the caller (its
> expectation).
> 
> Now I see that it's impossible without any mm code changes.  It needs at
> least __GFP_NOFAIL flag addition, which is explicitly marked as "no new
> uses".  Such kmalloc_nofail() wouldn't differ much from kmalloc(size,
> flags | __GFP_NOFAIL).

Thanks for the explanation.

However, is there any difference for the caller between kmalloc()
looping until success (and thus only returning on success) and it
OOM-killing the current process (and thus also only returning on
success)?  Or does this question somehow not apply to the problem you
discovered?

Alexander
