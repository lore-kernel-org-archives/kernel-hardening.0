Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2011 17:34:09 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110810133409.GA31342@openwall.com>
References: <20110606180806.GA3986@albatros> <20110606183358.GA14711@openwall.com> <20110608172307.GA3380@albatros> <20110612023916.GC14976@openwall.com> <20110724185036.GC3510@albatros> <20110726145016.GA8583@albatros> <20110729174725.GA2339@albatros> <20110804112331.GA2563@albatros> <20110810112522.GB30492@openwall.com> <20110810120439.GA7008@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810120439.GA7008@albatros>
Subject: Re: [kernel-hardening] procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2011 at 04:04:39PM +0400, Vasiliy Kulikov wrote:
> On Wed, Aug 10, 2011 at 15:25 +0400, Solar Designer wrote:
> > That's a lot of code already.
> 
> Yes, so I'd try to get comments from net-less and gid-less patch first.
> Probably the whole way of permissions handling would be ridicules for
> kernel forlk :)

I feel that you may have treated Andrew Morton's suggestion too
seriously.  I think he was hoping for something not only more general,
but also simple.

With your invasive changes, even checking for (lack of) potential new
vulnerabilities (such as lack of ptrace check where it previously existed
and was needed) feels non-trivial.  Or maybe I just did not look closely
enough.

Perhaps run this by LKML as RFC and see what they think?  And be willing
to revert to your old approach, with more hard-coding, now that you have
this arguably overly complicated alternative.  Maybe it will convince
Andrew Morton that something simpler and less flexible would be better.

Thanks,

Alexander
