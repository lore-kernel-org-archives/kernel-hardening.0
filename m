Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 28 Nov 2016 11:56:17 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Now when we are almost over the huge set of conversions, I would like to ma=
ke a summary of issues that we see to be very common.
So, that we can then decide how to address them.

First, about the types.=20
We do have a number of instances of atomic_long_t used as refcounters, see =
below:

linux/perf_event.h:
struct perf_event {
...
 atomic_long_t refcount;
 ...
}

kernel/audit_tree.c:
struct audit_chunk {
...
    atomic_long_t refs;
..
}

kernel/acct.c:
struct bsd_acct_struct {
...
    atomic_long_t       count;
...
};

linux/fs.h:
struct file {
    ...
    atomic_long_t       f_count;
    ...
}

block/blk-ioc.c:
struct io_context {
    atomic_long_t refcount;
    ...
}

There might be more since we are not 100% finished, but at least struct fil=
e is pretty important one that we should be covering.=20

And yes, we *do* have at least one instance (again not 100% finished, more =
might show up) of atomic64_t used as refcounter:

arch/powerpc/mm/mmu_context_iommu.c:
struct mm_iommu_table_group_mem_t {
...
    atomic64_t mapped;
...
}

Next with regards to API. Networking code surely wins the competitions of g=
iving the most trouble.
The biggest overall issue seem to be in fact that freeing the object happen=
s not when refcount is zero, but when it is -1,
which is obviously impossible to implement with current API that only retur=
ns unsigned int.=20

Most common constructions that are hard to fit into current API are:

-    if (atomic_cmpxchg(&cur->refcnt, 1, 0) =3D=3D 1) {...} (typical for ne=
tworking code)
-    if (atomic_cmpxchg(&p->refcnt, 0, -1) =3D=3D 0) {..} (typical for netw=
orking code)
-    if (atomic_add_unless(&inode->i_count, -1, 1)) (typical for fs and oth=
er code)

Also, refcount_add() seems to be needed in number of places since it looks =
like refcounts in some cases are increased by two or by some constant.=20
Luckily we haven't seen a need a sub().

The following functions are also needed quite commonly:
refcount_inc_return()
refcount_dec_return()

There is also a need for smth like refcount_dec_if_one(), i.e. decrement on=
ly if counter equals one and then do some housekeeping.=20

I also saw one use of this from net/ipv4/udp.c:
    if (!sk || !atomic_inc_not_zero_hint(&sk->sk_refcnt, 2))

Lastly as I mentioned previously, almost half of invocations of dec() in th=
e code is plain atomic_dec() without any if statements and any checks on wh=
at happens as a result of dec().=20
Peter previously suggested to turn them into WARN_ON(refcount_dec_and_test(=
)), but looking in the code, it is not really clear what would this help to=
 achieve?=20
It is clear that in that places the caller explicitly doesn't care about ho=
w the dec() goes and what is the end result....

Best Regards,
Elena.
