Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 20 Jan 2016 21:26:38 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20160120212638.7988f51f@lxorguk.ukuu.org.uk>
In-Reply-To: <20160120201120.GA11861@pc.thejh.net>
References: <20160119112812.GA10818@mwanda>
	<87ziw14263.fsf@x220.int.ebiederm.org>
	<20160120201120.GA11861@pc.thejh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: Jann Horn <jann@thejh.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> I know of at least two projects that enter user namespaces without the
> necessary care, one of them is LXC.
> 
> 
> > There is room for improvement in this area but I don't see how this
> > qualifies as a CVE.
> 
> I think I agree with that.

If there are projects that screw it up then there should be a CVE - it
just needs someone to update the CVE to indicate where the actual flaw is.

Alan
