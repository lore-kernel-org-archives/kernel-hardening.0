Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120224194150.GE24120@kroah.com>
References: <20120217002405.GB7746@kroah.com>
	<20120217075945.GA2831@albatros>
	<20120217175445.GC29902@kroah.com>
	<20120217193719.GA4187@albatros>
	<20120217233908.GA24047@dztty>
	<CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
	<20120218161849.GA4176@kroah.com>
	<CAEXv5_jYj=cHsePJEf4f08KsBOfU+MVMnV0DucmVKQbg+KbxrQ@mail.gmail.com>
	<20120224183726.GB23284@kroah.com>
	<20120224185825.GA11818@albatros>
	<20120224194150.GE24120@kroah.com>
Date: Fri, 24 Feb 2012 12:04:12 -0800
Message-ID: <CAGXu5j+qm6OR5m6RJS87Ahr5_pEzaJkHGcdWwjkxOMywkB1Ahg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, David Windsor <dwindsor@gmail.com>, Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>, kernel-hardening@lists.openwall.com, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 24, 2012 at 11:41 AM, Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> On Fri, Feb 24, 2012 at 10:58:25PM +0400, Vasiliy Kulikov wrote:
>> On Fri, Feb 24, 2012 at 10:37 -0800, Greg KH wrote:
>> > On Fri, Feb 24, 2012 at 12:58:35PM -0500, David Windsor wrote:
>> > > =A0static inline void kref_get(struct kref *kref)
>> > > =A0{
>> > > + =A0 int rc =3D 0;
>> > > =A0 =A0 WARN_ON(!atomic_read(&kref->refcount));
>> > > - =A0 atomic_inc(&kref->refcount);
>> > > + =A0 smp_mb__before_atomic_inc();
>> > > + =A0 rc =3D atomic_add_unless(&kref->refcount, 1, INT_MAX);
>> > > + =A0 smp_mb__after_atomic_inc();
>> > > + =A0 BUG_ON(!rc);
>> >
>> > So you are guaranteeing to crash a machine here if this fails? =A0And =
you
>> > were trying to say this is a "security" based fix?
>> >
>> > And people wonder why I no longer have any hair...
>>
>> If a refcounter overflows there is NO WAY to recover. =A0The choise is t=
o BUG()
>> and not allow any security harm to the system (privilege escalation, etc=
.)
>> or to try to do some more CPU cycles until actual use after free, privil=
ege
>> escalation, etc. =A0The former is a _guarantee_ that nothing bad (in sec=
urity
>> sense) doesn't happen. =A0The latter is an opportunistic approach, which
>> doesn't work with security.
>
> The only way you could legimitaly get a real use-after-free problem if
> you were overflowing the reference counter and pegged it at the max
> value, was if you had code that could decrement the reference count as
> many times as you incremented it. =A0So far, all bugs we've seen are
> one-off where on an error path, we forgot to decrement the count. =A0So
> how could the decrement ever happen?

Based on what I've seen, the "normal" exploit follows this pattern:

user1: alloc(), inc
user2: inc
user2: fail to dec
*repeat user2's actions until wrap*
user3: inc
user3: dec, free()
user1: operate on freed memory zomg

We could avoid the BUG by locking the counter to INT_MAX if it ever
reaches it (i.e. the put path would need to be modified too), and then
a WARN could be added to the get. Is that what was being suggested as
the alternative to the BUG patch?

>> Do you claim that a refcounter overflow is a recoverable state? =A0I'd w=
ant to
>> know what you can do with it.
>
> I'm not saying it is a "recoverable" state, but to crash the machine is
> not acceptable. =A0At the very least, let the user know something went
> wrong, and stick around long enough to let them know and do something,
> before shutting the thing down.
>
> But before people start micro-engineering this whole thing, remember,
> I'm still not sold on this type of change at all.
>
> greg k-h
>
> p.s. Has anyone ever tried an endless open() loop on a sysfs file to see
> =A0 =A0 what happens today?...

AIUI, you'd hit nrfile well before wrapping the counter. To test this,
we'd need to simulate a failed decrement.

-Kees

--=20
Kees Cook
ChromeOS Security
