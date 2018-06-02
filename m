Subject: Re: Nethammer and kernel network drivers
References: <078f9b83-44d9-e7b2-6608-41a88e23b63e@riseup.net>
 <20180602094327.GA16667@kroah.com>
 <db41b7e2-cf14-51e3-a2f7-12cffc467bdf@riseup.net>
From: procmem <procmem@riseup.net>
Message-ID: <617047d2-8bdd-fc57-d3b1-f1404138c474@riseup.net>
Date: Sat, 2 Jun 2018 17:41:09 +0000
MIME-Version: 1.0
In-Reply-To: <db41b7e2-cf14-51e3-a2f7-12cffc467bdf@riseup.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello. Daniel provided more details on the problematic areas of the
kernel and I quote what he said verbatim:


> We have only found very outdated network drivers using clflush (old
> windows ndis code). On ARM there are many drivers using uncached memory.
> However, we have so far failed to produce enough memory traffic on ARM
> to trigger a bit flip with Nethammer on any ARM device.
> It should be possible though if you can make the ARM device handle
>> =300MBit/s.
> And that's the most plausible scenario.
>
> Anyway, searching for clflush or use of uncached memory is a good idea
> to locate the critical spots.
>
> Intel CAT is (we believe) not used anywhere yet. And we must be careful
> when it gets to the point where we introduce usage of CAT for QoS
> mechanisms.
>
> However, my intuition tells me that most systems are not even vulnerable
> to Rowhammer in the first place. Although the only prevalence studies we
> have suggest otherwise (they find 60-80% are affected).
>
