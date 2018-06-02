Subject: Re: Nethammer and kernel network drivers
References: <078f9b83-44d9-e7b2-6608-41a88e23b63e@riseup.net>
 <20180602094327.GA16667@kroah.com>
From: procmem <procmem@riseup.net>
Message-ID: <db41b7e2-cf14-51e3-a2f7-12cffc467bdf@riseup.net>
Date: Sat, 2 Jun 2018 13:57:24 +0000
MIME-Version: 1.0
In-Reply-To: <20180602094327.GA16667@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi. I asked one of the authors (Daniel Gruss) to give you more
insightful feedback as its more helpful in the matter.


Greg KH:
> On Sat, Jun 02, 2018 at 03:46:19AM +0000, procmem wrote:
>> Hello. I wanted to get your attention about a new, more serious
>> reincarnation of rowhammer called nethammer that doesn't need to execut
>> any code on the system like in the past nor does it leave a trace.
>>
>> The summary of the paper is that rowhammer can be
>> remotely triggered by feeding susceptible* network driver crafted
>> traffic. This attack can do all kinds of nasty things such as modifying
>> SSL certs on the victim system.
>>
>> * Susceptible drivers are those relying on Intel CAT, uncached memory or
>> the clflush instruction.
>>
>> In absence of hardware mitigations, please identify and disable/fix
>> susceptible network drivers to avoid this type of attack. Thanks.
> 
> Any hint as to how to identify such drivers?  Have you looked into what
> this would entail?
> 
> thanks,
> 
> greg k-h
> 
