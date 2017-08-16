References: <1499883471-23822-1-git-send-email-alex.popov@linux.com>
 <20170815033834.2qbjj2of62udqyz3@smitten>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <93382ef8-105f-eed4-0d97-0b1a66a047e6@linux.com>
Date: Wed, 16 Aug 2017 23:47:44 +0300
MIME-Version: 1.0
In-Reply-To: <20170815033834.2qbjj2of62udqyz3@smitten>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v3 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Tycho Andersen <tycho@docker.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Tycho,

On 15.08.2017 06:38, Tycho Andersen wrote:
> On Wed, Jul 12, 2017 at 09:17:51PM +0300, Alexander Popov wrote:
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +void __used track_stack(void)
>> +{
>> +	unsigned long sp = (unsigned long)&sp;
>> +
>> +	if (sp < current->thread.lowest_stack &&
>> +	    sp >= (unsigned long)task_stack_page(current) +
>> +					2 * sizeof(unsigned long)) {
>> +		current->thread.lowest_stack = sp;
>> +	}
>> +
>> +	if (unlikely((sp & ~(THREAD_SIZE - 1)) < (THREAD_SIZE / 16)))
> 
> I think this check is wrong, the lhs should be
> (sp & (THREAD_SIZE - 1)). Otherwise, we just check that the upper bits
> of the stack are < THREAD_SIZE / 16, which they never will be.

Thank you, I think you are right!

I can additionally notice that this erroneous check is not a part of PaX patch,
it is introduced by Grsecurity patch.

Thanks again, I'll fix and annotate it in the next version of the patch.

Did you manage to create a test for the correct check which hits the BUG()?

Best regards,
Alexander
