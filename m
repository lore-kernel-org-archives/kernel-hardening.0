Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
In-Reply-To: <20170214155704.GE23718@leverpostej>
Date: Tue, 14 Feb 2017 16:15:11 +0000
Content-Transfer-Encoding: quoted-printable
Message-Id: <651D9CBB-3E64-41CE-BF85-D2FF0CB927B7@linaro.org>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org> <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org> <20170214155704.GE23718@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v2 4/5] arm64: mmu: map .text as read-only from the outset
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, Suzuki.Poulose@arm.com, james.morse@arm.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, nd@arm.com
List-ID: <kernel-hardening.lists.openwall.com>


> On 14 Feb 2017, at 15:57, Mark Rutland <mark.rutland@arm.com> wrote:
>=20
>> On Sat, Feb 11, 2017 at 08:23:05PM +0000, Ard Biesheuvel wrote:
>> Now that alternatives patching code no longer relies on the primary
>> mapping of .text being writable, we can remove the code that removes
>> the writable permissions post-init time, and map it read-only from
>> the outset.
>>=20
>> Reviewed-by: Laura Abbott <labbott@redhat.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>=20
> This generally looks good.
>=20
> One effect of this is that even with rodata=3Doff, external debuggers
> can't install SW breakpoints via the executable mapping.
>=20

Interesting. For the sake of my education, could you elaborate on how that w=
orks under the hood?

> We might want to allow that to be overridden. e.g. make rodata=3D an
> early param, and switch the permissions based on that in map_kernel(),
> e.g. have:
>=20
>    pgprot_t text_prot =3D rodata_enabled ? PAGE_KERNEL_ROX
>                        : PAGE_KERNEL_EXEC);
>=20
> ... and use that for .text and .init.text by default.
>=20
>=20

Is there any way we could restrict this privilege to external debuggers? Hav=
ing trivial 'off' switches for security features makes me feel uneasy (altho=
ugh this is orthogonal to this patch)
>> ---
>> arch/arm64/mm/mmu.c | 5 +----
>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>=20
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 7ed981c7f4c0..e97f1ce967ec 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -442,9 +442,6 @@ void mark_rodata_ro(void)
>> {
>>    unsigned long section_size;
>>=20
>> -    section_size =3D (unsigned long)_etext - (unsigned long)_text;
>> -    create_mapping_late(__pa_symbol(_text), (unsigned long)_text,
>> -                section_size, PAGE_KERNEL_ROX);
>>    /*
>>     * mark .rodata as read only. Use __init_begin rather than __end_rodat=
a
>>     * to cover NOTES and EXCEPTION_TABLE.
>> @@ -484,7 +481,7 @@ static void __init map_kernel(pgd_t *pgd)
>> {
>>    static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vm=
linux_data;
>>=20
>> -    map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_te=
xt);
>> +    map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_ROX, &vmlinux_tex=
t);
>>    map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vm=
linux_rodata);
>>    map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
>>               &vmlinux_init);
>> --=20
>> 2.7.4
>>=20
