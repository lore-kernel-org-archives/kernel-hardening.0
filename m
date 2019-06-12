Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
Date: Wed, 12 Jun 2019 13:27:04 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>



> On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
>> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space.=20
>=20
> It might be fun to cc some x86 folks on this series.  They might have
> some relevant opinions. ;)
>=20
> A few high-level questions:
>=20
> Why go to all this trouble to hide guest state like registers if all the
> guest data itself is still mapped?
>=20
> Where's the context-switching code?  Did I just miss it?
>=20
> We've discussed having per-cpu page tables where a given PGD is only in
> use from one CPU at a time.  I *think* this scheme still works in such a
> case, it just adds one more PGD entry that would have to context-switched.=


Fair warning: Linus is on record as absolutely hating this idea. He might ch=
ange his mind, but it=E2=80=99s an uphill battle.=
