Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 10/17] prmem: documentation
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
Date: Tue, 30 Oct 2018 10:06:51 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com> <20181023213504.28905-11-igor.stoppa@huawei.com> <20181026092609.GB3159@worktop.c.hoisthospitality.com> <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com> <20181028183126.GB744@hirez.programming.kicks-ass.net> <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com> <20181030152641.GE8177@hirez.programming.kicks-ass.net> <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>


> On Oct 30, 2018, at 9:37 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Tue, Oct 30, 2018 at 8:26 AM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
>> I suppose the 'normal' attack goes like:
>>=20
>> 1) find buffer-overrun / bound check failure
>> 2) use that to write to 'interesting' location
>> 3) that write results arbitrary code execution
>> 4) win
>>=20
>> Of course, if the store of 2 is to the current cred structure, and
>> simply sets the effective uid to 0, we can skip 3.
>=20
> In most cases, yes, gaining root is game over. However, I don't want
> to discount other threat models: some systems have been designed not
> to trust root, so a cred attack doesn't always get an attacker full
> control (e.g. lockdown series, signed modules, encrypted VMs, etc).
>=20
>> Which seems to suggest all cred structures should be made r/o like this.
>> But I'm not sure I remember these patches doing that.
>=20
> There are things that attempt to protect cred (and other things, like
> page tables) via hypervisors (see Samsung KNOX) or via syscall
> boundary checking (see Linux Kernel Runtime Guard). They're pretty
> interesting, but I'm not sure if there is a clear way forward on it
> working in upstream, but that's why I think these discussions are
> useful.
>=20
>> Also, there is an inverse situation with all this. If you make
>> everything R/O, then you need this allow-write for everything you do,
>> which then is about to include a case with an overflow / bound check
>> fail, and we're back to square 1.
>=20
> Sure -- this is the fine line in trying to build these defenses. The
> point is to narrow the scope of attack. Stupid metaphor follows: right
> now we have only a couple walls; if we add walls we can focus on make
> sure the doors and windows are safe. If we make the relatively
> easy-to-find-in-memory page tables read-only-at-rest then a whole
> class of very powerful exploits that depend on page table attacks go
> away.
>=20
> As part of all of this is the observation that there are two types of
> things clearly worth protecting: that which is updated rarely (no need
> to leave it writable for so much of its lifetime), and that which is
> especially sensitive (page tables, security policy, function pointers,
> etc). Finding a general purpose way to deal with these (like we have
> for other data-lifetime cases like const and __ro_after_init) would be
> very nice. I don't think there is a slippery slope here.
>=20
>=20

Since I wasn=E2=80=99t cc=E2=80=99d on this series:

I support the addition of a rare-write mechanism to the upstream kernel.  An=
d I think that there is only one sane way to implement it: using an mm_struc=
t. That mm_struct, just like any sane mm_struct, should only differ from ini=
t_mm in that it has extra mappings in the *user* region.

If anyone wants to use CR0.WP instead, I=E2=80=99ll remind them that they ha=
ve to fix up the entry code and justify the added complexity. And make perfo=
rmance not suck in a VM (i.e. CR0 reads on entry are probably off the table)=
.  None of these will be easy.

If anyone wants to use kmap_atomic-like tricks, I=E2=80=99ll point out that w=
e already have enough problems with dangling TLB entries due to SMP issues. T=
he last thing we need is more of them. If someone proposes a viable solution=
 that doesn=E2=80=99t involve CR3 fiddling, I=E2=80=99ll be surprised.

Keep in mind that switch_mm() is actually decently fast on modern CPUs.  It=E2=
=80=99s probably considerably faster than writing CR0, although I haven=E2=80=
=99t benchmarked it. It=E2=80=99s certainly faster than writing CR4.  It=E2=80=
=99s also faster than INVPCID, surprisingly, which means that it will be qui=
te hard to get better performance using any sort of trickery.

Nadav=E2=80=99s patch set would be an excellent starting point.

P.S. EFI is sort of grandfathered in as a hackish alternate page table hiera=
rchy. We=E2=80=99re not adding another one.=
