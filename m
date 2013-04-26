Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <517AFC6E.4020800@zytor.com>
Date: Fri, 26 Apr 2013 15:15:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1367003005-5560-7-git-send-email-keescook@chromium.org> <20130426221301.GA26059@pd.tnic>
In-Reply-To: <20130426221301.GA26059@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: report kernel offset on panic
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/26/2013 03:13 PM, Borislav Petkov wrote:
> On Fri, Apr 26, 2013 at 12:03:25PM -0700, Kees Cook wrote:
>> When the system panics, include the kernel offset in the report to assist
>> in debugging.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/x86/kernel/setup.c |   24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index fae9134..95a33b1 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -830,6 +830,18 @@ static void __init trim_low_memory_range(void)
>>  }
>>  	
>>  /*
>> + * Dump out kernel offset information on panic.
>> + */
>> +static int
>> +dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
>> +{
>> +	pr_emerg("Kernel Offset: 0x%lx\n",
>> +		 (unsigned long)&_text - __START_KERNEL);
> 
> So what's wrong with subtracting the offset from the function addresses
> on the stack so that traces can show the addresses as they are in
> vmlinux, completely agnostic of any randomization?
> 

That really makes it harder to figure out what the heck the register
content may mean...

	-hpa
