Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120224183726.GB23284@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
	<20120216204515.GH20420@outflux.net>
	<20120217002405.GB7746@kroah.com>
	<20120217075945.GA2831@albatros>
	<20120217175445.GC29902@kroah.com>
	<20120217193719.GA4187@albatros>
	<20120217233908.GA24047@dztty>
	<CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
	<20120218161849.GA4176@kroah.com>
	<CAEXv5_jYj=cHsePJEf4f08KsBOfU+MVMnV0DucmVKQbg+KbxrQ@mail.gmail.com>
	<20120224183726.GB23284@kroah.com>
Date: Fri, 24 Feb 2012 14:04:57 -0500
Message-ID: <CAEXv5_jEW6EA6nOd6pMJbh6PTd=+piHqzNA8Fb+gt2VGroba0A@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 24, 2012 at 1:37 PM, Greg KH <gregkh@linuxfoundation.org> wrote=
:
> On Fri, Feb 24, 2012 at 12:58:35PM -0500, David Windsor wrote:
>> <snip>
>>
>> >> Greg, I'm not sure why you're opposed to adding this checking...
>> >> it's pretty clear that buggy error paths that forget to do a put are
>> >> pretty common and will continue to be common in new code, and
>> >> making them harder to exploit seems pretty sane to me.
>> >>
>> >> What's the downside?
>> >
>> > The downside is that there has not even been a patch sent for any of
>> > this. =A0Combine that with a lack of understanding about reference
>> > counting and atomic_t usages in the kernel, and the whole thing is rip=
e
>> > for misunderstanding and confusion.
>> >
>> > greg k-h
>>
>> This approach to adding overflow protection to kref uses
>> atomic_add_unless to increment the refcounter only if it is not
>> already at INT_MAX. =A0This
>> leaks the internal representation of atomic_t, which is defined as an
>> int in linux/types.h, into kref.
>>
>> If we can agree on an approach to adding overflow protection, if it is
>> indeed desired, we can then discuss adding a Kconfig option and/or a
>> sysctl for this protection.
>>
>> Thanks,
>> David
>>
>>
>> Signed-off-by: David Windsor <dwindsor@gmail.com>
>> ---
>> =A0include/linux/kref.h | =A0 =A06 +++++-
>> =A01 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/kref.h b/include/linux/kref.h
>> index 9c07dce..fc0756a 100644
>> --- a/include/linux/kref.h
>> +++ b/include/linux/kref.h
>> @@ -38,8 +38,12 @@ static inline void kref_init(struct kref *kref)
>> =A0 */
>> =A0static inline void kref_get(struct kref *kref)
>> =A0{
>> + =A0 int rc =3D 0;
>> =A0 =A0 WARN_ON(!atomic_read(&kref->refcount));
>> - =A0 atomic_inc(&kref->refcount);
>> + =A0 smp_mb__before_atomic_inc();
>> + =A0 rc =3D atomic_add_unless(&kref->refcount, 1, INT_MAX);
>> + =A0 smp_mb__after_atomic_inc();
>> + =A0 BUG_ON(!rc);
>
> So you are guaranteeing to crash a machine here if this fails? =A0And you
> were trying to say this is a "security" based fix?
>


Suggestions on recovering from an overflow here?

The salient possibilities are:

1. Do nothing, as was the case before this patch.
This leads to undefined behavior, but typically, a wrap happens.  This
leads to use-after-free bugs.

2. Detect the overflow before it happens, don't increment the counter,
issue a warning but no BUG.
This could also lead to some "undefined" behavior in subsystems.  I
can't imagine many users of kref have considered the situation of
kref_get essentially being a no-op, which is what would happen in this
situation.

3. Detect the overflow before it happens, don't increment the counter,
issue a BUG.
This is what the proposed patch does.  Suggestions for recovering
gracefully from this overflow are welcome.

--=20
PGP: 6141 5FFD 11AE 9844 153E =A0F268 7C98 7268 6B19 6CC9
