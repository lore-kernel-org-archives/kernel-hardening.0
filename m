Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <20160809040142.GA11449@nazgul.tnic>
References: <1470681607-36883-1-git-send-email-thgarnie@google.com> <1470681607-36883-2-git-send-email-thgarnie@google.com> <20160809040142.GA11449@nazgul.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 08 Aug 2016 21:14:32 -0700
Message-ID: <22528348-DB08-44E2-B6C5-C4A1F50B8EF6@zytor.com>
Subject: [kernel-hardening] Re: [PATCH v1 2/2] x86/KASLR: Increase BRK pages for KASLR memory randomization
To: Borislav Petkov <bp@suse.de>, Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On August 8, 2016 9:01:42 PM PDT, Borislav Petkov <bp@suse.de> wrote:
>On Mon, Aug 08, 2016 at 11:40:07AM -0700, Thomas Garnier wrote:
>> Default implementation expects 6 pages maximum are needed for low
>page
>> allocations. If KASLR memory randomization is enabled, the worse case
>> of e820 layout would require 12 pages (no large pages). It is due to
>the
>> PUD level randomization and the variable e820 memory layout.
>
>Can't this number of required pages be computed based on the
>randomization offset or somesuch instead of maxing it out by default on
>every machine which enables CONFIG_RANDOMIZE_MEMORY?
>
>> This bug was found while doing extensive testing of KASLR memory
>> randomization on different type of hardware.
>> 
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>> Based on next-20160805
>> ---
>>  arch/x86/mm/init.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>> 
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 6209289..3a27e6a 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -130,6 +130,14 @@ void  __init early_alloc_pgt_buf(void)
>>  	unsigned long tables = INIT_PGT_BUF_SIZE;
>>  	phys_addr_t base;
>>  
>> +	/*
>> +	 * Depending on the machine e860 memory layout and the PUD
>alignement.
>
>				    e820			   alignment
>
>> +	 * We may need twice more pages when KASLR memoy randomization is
>
>						  memory
>
>> +	 * enabled.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_RANDOMIZE_MEMORY))
>> +		tables *= 2;
>> +
>>  	base = __pa(extend_brk(tables, PAGE_SIZE));
>>  
>>  	pgt_buf_start = base >> PAGE_SHIFT;
>> -- 
>> 2.8.0.rc3.226.g39d4020
>> 

Upping the brk by a few pages is not a big deal.  Unused brk gets reclaimed at init release time.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
