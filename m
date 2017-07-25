Sender: Hans Liljestrand <ishkamiel@gmail.com>
Date: Tue, 25 Jul 2017 10:10:52 +0300
From: Hans Liljestrand <liljestrandh@gmail.com>
Message-ID: <20170725071052.3jyir34bnpeokldg@ishxps>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
 <20170724133824.27223-2-LiljestrandH@gmail.com>
 <CAGXu5jLB9h0sXVP-JxST_oJX9qCiBWrVNWNkCiq_CTqkgD-_VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jLB9h0sXVP-JxST_oJX9qCiBWrVNWNkCiq_CTqkgD-_VQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 1/5] x86: add CONFIG_X86_INTEL_MPX_KERNEL to Kconfig
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 07:51:34PM -0700, Kees Cook wrote:
>On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
><liljestrandh@gmail.com> wrote:
>> Add CONFIG_X86_INTEL_MPX_KERNEL for future kernel-space support for
>> Intel MPX. Currently depends on CPU_SUP_INTEL.
>>
>> Signed-off-by: Hans Liljestrand <LiljestrandH@gmail.com>
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> ---
>>  arch/x86/Kconfig | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 0efb4c9497bc..b740a8604705 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1771,6 +1771,25 @@ config X86_INTEL_MPX
>>
>>           If unsure, say N.
>>
>> +config X86_INTEL_MPX_KERNEL
>> +       prompt "Intel MPX for kernel"
>> +       def_bool n
>> +       depends on CPU_SUP_INTEL
>> +       select CONSTRUCTORS
>> +       select GCC_PLUGINS
>
>GCC_PLUGINS should be a "depends" here, so that when we finally get
>compile-support-testing hooked up to Kconfig we won't get some nasty
>surprises.

Okay, sounds good. Also realized the CONSTRUCTORS thing is an old leftover, we 
don't use those anymore.

>
>> +       ---help---
>> +         MPX provides hardware features that can be used in
>> +         conjunction with compiler-instrumented code to check
>> +         memory references.  It is designed to detect buffer
>> +         overflow or underflow bugs.
>> +
>> +         This option enables MPXK, which is a slightly modified
>> +         MPX instrumentation for in-kernel code.  This
>> +         protection is modular and even when enabled covers
>> +         only code that explicitly use this feature.
>> +
>> +         If unsure, say N
>
>I think this Kconfig should live in whichever patch actually starts
>adding things (maybe patch 2?)

Ok, thanks!

-hans

>
>-Kees
>
>> +
>>  config X86_INTEL_MEMORY_PROTECTION_KEYS
>>         prompt "Intel Memory Protection Keys"
>>         def_bool y
>> --
>> 2.11.0
>>
>
>
>
>-- 
>Kees Cook
>Pixel Security
