Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
References: <20161209183659.25727-1-Jason@zx2c4.com> <CAOMGZ=HMTZhBOh0jTBT4cyMuK5s-D51FFUtWUWyMV7VX0U2L0w@mail.gmail.com>
In-Reply-To: <CAOMGZ=HMTZhBOh0jTBT4cyMuK5s-D51FFUtWUWyMV7VX0U2L0w@mail.gmail.com>
From: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Date: Sat, 10 Dec 2016 18:13:01 +0000
Message-ID: <CAGiyFdfb41vWstktb_VbdUa83bj1r1iJup4W7LD+4_Zv5U68aw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=f403045ec68edc8e54054351d2d9
Subject: [kernel-hardening] Re: [PATCH] siphash: add cryptographically secure hashtable function
To: Vegard Nossum <vegard.nossum@gmail.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@linux-foundation.org>, "Daniel J . Bernstein" <djb@cr.yp.to>, linux@sciencehorizons.net
List-ID: <kernel-hardening.lists.openwall.com>

--f403045ec68edc8e54054351d2d9
Content-Type: text/plain; charset=UTF-8

SipHash co-designer here.

SipHash is secure when it takes a secret key/seed as parameter, meaning
that its output values are unpredictable. Concretely, when SipHash produces
64-bit output values then you've a chance 1/2^64 to guess the hash value of
a given message, provided that the key/seed is kept secret. That's the
standard security definition of a pseudorandom function (PRF), which is
typically instantiated with a MAC such as HMAC-somehash.

With djb we demonstrated that this security notion is sufficient to protect
from hash-flooding attacks wherein an attacker creates many different input
values that hash to a same value and therefore may DoS the underlying data
structure.

I admit that the naming is confusing: "SipHash" is not a hash function,
strictly speaking. In crypto we only call hash function algorithms that are
unkeyed. PRFs/MACs are sometimes called keyed hash functions though.



On Sat, Dec 10, 2016 at 3:17 PM Vegard Nossum <vegard.nossum@gmail.com>
wrote:

> On 9 December 2016 at 19:36, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > SipHash is a 64-bit keyed hash function that is actually a
> > cryptographically secure PRF, like HMAC. Except SipHash is super fast,
> > and is meant to be used as a hashtable keyed lookup function.
> >
> > SipHash isn't just some new trendy hash function. It's been around for a
> > while, and there really isn't anything that comes remotely close to
> > being useful in the way SipHash is. With that said, why do we need this?
> >
> > There are a variety of attacks known as "hashtable poisoning" in which an
> > attacker forms some data such that the hash of that data will be the
> > same, and then preceeds to fill up all entries of a hashbucket. This is
> > a realistic and well-known denial-of-service vector.
> >
> > Linux developers already seem to be aware that this is an issue, and
> > various places that use hash tables in, say, a network context, use a
> > non-cryptographically secure function (usually jhash) and then try to
> > twiddle with the key on a time basis (or in many cases just do nothing
> > and hope that nobody notices). While this is an admirable attempt at
> > solving the problem, it doesn't actually fix it. SipHash fixes it.
>
> Could you give some more concrete details/examples? Here's the IPv4
> hash table from include/net/inet_sock.h / net/ipv4/inet_hashtables.c:
>
> static inline unsigned int __inet_ehashfn(const __be32 laddr,
>                                          const __u16 lport,
>                                          const __be32 faddr,
>                                          const __be16 fport,
>                                          u32 initval)
> {
>        return jhash_3words((__force __u32) laddr,
>                            (__force __u32) faddr,
>                            ((__u32) lport) << 16 | (__force __u32)fport,
>                            initval);
> }
>
> static u32 inet_ehashfn(const struct net *net, const __be32 laddr,
>                        const __u16 lport, const __be32 faddr,
>                        const __be16 fport)
> {
>        static u32 inet_ehash_secret __read_mostly;
>
>        net_get_random_once(&inet_ehash_secret, sizeof(inet_ehash_secret));
>
>        return __inet_ehashfn(laddr, lport, faddr, fport,
>                              inet_ehash_secret + net_hash_mix(net));
> }
>
> There's a 32-bit secret random salt (inet_ehash_secret) which means
> that in practice, inet_ehashfn() will select 1 out of 2^32 different
> hash functions at random each time you boot the kernel; without
> knowing which one it selected, how can a local or remote attacker can
> force IPv4 connections/whatever to go into a single hash bucket?
>
> It is not possible to obtain the secret salt directly (except by
> reading from kernel memory, in which case you've lost already), nor is
> it possible to obtain the result of inet_ehashfn() other than (maybe)
> by a timing attack where you somehow need to detect that two
> connections went into the same hash bucket and work backwards from
> that to figure out how to land more connections into into the same
> bucket -- but if they can do that, you've also already lost.
>
> The same pattern is used for IPv6 hashtables and the dentry cache.
>
> I suppose that using a hash function proven to be cryptographically
> secure gives a hard guarantee (under some assumptions) that the
> salt/key will give enough diversity between the (in the example above)
> 2^32 different hash functions that you cannot improve your chances of
> guessing that two values will map to the same bucket regardless of the
> salt/key. However, I am a bit doubtful that using a cryptographically
> secure hash function will make much of a difference as long as the
> attacker doesn't actually have any way to get the output/result of the
> hash function (and given that the hash function isn't completely
> trivial, of course).
>
> I am happy to be proven wrong, but you make it sound very easy to
> exploit the current situation, so I would just like to ask whether you
> have a concrete way to do that?
>
>
> Vegard
>
> > There are a modicum of places in the kernel that are vulnerable to
> > hashtable poisoning attacks, either via userspace vectors or network
> > vectors, and there's not a reliable mechanism inside the kernel at the
> > moment to fix it. The first step toward fixing these issues is actually
> > getting a secure primitive into the kernel for developers to use. Then
> > we can, bit by bit, port things over to it as deemed appropriate.
> >
> > Dozens of languages are already using this internally for their hash
> > tables. Some of the BSDs already use this in their kernels. SipHash is
> > a widely known high-speed solution to a widely known problem, and it's
> > time we catch-up.
>

--f403045ec68edc8e54054351d2d9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">SipHash co-designer here.<div><br></div><div>SipHash is se=
cure when it takes a secret key/seed as parameter, meaning that its output =
values are unpredictable. Concretely, when SipHash produces 64-bit output v=
alues then you&#39;ve a chance 1/2^64 to guess the hash value of a given me=
ssage, provided that the key/seed is kept secret. That&#39;s the standard s=
ecurity definition of a pseudorandom function (PRF), which is typically ins=
tantiated with a MAC such as HMAC-somehash.=C2=A0</div><div><br></div><div>=
With djb we demonstrated that this security notion is sufficient to protect=
 from hash-flooding attacks wherein an attacker creates many different inpu=
t values that hash to a same value and therefore may DoS the underlying dat=
a structure.</div><div><br></div><div>I admit that the naming is confusing:=
 &quot;SipHash&quot; is not a hash function, strictly speaking. In crypto w=
e only call hash function algorithms that are unkeyed. PRFs/MACs are someti=
mes called keyed hash functions though.</div><div><br></div><div><br><br><d=
iv class=3D"gmail_quote"><div dir=3D"ltr">On Sat, Dec 10, 2016 at 3:17 PM V=
egard Nossum &lt;<a href=3D"mailto:vegard.nossum@gmail.com">vegard.nossum@g=
mail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On 9 Decemb=
er 2016 at 19:36, Jason A. Donenfeld &lt;<a href=3D"mailto:Jason@zx2c4.com"=
 class=3D"gmail_msg" target=3D"_blank">Jason@zx2c4.com</a>&gt; wrote:<br cl=
ass=3D"gmail_msg">
&gt; SipHash is a 64-bit keyed hash function that is actually a<br class=3D=
"gmail_msg">
&gt; cryptographically secure PRF, like HMAC. Except SipHash is super fast,=
<br class=3D"gmail_msg">
&gt; and is meant to be used as a hashtable keyed lookup function.<br class=
=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; SipHash isn&#39;t just some new trendy hash function. It&#39;s been ar=
ound for a<br class=3D"gmail_msg">
&gt; while, and there really isn&#39;t anything that comes remotely close t=
o<br class=3D"gmail_msg">
&gt; being useful in the way SipHash is. With that said, why do we need thi=
s?<br class=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; There are a variety of attacks known as &quot;hashtable poisoning&quot=
; in which an<br class=3D"gmail_msg">
&gt; attacker forms some data such that the hash of that data will be the<b=
r class=3D"gmail_msg">
&gt; same, and then preceeds to fill up all entries of a hashbucket. This i=
s<br class=3D"gmail_msg">
&gt; a realistic and well-known denial-of-service vector.<br class=3D"gmail=
_msg">
&gt;<br class=3D"gmail_msg">
&gt; Linux developers already seem to be aware that this is an issue, and<b=
r class=3D"gmail_msg">
&gt; various places that use hash tables in, say, a network context, use a<=
br class=3D"gmail_msg">
&gt; non-cryptographically secure function (usually jhash) and then try to<=
br class=3D"gmail_msg">
&gt; twiddle with the key on a time basis (or in many cases just do nothing=
<br class=3D"gmail_msg">
&gt; and hope that nobody notices). While this is an admirable attempt at<b=
r class=3D"gmail_msg">
&gt; solving the problem, it doesn&#39;t actually fix it. SipHash fixes it.=
<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
Could you give some more concrete details/examples? Here&#39;s the IPv4<br =
class=3D"gmail_msg">
hash table from include/net/inet_sock.h / net/ipv4/inet_hashtables.c:<br cl=
ass=3D"gmail_msg">
<br class=3D"gmail_msg">
static inline unsigned int __inet_ehashfn(const __be32 laddr,<br class=3D"g=
mail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0co=
nst __u16 lport,<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0co=
nst __be32 faddr,<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0co=
nst __be16 fport,<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u3=
2 initval)<br class=3D"gmail_msg">
{<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0return jhash_3words((__force __u32) laddr,<br cl=
ass=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0(__force __u32) faddr,<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0((__u32) lport) &lt;&lt; 16 | (__force __u32)fport,=
<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0initval);<br class=3D"gmail_msg">
}<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
static u32 inet_ehashfn(const struct net *net, const __be32 laddr,<br class=
=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0const __u16 lport, const __be32 faddr,<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0const __be16 fport)<br class=3D"gmail_msg">
{<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0static u32 inet_ehash_secret __read_mostly;<br c=
lass=3D"gmail_msg">
<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0net_get_random_once(&amp;inet_ehash_secret, size=
of(inet_ehash_secret));<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0return __inet_ehashfn(laddr, lport, faddr, fport=
,<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet_ehash_secret + net_hash_mix(net));<br c=
lass=3D"gmail_msg">
}<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
There&#39;s a 32-bit secret random salt (inet_ehash_secret) which means<br =
class=3D"gmail_msg">
that in practice, inet_ehashfn() will select 1 out of 2^32 different<br cla=
ss=3D"gmail_msg">
hash functions at random each time you boot the kernel; without<br class=3D=
"gmail_msg">
knowing which one it selected, how can a local or remote attacker can<br cl=
ass=3D"gmail_msg">
force IPv4 connections/whatever to go into a single hash bucket?<br class=
=3D"gmail_msg">
<br class=3D"gmail_msg">
It is not possible to obtain the secret salt directly (except by<br class=
=3D"gmail_msg">
reading from kernel memory, in which case you&#39;ve lost already), nor is<=
br class=3D"gmail_msg">
it possible to obtain the result of inet_ehashfn() other than (maybe)<br cl=
ass=3D"gmail_msg">
by a timing attack where you somehow need to detect that two<br class=3D"gm=
ail_msg">
connections went into the same hash bucket and work backwards from<br class=
=3D"gmail_msg">
that to figure out how to land more connections into into the same<br class=
=3D"gmail_msg">
bucket -- but if they can do that, you&#39;ve also already lost.<br class=
=3D"gmail_msg">
<br class=3D"gmail_msg">
The same pattern is used for IPv6 hashtables and the dentry cache.<br class=
=3D"gmail_msg">
<br class=3D"gmail_msg">
I suppose that using a hash function proven to be cryptographically<br clas=
s=3D"gmail_msg">
secure gives a hard guarantee (under some assumptions) that the<br class=3D=
"gmail_msg">
salt/key will give enough diversity between the (in the example above)<br c=
lass=3D"gmail_msg">
2^32 different hash functions that you cannot improve your chances of<br cl=
ass=3D"gmail_msg">
guessing that two values will map to the same bucket regardless of the<br c=
lass=3D"gmail_msg">
salt/key. However, I am a bit doubtful that using a cryptographically<br cl=
ass=3D"gmail_msg">
secure hash function will make much of a difference as long as the<br class=
=3D"gmail_msg">
attacker doesn&#39;t actually have any way to get the output/result of the<=
br class=3D"gmail_msg">
hash function (and given that the hash function isn&#39;t completely<br cla=
ss=3D"gmail_msg">
trivial, of course).<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
I am happy to be proven wrong, but you make it sound very easy to<br class=
=3D"gmail_msg">
exploit the current situation, so I would just like to ask whether you<br c=
lass=3D"gmail_msg">
have a concrete way to do that?<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
Vegard<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
&gt; There are a modicum of places in the kernel that are vulnerable to<br =
class=3D"gmail_msg">
&gt; hashtable poisoning attacks, either via userspace vectors or network<b=
r class=3D"gmail_msg">
&gt; vectors, and there&#39;s not a reliable mechanism inside the kernel at=
 the<br class=3D"gmail_msg">
&gt; moment to fix it. The first step toward fixing these issues is actuall=
y<br class=3D"gmail_msg">
&gt; getting a secure primitive into the kernel for developers to use. Then=
<br class=3D"gmail_msg">
&gt; we can, bit by bit, port things over to it as deemed appropriate.<br c=
lass=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; Dozens of languages are already using this internally for their hash<b=
r class=3D"gmail_msg">
&gt; tables. Some of the BSDs already use this in their kernels. SipHash is=
<br class=3D"gmail_msg">
&gt; a widely known high-speed solution to a widely known problem, and it&#=
39;s<br class=3D"gmail_msg">
&gt; time we catch-up.<br class=3D"gmail_msg">
</blockquote></div></div></div>

--f403045ec68edc8e54054351d2d9--
