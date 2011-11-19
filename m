Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 19 Nov 2011 12:10:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111119081012.GC2675@albatros>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111119075733.GB2675@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119075733.GB2675@albatros>
Subject: [kernel-hardening] Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Glauber Costa <glommer@parallels.com>, Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>, Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 19, 2011 at 11:57 +0400, Vasiliy Kulikov wrote:
> Doing something like hash(cookie1 ++ obj ++ cookie) would leak only the
> equation of two objects, but it can be still dangerous - learn hashes of
> (a) objects created at boot time (their addresses are known) and (b)
> some objects, which allocation scheme is known (i.e. we know
> kmem_cache_alloc() gives us specific addresses with high probability),
> and then compare the hashes against other objects after (a) and (b)
> objects are kfree'd.
> 
> 
> What is the highest timeframe which must maintain the property of unique
> ids?  Is it the whole system lifetime or probably [dump start; dump
> end] and we can change the cookie many times?  Can we probably shorten
> the time even?  Can we ensure that during this timeframe no new kernel
> objects will be created (unrealistic, but would be great)?
> 
> Also, I didn't understand from the quoted text who will use it - only
> the dumper or this interface is exposed to all userspace processes and
> anybody may learn hash(&kern_obj) for any kern_obj he may reference?

Also, if one should have an ability to learn IDs of specific object
types and the set of types is very limited, it's much safer to have one
increasing u64 counter for each created object of one of these types.
The exposed to userspace data will be:

    ID = hash(counter ^ cookie)

    cookie is generated at boot time, once.  counter is a single
    variable, one for all exposed kernel object types.

ID will be unpredictable if hash() is cryptographically secure, and
counter is not duplicated.  So, for each newly created object the ID is
the new random value, which is unique and says nothing to userspace about
either kernel object addresses or the counter itself.

The cost:

1) counter storing for each kernel object exposed through this interface.

2) object creation will be slowed down by hash().


Also, one thought - is it safe to say two kernel objects are the same to
userspace? :)  I don't see anything obviously dangerous, though.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
