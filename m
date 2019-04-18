Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] x86_64: Disabling read-implies-exec when the stack is executable
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <alpine.DEB.2.21.1904181015270.3174@nanos.tec.linutronix.de>
Date: Thu, 18 Apr 2019 07:14:54 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <74755222-0B16-4A81-85F6-D2803E4C0334@amacapital.net>
References: <1462963502-11636-1-git-send-email-hecmargi@upv.es> <CAGXu5jLZ-DgTfokLTqUHOUphO4C1FwHgYDLTA1oB9HBHnH-a1Q@mail.gmail.com> <alpine.DEB.2.21.1904181015270.3174@nanos.tec.linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Hector Marco-Gisbert <hecmargi@upv.es>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Brian Gerst <brgerst@gmail.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Huaitong Han <huaitong.han@intel.com>, Ismael Ripoll Ripoll <iripoll@upv.es>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jason Gunthorpe <jgg@mellanox.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>


> On Apr 18, 2019, at 1:17 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
>> On Thu, 18 Apr 2019, Kees Cook wrote:
>> On Wed, May 11, 2016 at 5:45 AM Hector Marco-Gisbert <hecmargi@upv.es> wr=
ote:
>> *thread necromancy*
>>=20
>> I'd still like to see this get landed. READ_IMPLIES_EXEC is way too
>> powerful (it impacts, for example, mmap() regions of device driver
>> memory, forcing drivers to not be able to disallow VM_EXEC[1]).
>>=20
>> The only case it could break is on an AMD K8 (Athlon only, I assume?),
>> which seems unlikely to have a modern kernel run on it. If there is
>> still concern, then we could just test against the NX CPU feature:
>>=20
>> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
>> index 69c0f892e310..367cd36259a4 100644
>> --- a/arch/x86/include/asm/elf.h
>> +++ b/arch/x86/include/asm/elf.h
>> @@ -280,10 +280,12 @@ extern u32 elf_hwcap2;
>>=20
>> /*
>>  * An executable for which elf_read_implies_exec() returns TRUE will
>> - * have the READ_IMPLIES_EXEC personality flag set automatically.
>> + * have the READ_IMPLIES_EXEC personality flag set automatically when
>> + * a CPU did not support NX or is using a 32-bit memory layout.
>>  */
>> -#define elf_read_implies_exec(ex, executable_stack)    \
>> -       (executable_stack !=3D EXSTACK_DISABLE_X)
>> +#define elf_read_implies_exec(ex, executable_stack)            \
>> +       (mmap_is_ia32() || !(__supported_pte_mask & _PAGE_NX) ? \
>=20
> What's special about ia32? All what matters is whether PAGE_NX is supporte=
d
> or not. That has nothing to do with 32/64bit unless I'm missing something
> (as usual).
>=20
>=20

I have the opposite question: who cares if we have NX?  On a CPU without NX,=
 read implies exec, full stop. Why should nasty personality stuff matter at a=
ll?  The personality stuff is about supporting old crufty binaries.

So: are there old 64-bit binaries that have their stacks marked RX that expe=
ct mmap to automatically return X memory?  If so, then the patch is a proble=
m. If not, then maybe the patch is okay.

All that being said, the comment in the patch seems to be highly misleading.=
  If the patch is to be applied, the comment needs serious work.=
