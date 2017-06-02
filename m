MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 2 Jun 2017 16:59:56 +0200
Message-ID: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] get_random_bytes returns bad randomness before seeding is complete
To: Stephan Mueller <smueller@chronox.de>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi folks,

This email is about an issue with get_random_bytes(), the CSPRNG used
inside the kernel for generating keys and nonces and whatnot. However,
I will begin with an aside:

/dev/urandom will return bad randomness before its seeded, rather than
blocking, and despite years and years of discussion and bike shedding,
this behavior hasn't changed, and the vast majority of cryptographers
and security experts remain displeased. It _should_ block until its
been seeded for the first time, just like the new getrandom() syscall,
and this important bug fix (which is not a real api break) should be
backported to all stable kernels. (Userspace doesn't even have a
reliable way of determining whether or not it's been seeded!) Yes,
yes, you have arguments for why you're keeping this pathological, but
you're still wrong, and this api is still a bug. Forcing userspace
architectures to work around your bug, as your arguments usually go,
is disquieting. Anyway, that's not what this email is about, but given
that as a backdrop, here's a different-but-related, and perhaps more
petulant, issue...

The problem this email intends to address is this:

void get_random_bytes(void *buf, int nbytes)
{
#if DEBUG_RANDOM_BOOT > 0
       if (!crng_ready())
               printk(KERN_NOTICE "random: %pF get_random_bytes called "
                      "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
#endif
       ...
       extract_crng(buf);

Or, on older kernels:

void get_random_bytes(void *buf, int nbytes)
{
#if DEBUG_RANDOM_BOOT > 0
       if (unlikely(nonblocking_pool.initialized == 0))
               printk(KERN_NOTICE "random: %pF get_random_bytes called "
                      "with %d bits of entropy available\n",
                      (void *) _RET_IP_,
                      nonblocking_pool.entropy_total);
#endif
       trace_get_random_bytes(nbytes, _RET_IP_);
       extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
}

As the printk implies, it's possible for get_random_bytes() to be
called before it's seeded. Why was that helpful printk put behind an
ifdef? I suspect because people would see the lines in their dmesg and
write emails like this one to the list.

I anticipate an argument coming from the never-block /dev/urandom
cartel that goes something along the lines of, "get_random_bytes() is
only called in paths initiated by a syscall; therefore, userspace must
ensure /dev/urandom, which is the same pool as get_random_bytes, has
been properly seeded, before making any syscalls that might lead to
get_random_bytes() being called."

If you've already given up on the general initiative of trying to urge
them to make /dev/urandom block until seeded, then this might seem
like a reasonable argument. If /dev/urandom is broken, it doesn't
matter if get_random_bytes() is broken too, if the required
work-around for one is the same as for the other.

But the premise is flawed. get_random_bytes() can be called before any
syscalls are made, before userspace even has an opportunity to ensure
/dev/urandom is seeded. That's what that printk in the ifdef is all
about. Bad news bears.

Grepping through the source tree for get_random_bytes, I just opened a
few files at random to see what the deal was. Here's one:

drivers/net/ieee802154/at86rf230.c:
static int at86rf230_probe(struct spi_device *spi)
{
...
        get_random_bytes(csma_seed, ARRAY_SIZE(csma_seed));

No clue what this driver is for or if it actually needs good
randomness, but using get_random_bytes in a hardware probe function
can happen prior to userspace's ability to seed.

arch/s390/crypto/prng.c seems to call get_random_bytes on module load,
which can happen pre-userspace, for seeding some kind of RNG of its
own.

net/ipv6/addrconf.c:
static void __ipv6_regen_rndid(struct inet6_dev *idev)
{
regen:
       get_random_bytes(idev->rndid, sizeof(idev->rndid));

This is in the networking stack when bringing up an interface and
assigning randomly assigned v6 addresses. While you might argue that
userspace is required for networking, remember that the kernel
actually has the ability to initiate networking all on its own, before
userspace; the kernel even has its own dhcp client! Yowza. In fact, on
that note:

net/ipv4/ipconfig.c:
static int __init ic_open_devs(void)
{
...
        get_random_bytes(&d->xid, sizeof(__be32));

And so on and so on and so on. If you grep the source as I did, you'll
find there's no shortage of head-scratchers. "Hmmm," you ask yourself,
"could this be called before userspace has ensured that /dev/urandom
is seeded? do we actually _need_ good randomness here, or does it not
matter?" I guess you could try to reason about each and every one of
them -- you might even have those same questions about the silly
examples I pasted above -- but that one-by-one methodology seems
excessively fragile and arduous.

There must have been a developer who thought about this at least once
before, because random.c does have a callback notifier mechanism for
drivers to learn when they can safely call get_random_bytes --
add_random_ready_callback. However, it's only used by ONE driver --
the drbg in crypto/. It's pretty clunky to use, and there's no
reasonable to way replace every single usage of get_random_bytes with
complicated callback infrastructure.

Instead, get_random_bytes simply needs to always return good
randomness. But this is complicated to do inside the kernel. We can't
simply have it block until seeded, because we might not be in process
context and therefore cannot sleep, and introducing a spin for
something that could take a while is untenable too.

There might be some hope, however. Recent kernels now have a very fast
urandom seeding, which moves the seed-ready-point to be much early
during boot. This is still not early enough to just "do nothing", but
early enough that there's room for a good solution:

For builtin modules, we defer all __init calls to after seeding of
drivers that use get_random_bytes. That is to say, rather than using
add_random_ready_callback one by one in an ad-hoc fashion with every
call site that needs good randomness, we just defer loading those
entire modules until an add_random_ready_callback callback. We might
need to explicitly opt-in to this -- by introducing an
`after_urandom_init(..)`, for example, to replace module_init in these
cases -- or perhaps there's a way to automatically detect and defer.
For external modules, it's much easier; we simply have
request_module() block until after seeding is complete. This function
is already a blocking one, so that's not an issue. And it'd ensure
that things like virtual network drivers that are dynamically loaded
and use get_random_bytes, such as vxlan or wireguard, simply block on
`ip link add ...`, which would be the desired behavior.

Alternatively, I'm open to other solutions people might come up with.

Thoughts?

Jason
