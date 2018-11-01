Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH 10/17] prmem: documentation
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20181031090835.GG744@hirez.programming.kicks-ass.net>
Date: Thu, 1 Nov 2018 11:31:59 -0500
Content-Transfer-Encoding: quoted-printable
Message-Id: <59E8A6FB-9762-499F-89AC-D85E1498BE38@gmail.com>
References: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <28C8CD2A-BDC0-49A5-854E-1E18968528B8@amacapital.net>
 <CAC99157-7A9B-4AC6-BA41-EAA7A99FE53D@gmail.com>
 <20181031090835.GG744@hirez.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

From: Peter Zijlstra
Sent: October 31, 2018 at 9:08:35 AM GMT
> To: Nadav Amit <nadav.amit@gmail.com>
> Cc: Andy Lutomirski <luto@amacapital.net>, Matthew Wilcox =
<willy@infradead.org>, Kees Cook <keescook@chromium.org>, Igor Stoppa =
<igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave =
Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal =
Hocko <mhocko@kernel.org>, Kernel Hardening =
<kernel-hardening@lists.openwall.com>, linux-integrity =
<linux-integrity@vger.kernel.org>, linux-security-module =
<linux-security-module@vger.kernel.org>, Igor Stoppa =
<igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, =
Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, =
Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport =
<rppt@linux.vnet.ibm.com>, open list:DOCUMENTATION =
<linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas =
Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH 10/17] prmem: documentation
>=20
>=20
> On Tue, Oct 30, 2018 at 04:18:39PM -0700, Nadav Amit wrote:
>>> Nadav, want to resubmit your series? IIRC the only thing wrong with =
it was
>>> that it was a big change and we wanted a simpler fix to backport. =
But
>>> that=E2=80=99s all done now, and I, at least, rather liked your =
code. :)
>>=20
>> I guess since it was based on your ideas=E2=80=A6
>>=20
>> Anyhow, the only open issue that I have with v2 is Peter=E2=80=99s =
wish that I would
>> make kgdb use of poke_text() less disgusting. I still don=E2=80=99t =
know exactly
>> how to deal with it.
>>=20
>> Perhaps it (fixing kgdb) can be postponed? In that case I can just =
resend
>> v2.
>=20
> Oh man, I completely forgot about kgdb :/
>=20
> Also, would it be possible to entirely remove that kmap fallback path?

Let me see what I can do about it.=
