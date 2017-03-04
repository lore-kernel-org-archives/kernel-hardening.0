Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CALCETrVNRbswNWeoVLdntdNXmb4ur3a-xiVNqALajHNG-bLJgw@mail.gmail.com>
Date: Sat, 4 Mar 2017 14:56:44 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <E951BDD3-A4C9-436B-B886-2E6BF0A16246@gmail.com>
References: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com> <CALCETrVNRbswNWeoVLdntdNXmb4ur3a-xiVNqALajHNG-bLJgw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] arm64: support HAVE_ARCH_RARE_WRITE
To: Andy Lutomirski <luto@amacapital.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, PaX Team <pageexec@freemail.hu>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On Mar 4, 2017, at 5:50 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>=20
>> On Thu, Mar 2, 2017 at 7:00 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> +unsigned long __rare_write_rw_alias_start =3D TASK_SIZE_64 / 4;
>> +
>> +__always_inline unsigned long __arch_rare_write_map(void)
>> +{
>> +       struct mm_struct *mm =3D &rare_write_mm;
>> +
>> +       preempt_disable();
>> +
>> +       __switch_mm(mm);
>=20
> ...
>=20
>> +__always_inline unsigned long __arch_rare_write_unmap(void)
>> +{
>> +       struct mm_struct *mm =3D current->active_mm;
>> +
>> +       __switch_mm(mm);
>> +
>=20
> This reminds me: this code imposes constraints on the context in which
> it's called.  I'd advise making it very explicit, asserting
> correctness, and putting the onus on the caller to set things up.  For
> example:
>=20
> DEBUG_LOCKS_WARN_ON(preemptible() || in_interrupt() || in_nmi());
>=20

OK. I will add some onus in the next version.

> in both the map and unmap functions, along with getting rid of the
> preempt_disable().  I don't think we want the preempt-disabledness to
> depend on the arch.  The generic non-arch rare_write helpers can do
> the preempt_disable().
>=20

I think I can fix this in the next version when Kees send the next version o=
f RFC.

> This code also won't work if the mm is wacky when called.  On x86, we coul=
d do:
>=20
> DEBUG_LOCKS_WARN_ON(read_cr3() !=3D current->active_mm->pgd);
>=20
> or similar (since that surely doesn't compile as is).
>=20
> --Andy

Thank you for the review.
