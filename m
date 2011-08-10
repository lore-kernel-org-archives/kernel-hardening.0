Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 15:25:22 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810112522.GB30492@openwall.com>
References: <20110605194746.GA6484@albatros> <20110605201025.GA9541@openwall.com> <20110606180806.GA3986@albatros> <20110606183358.GA14711@openwall.com> <20110608172307.GA3380@albatros> <20110612023916.GC14976@openwall.com> <20110724185036.GC3510@albatros> <20110726145016.GA8583@albatros> <20110729174725.GA2339@albatros> <20110804112331.GA2563@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804112331.GA2563@albatros>
Subject: Re: [kernel-hardening] procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Thu, Aug 04, 2011 at 03:23:31PM +0400, Vasiliy Kulikov wrote:
> New version.  Cleanups/fixes here and there.
> 
> It lacks net/ restriction, but IMO it is already complicated enough
> (more than 500 new lines).  Such (relatively) simple thing as
> net_allowed= is an additional care.  I'd achieve at least processes
> restrictions in upstream, after it will come networking.

That's a lot of code already.  I tried reviewing it, but I felt that I
need an English description of its functionality first.  Perhaps you're
preparing one for posting to LKML anyway - can you please post it in
here first?

Thanks,

Alexander
