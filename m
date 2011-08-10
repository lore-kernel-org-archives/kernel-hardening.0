Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 15:22:46 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810112246.GA30492@openwall.com>
References: <20110605201025.GA9541@openwall.com> <20110606180806.GA3986@albatros> <20110606183358.GA14711@openwall.com> <20110608172307.GA3380@albatros> <20110612023916.GC14976@openwall.com> <20110724185036.GC3510@albatros> <20110726145016.GA8583@albatros> <20110729174725.GA2339@albatros> <20110804112331.GA2563@albatros> <20110810100227.GA3507@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810100227.GA3507@albatros>
Subject: Re: [kernel-hardening] procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2011 at 02:02:27PM +0400, Vasiliy Kulikov wrote:
> One question: do we really need gid= option?  The only user I know is
> identd, but does anybody use it nowadays?

identd is mostly obsolete, but I am using gid= with 2.4.x-ow kernels to
let a group of sysadmins see all users' processes and network
connections without having to use su.  In fact, I use it on my very own
computers - again, to let my main desktop user account see everything,
while not letting my pseudo-user accounts (that I use for things such as
a web browser) also see everything (they're not in group proc).

> With gid= I see 2 drawbacks:
> 
> 1) Code becomes worse because of additional permission checks.
> 
> 2) From the upstream's point of view it is very limited and unextendable
> feature.

This feature is precisely what I needed and used for over a decade.
I never needed more flexibility.  Maybe this says something.

> So, I'd go further without gid=, at least for the beginning.

I don't know what works best for upstream acceptance in the beginning,
but I definitely want this feature to get in, and it is a must for Owl.

Thanks,

Alexander
