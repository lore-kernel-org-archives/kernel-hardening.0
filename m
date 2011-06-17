Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Jun 2011 12:59:51 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110617085951.GA7772@openwall.com>
References: <20110617083651.GA5625@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617083651.GA5625@albatros>
Subject: Re: [kernel-hardening] How to temporary change 'current' (task)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Fri, Jun 17, 2011 at 12:36:51PM +0400, Vasiliy Kulikov wrote:
> I wonder whether there is a simple way to temporary switch 'current' to
> another task and then switch it back with minimum side effects?

I strongly recommend that we don't.  Doing so would introduce security
risks similar to what we saw with set_fs(USER_DS).  Even if you
implement everything right and safely, you would set an extremely bad
precedent, encouraging others to do risky things like that.  Under the
security hardening project, we should be moving the kernel away from
those things, not introducing more of them.

So you need to find another way to achieve your objective (or maybe
choose not to achieve it).

...and you meant "temporarily". ;-)

Sorry for not answering your question directly (I don't know the answer),
yet I hope this opinion helps.

Alexander
