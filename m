Reply-To: kernel-hardening@lists.openwall.com
From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Tue, 26 Jul 2016 17:33:13 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC560125DBE7@ORSMSX103.amr.corp.intel.com>
References: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
 <20160726030201.6775-1-jason@lakedaemon.net>
 <20160726033032.GD4541@io.lakedaemon.net>
In-Reply-To: <20160726033032.GD4541@io.lakedaemon.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC patch 1/6] random: Simplify API for random address requests
To: Jason Cooper <jason@lakedaemon.net>, "linux-mm@vger.kernel.org" <linux-mm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>, "arnd@arndb.de" <arnd@arndb.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "ralf@linux-mips.org" <ralf@linux-mips.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "paulus@samba.org" <paulus@samba.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "davem@davemloft.net" <davem@davemloft.net>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "nnk@google.com" <nnk@google.com>, "jeffv@google.com" <jeffv@google.com>, "alyzyn@android.com" <alyzyn@android.com>, "dcashman@android.com" <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Jason Cooper [mailto:jason@lakedaemon.net]
> Sent: Monday, July 25, 2016 8:31 PM
> To: Roberts, William C <william.c.roberts@intel.com>; linux-
> mm@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> hardening@lists.openwall.com
> Cc: linux@arm.linux.org.uk; akpm@linux-foundation.org;
> keescook@chromium.org; tytso@mit.edu; arnd@arndb.de;
> gregkh@linuxfoundation.org; catalin.marinas@arm.com; will.deacon@arm.com;
> ralf@linux-mips.org; benh@kernel.crashing.org; paulus@samba.org;
> mpe@ellerman.id.au; davem@davemloft.net; tglx@linutronix.de;
> mingo@redhat.com; hpa@zytor.com; x86@kernel.org; viro@zeniv.linux.org.uk;
> nnk@google.com; jeffv@google.com; alyzyn@android.com;
> dcashman@android.com
> Subject: Re: [RFC patch 1/6] random: Simplify API for random address requ=
ests
>=20
> All,
>=20
> On Tue, Jul 26, 2016 at 03:01:55AM +0000, Jason Cooper wrote:
> > To date, all callers of randomize_range() have set the length to 0,
> > and check for a zero return value.  For the current callers, the only
> > way to get zero returned is if end <=3D start.  Since they are all
> > adding a constant to the start address, this is unnecessary.
> >
> > We can remove a bunch of needless checks by simplifying the API to do
> > just what everyone wants, return an address between [start, start +
> > range].
> >
> > While we're here, s/get_random_int/get_random_long/.  No current call
> > site is adversely affected by get_random_int(), since all current
> > range requests are < MAX_UINT.  However, we should match caller
> > expectations to avoid coming up short (ha!) in the future.
> >
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > ---
> >  drivers/char/random.c  | 17 ++++-------------  include/linux/random.h
> > |  2 +-
> >  2 files changed, 5 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/char/random.c b/drivers/char/random.c index
> > 0158d3bff7e5..1251cb2cbab2 100644
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -1822,22 +1822,13 @@ unsigned long get_random_long(void)
> > EXPORT_SYMBOL(get_random_long);
> >
> >  /*
> > - * randomize_range() returns a start address such that
> > - *
> > - *    [...... <range> .....]
> > - *  start                  end
> > - *
> > - * a <range> with size "len" starting at the return value is inside
> > in the
> > - * area defined by [start, end], but is otherwise randomized.
> > + * randomize_addr() returns a page aligned address within [start,
> > + start +
> > + * range]
> >   */
> >  unsigned long
> > -randomize_range(unsigned long start, unsigned long end, unsigned long
> > len)
> > +randomize_addr(unsigned long start, unsigned long range)
> >  {
> > -	unsigned long range =3D end - len - start;
> > -
> > -	if (end <=3D start + len)
> > -		return 0;
> > -	return PAGE_ALIGN(get_random_int() % range + start);
> > +	return PAGE_ALIGN(get_random_long() % range + start);
> >  }
>=20
> bah!  old patch file.  This should have been:
>=20
> if (range =3D=3D 0)
> 	return start;
> else
> 	return PAGE_ALIGN(get_random_long() % range + start);
>=20
> sorry,

Yeah that looks better. I had a similar intended set of changes locally, be=
cause of the issues Jason pointed out.
I ended up in the old case where if end - start =3D=3D len it returns 0 ins=
tead of start. Jason's change is better though :-P

>=20
> Jason.
>=20
> >
> >  /* Interface for in-kernel drivers of true hardware RNGs.
> > diff --git a/include/linux/random.h b/include/linux/random.h index
> > e47e533742b5..1ad877a98186 100644
> > --- a/include/linux/random.h
> > +++ b/include/linux/random.h
> > @@ -34,7 +34,7 @@ extern const struct file_operations random_fops,
> > urandom_fops;
> >
> >  unsigned int get_random_int(void);
> >  unsigned long get_random_long(void);
> > -unsigned long randomize_range(unsigned long start, unsigned long end,
> > unsigned long len);
> > +unsigned long randomize_addr(unsigned long start, unsigned long
> > +range);
> >
> >  u32 prandom_u32(void);
> >  void prandom_bytes(void *buf, size_t nbytes);
> > --
> > 2.9.2
> >
