Date: Sat, 2 Jun 2018 11:43:27 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Nethammer and kernel network drivers
Message-ID: <20180602094327.GA16667@kroah.com>
References: <078f9b83-44d9-e7b2-6608-41a88e23b63e@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <078f9b83-44d9-e7b2-6608-41a88e23b63e@riseup.net>
To: procmem <procmem@riseup.net>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 02, 2018 at 03:46:19AM +0000, procmem wrote:
> Hello. I wanted to get your attention about a new, more serious
> reincarnation of rowhammer called nethammer that doesn't need to execut
> any code on the system like in the past nor does it leave a trace.
> 
> The summary of the paper is that rowhammer can be
> remotely triggered by feeding susceptible* network driver crafted
> traffic. This attack can do all kinds of nasty things such as modifying
> SSL certs on the victim system.
> 
> * Susceptible drivers are those relying on Intel CAT, uncached memory or
> the clflush instruction.
> 
> In absence of hardware mitigations, please identify and disable/fix
> susceptible network drivers to avoid this type of attack. Thanks.

Any hint as to how to identify such drivers?  Have you looked into what
this would entail?

thanks,

greg k-h
