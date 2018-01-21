Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <867402A5-BED8-4A44-9770-7D3B153BEE82@amacapital.net>
Date: Sun, 21 Jan 2018 11:25:03 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD22AEA7-8C04-466E-99D8-C763B8E73CAF@amacapital.net>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com> <151648239535.34747.4422108674633222531.stgit@dwillia2-desk3.amr.corp.intel.com> <867402A5-BED8-4A44-9770-7D3B153BEE82@amacapital.net>
Subject: [kernel-hardening] Re: [PATCH v4.1 07/10] x86: narrow out of bounds syscalls to sys_read under speculation
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>



> On Jan 21, 2018, at 11:16 AM, Andy Lutomirski <luto@amacapital.net> wrote:=

>=20
>=20
>=20
>> On Jan 20, 2018, at 1:06 PM, Dan Williams <dan.j.williams@intel.com> wrot=
e:
>>=20
>> The syscall table base is a user controlled function pointer in kernel
>> space. Like, 'get_user, use 'MASK_NOSPEC' to prevent any out of bounds
>> speculation. While retpoline prevents speculating into the user
>> controlled target it does not stop the pointer de-reference, the concern
>> is leaking memory relative to the syscall table base.
>>=20
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> arch/x86/entry/entry_64.S   |    2 ++
>> arch/x86/include/asm/smap.h |    9 ++++++++-
>> 2 files changed, 10 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
>> index 63f4320602a3..584f6d2236b3 100644
>> --- a/arch/x86/entry/entry_64.S
>> +++ b/arch/x86/entry/entry_64.S
>> @@ -35,6 +35,7 @@
>> #include <asm/asm.h>
>> #include <asm/smap.h>
>> #include <asm/pgtable_types.h>
>> +#include <asm/smap.h>
>> #include <asm/export.h>
>> #include <asm/frame.h>
>> #include <asm/nospec-branch.h>
>> @@ -260,6 +261,7 @@ entry_SYSCALL_64_fastpath:
>>   cmpl    $__NR_syscall_max, %eax
>> #endif
>>   ja    1f                /* return -ENOSYS (already in pt_regs->ax) */
>> +    MASK_NOSPEC %r11 %rax            /* sanitize syscall_nr wrt speculat=
ion */
>=20
> What's the threat you're protecting against?  No one does any computation o=
r data dependent loads based on the value being read.  Or are you worried ab=
out ASLR leaks due to merely speculatively loading from a bogus address.

Also, the actual guard you're using is unfortunate.  At the very least, it's=
 a maintenance disaster.  Get rid of the macro and open code it.  It's two i=
nstructions and it has crazy clobber requirements *and* a flag dependency.

But I think it's also just a bad way to do it.  You're making the dependency=
 chain longer in a place where it matters, and the retpoline prevents the CP=
U from hiding that latency.  Just use an immediate mask with andq.  Realisti=
cally, you should be fine rounding the table size up to a power of two witho=
ut even extending the table, since I think this, at best, protects against A=
SLR bypass.=
