From: Jiong Wang <Jiong.Wang@arm.com>
Date: Tue, 25 Jul 2017 14:00:56 +0000
Message-ID: <DB6PR0802MB2405BBA6E6D545F35F0154A39FB80@DB6PR0802MB2405.eurprd08.prod.outlook.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <20170721170509.GC1538@e103592.cambridge.arm.com>,<20170725120630.GA8116@leverpostej>
In-Reply-To: <20170725120630.GA8116@leverpostej>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH 00/11] ARMv8.3 pointer authentication userspace support
To: Dave P Martin <Dave.Martin@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Mark Rutland <Mark.Rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

> > * Should the kernel remove PACs when unwinding user stacks?
> >
> >   This is simple to do, but it's arguably placing a policy in the kerne=
l as to
> >   what we expect user stacks to look like. Regardless, userspace will h=
ave to
> >   perform this when unwinding with DWARF.
>>
>> Not sure.  This is arguably not more gross than related things the
>> kernel already does, and may be inefficient for userspace to do e.g.,
>> when capturing perf backtraces.  Still gross though.
>>
>> Side question: do you know whether there will be DWARF / ELF annotations
>> for this?  Since ptr auth is a compile-time option, it is plausible that
>> an attribute could be added to indicate that an image uses it.

> Jiong, Yao, can you answer this?
>
> I think that there's DWARF metadata for unwinding, but I'm not sure
> there's an ELF annotation on an image.
>
> Note that you may link with libraries which may or may not use pointer
> auth, so a single process can have a mixture of code using pointer auth,
> and code which does not.

Yes, there is new DWARF frame information for pointer authentication to des=
cribe
the signing status at instruction level.  There is no ELF annotation on an =
image.

As the use cases of pointer authentication extension in GCC are about retur=
n
address signing.  The DWARF extension is mostly around describing signed LR=
 so
the unwinder could have a way to figure out the original value of it to con=
tinue
unwinding.

In general, whenever return address, i.e. LR register, is mangled or restor=
ed by
hardware instruction, compiler (or assembly writer) is expected to generate=
 a
DW_CFA_AARCH64_negate_ra_state CFA instruction.

For DWARF unwinder, during unwinding, whenever a DW_CFA_AARCH64_negate_ra_s=
tate
is hit, the unwinder toggle the LR signing status and kept it in bit zero (=
lsb)
of a new DWARF register AARCH64_DWARF_PAUTH_RA_STATE whose value must be ho=
nored
later when unwinding the value of LR. If the lsb of AARCH64_DWARF_PAUTH_RA_=
STATE
is set, it means the return address is mangled, then the unwinder needs to
restore LR by either masking off the signature (userspace unwinders need pt=
race
interface to get this) or executing signature strip instruction (can only b=
e
done by native unwinder) or executing authentication instruction (can only =
be
done by native unwinder).

Please see the following links for more details:
  https://gcc.gnu.org/ml/gcc-patches/2017-01/msg00376.html
  https://gcc.gnu.org/ml/gcc-patches/2016-11/msg03010.html


Regards,
Jiong

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
