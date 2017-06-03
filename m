References: <20170603055351.16080-1-matt@nmatt.com>
 <20170603154707.GA19161@openwall.com> <20170603155920.GA25740@kroah.com>
 <20170603162231.GA20590@openwall.com>
From: Corey Henderson <corman@cormander.com>
Message-ID: <a8166866-4ef9-a6ef-a0ee-c4d169a435f1@cormander.com>
Date: Sat, 3 Jun 2017 15:55:56 -0600
MIME-Version: 1.0
In-Reply-To: <20170603162231.GA20590@openwall.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a
 stackable LSM
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6/3/2017 10:22 AM, Solar Designer wrote:
> On Sat, Jun 03, 2017 at 05:59:20PM +0200, Greg KH wrote:
>> But for those systems, and this feature as well, can't a "simple"
>> apparmor policy do the exact same thing?  Also, I'm sure the SELinux can
>> do this as well, but I don't know the config language there as well.
>>
>> So I think this is already a feature that is supported, it just takes a
>> bit more configuration work on the admin.
> 
> Yes, that's "a bit" more effort up to the point where almost(?) no one
> would bother.  Sometimes simple features can reasonably co-exist with
> more general frameworks that could also be used to achieve the effect.
> So I don't view this as a sufficiently good argument against TPE as a
> feature on its own.
> 
> Alexander
> 

For what it's worth, the whole reason I wrote Trusted Path Execution 
(tpe-lkm) as an out-of-tree module was for those who use a targeted 
SELinux policy (or none at all) but still wanted access to some basic 
protection from their own authorized users, without having to maintain 
their own kernel or a written LSM policy.

https://github.com/cormander/tpe-lkm

It uses ftrace to enter the kernel, but the code should port pretty 
easily to a stackable LSM built in-tree.

--
Corey
