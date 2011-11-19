Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 19 Nov 2011 11:57:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111119075733.GB2675@albatros>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118110716.c854b4bd.akpm@linux-foundation.org>
Subject: [kernel-hardening] Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Glauber Costa <glommer@parallels.com>, Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>, Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello,

On Fri, Nov 18, 2011 at 11:07 -0800, Andrew Morton wrote:
> On Fri, 18 Nov 2011 13:24:58 +0400
> Pavel Emelyanov <xemul@parallels.com> wrote:
> 
> > >> One of the ways for checking whether two tasks share e.g. an mm_struct is to
> > >> provide some mm_struct ID of a task to its proc file. The best from the
> > >> performance point of view ID is the object address in the kernel, but showing
> > >> them to the userspace is not good for security reasons.
> > >>
> > >> Thus the object address is XOR-ed with a "random" value of the same size and 
> > >> then shown in proc. Providing this poison is not leaked into the userspace then
> > >> ID seem to be safe. The objects for which the IDs are shown are:
> > >>
> > >> * all namespaces living in /proc/pid/ns/
> > >> * open files (shown in /proc/pid/fdinfo/)
> > >> * objects, that can be shared with CLONE_XXX flags (except for namespaces)
> > >> 
> > >> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> > > 
> > > It doesn't *sound* terribly secure.  There might be clever ways in
> > > which userspace can determine the secret mask, dunno.  We should ask
> > > evil-minded security people to review this proposal.
> > 
> > Can you please propose some particular persons we should put in Cc for this thread?
> 
> Perhaps Vasily could review this proposal for us?

Some thoughts:

1) Objects created early in the boot process usually has predictable
addresses.  If an attacker knows the address of one such object, he may
learn the cookie.

2) Lower bits of this cookie don't make sense as object addresses are
aligned.

3) I'm afraid addresses of objects of different types which were
kmalloc'ed still depend on each other.  I.e:

    OBJ1 is type A
    OBJ2 is type B

    OBJ2 = OBJ1 + 0x20

    (OBJ1^COOKIE1) ^ (OBJ2^COOKIE2) =
    = (COOKIE1^COOKIE2) ^ (OBJ1^(OBJ1+0x20)) = (COOKIE1^COOKIE2)^(0x20+Carry_bits)

3) I'm afraid the weakest property of XOR can be used by an attacker:

(OBJ1^COOKIE) ^ (OBJ2^COOKIE) = OBJ1^OBJ2


As was said previously, one could create multiple objects which have
linearly increasing addresses and learn cookie lower bits.


Doing something like hash(cookie1 ++ obj ++ cookie) would leak only the
equation of two objects, but it can be still dangerous - learn hashes of
(a) objects created at boot time (their addresses are known) and (b)
some objects, which allocation scheme is known (i.e. we know
kmem_cache_alloc() gives us specific addresses with high probability),
and then compare the hashes against other objects after (a) and (b)
objects are kfree'd.


What is the highest timeframe which must maintain the property of unique
ids?  Is it the whole system lifetime or probably [dump start; dump
end] and we can change the cookie many times?  Can we probably shorten
the time even?  Can we ensure that during this timeframe no new kernel
objects will be created (unrealistic, but would be great)?

Also, I didn't understand from the quoted text who will use it - only
the dumper or this interface is exposed to all userspace processes and
anybody may learn hash(&kern_obj) for any kern_obj he may reference?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
