Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
In-Reply-To: <20170214174029.GJ23718@leverpostej>
Date: Tue, 14 Feb 2017 17:49:19 +0000
Content-Transfer-Encoding: quoted-printable
Message-Id: <42A48E4E-EF3C-4F28-A660-AFEBB238B698@linaro.org>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org> <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org> <20170214155704.GE23718@leverpostej> <651D9CBB-3E64-41CE-BF85-D2FF0CB927B7@linaro.org> <20170214174029.GJ23718@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v2 4/5] arm64: mmu: map .text as read-only from the outset
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, Suzuki.Poulose@arm.com, james.morse@arm.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, nd@arm.com
List-ID: <kernel-hardening.lists.openwall.com>


> On 14 Feb 2017, at 17:40, Mark Rutland <mark.rutland@arm.com> wrote:
>=20
>> On Tue, Feb 14, 2017 at 04:15:11PM +0000, Ard Biesheuvel wrote:
>>=20
>>>> On 14 Feb 2017, at 15:57, Mark Rutland <mark.rutland@arm.com> wrote:
>>>>=20
>>>> On Sat, Feb 11, 2017 at 08:23:05PM +0000, Ard Biesheuvel wrote:
>>>> Now that alternatives patching code no longer relies on the primary
>>>> mapping of .text being writable, we can remove the code that removes
>>>> the writable permissions post-init time, and map it read-only from
>>>> the outset.
>>>>=20
>>>> Reviewed-by: Laura Abbott <labbott@redhat.com>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>=20
>>> This generally looks good.
>>>=20
>>> One effect of this is that even with rodata=3Doff, external debuggers
>>> can't install SW breakpoints via the executable mapping.
>>=20
>> Interesting. For the sake of my education, could you elaborate on how
>> that works under the hood?
>=20
> There are details in ARM DDI 0487A.k_iss10775, Chapter H1, "About
> External Debug", page H1-4839 onwards. Otherwise, executive summary
> below.
>=20
> An external debugger can place a CPU into debug state. This is
> orthogonal to execution state and exception level, which are unchanged.
> While in this state, the CPU (only) executes instructions fed to it by
> the debugger through a special register.
>=20
> To install a SW breakpoint, the debugger makes the CPU enter debug
> state, then issues regular stores, barriers, and cache maintenance.
> These operate in the current execution state at the current EL, using
> the current translation regime.
>=20
> The external debugger can also trap exceptions (e.g. those caused by the
> SW breakpoint). The CPU enters debug state when these are trapped.
>=20

OK, thanks for the explanation

>>> We might want to allow that to be overridden. e.g. make rodata=3D an
>>> early param, and switch the permissions based on that in map_kernel(),
>>> e.g. have:
>>>=20
>>>   pgprot_t text_prot =3D rodata_enabled ? PAGE_KERNEL_ROX
>>>                       : PAGE_KERNEL_EXEC);
>>>=20
>>> ... and use that for .text and .init.text by default.
>>>=20
>>>=20
>>=20
>> Is there any way we could restrict this privilege to external
>> debuggers?
>=20
> My understanding is that we cannot.
>=20
>> Having trivial 'off' switches for security features makes me feel
>> uneasy (although this is orthogonal to this patch)
>=20
> =46rom my PoV, external debuggers are the sole reason to allow rodata=3Dof=
f
> for arm64, and we already allow rodata=3Doff.
>=20
>=20

Indeed. If that is how it works currently, we shouldn't interfere with it. I=
f we ever get anywhere with the lockdown patches, we should blacklist this p=
arameter (or rather, not whitelist it, since blacklisting kernel params to e=
nforce security is infeasible imo)=
