Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20180128092914.dabnzq7arv4bebhn@gmail.com>
Date: Sun, 28 Jan 2018 07:22:26 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <5CF96758-5FD5-49BB-80E8-951AF5AB2B68@amacapital.net>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com> <151703975137.26578.11230688940391207602.stgit@dwillia2-desk3.amr.corp.intel.com> <20180128092914.dabnzq7arv4bebhn@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v5 07/12] x86: remove the syscall_64 fast-path
To: Ingo Molnar <mingo@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>




> On Jan 28, 2018, at 1:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
>=20
>=20
> * Dan Williams <dan.j.williams@intel.com> wrote:
>=20
>> Quoting Linus:
>>=20
>>  "Honestly, I'd rather get rid of the fast-path entirely. Compared to
>>   all the PTI mess, it's not even noticeable.
>>=20
>>   And if we ever get CPU's that have this all fixed, we can re-visit
>>   introducing the fastpath. But this is all very messy and it doesn't
>>   seem worth it right now.
>>=20
>>   If we get rid of the fastpath, we can lay out the slow path slightly
>>   better, and get rid of some of those jump-overs. And we'd get rid of
>>   the ptregs hooks entirely.
>>=20
>>   So we can try to make the "slow" path better while at it, but I
>>   really don't think it matters much now in the post-PTI era. Sadly."
>=20
> Please fix the title to have the proper prefix and to reference the functi=
on that=20
> is actually modified by the patch, i.e. something like:
>=20
> s/ x86: remove the syscall_64 fast-path
> / x86/entry/64: Remove the entry_SYSCALL_64() fast-path
>=20
> With the title fixed:
>=20
> Reviewed-by: Ingo Molnar <mingo@kernel.org>

I have a very similar but not quite identical version I'll send out shortly.=
  The difference is that I fixed the silly prologue.

>=20
> Thanks,
>=20
>    Ingo
