References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
 <1499724283-30719-3-git-send-email-labbott@redhat.com>
 <20170711195154.GA7124@leverpostej>
 <2f24df9e-64b1-ffef-ddbb-08f7fe8d2a96@redhat.com>
 <f100d5f3-fabc-a6b4-ef5f-91fc5f123299@linux.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <160e3088-b8e0-513b-8c1a-ce22ce598d5a@redhat.com>
Date: Fri, 21 Jul 2017 17:23:06 -0700
MIME-Version: 1.0
In-Reply-To: <f100d5f3-fabc-a6b4-ef5f-91fc5f123299@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [RFC][PATCH 2/2] arm64: Clear the stack
To: alex.popov@linux.com, Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Tycho Andersen <tycho@docker.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/21/2017 09:56 AM, Alexander Popov wrote:
> Hello Laura and Mark,
> 
> [+ Tycho Andersen and Pax Team]
> 
> On 14.07.2017 23:51, Laura Abbott wrote:
>> On 07/11/2017 12:51 PM, Mark Rutland wrote:
>>> On Mon, Jul 10, 2017 at 03:04:43PM -0700, Laura Abbott wrote:
>>>> +	/* The poison function */
>>>> +4:
>>>> +	/* Generate the address we found */
>>>> +	add     x5, x1, x3, lsl #3
>>>> +	orr     x5, x5, #16
>>>
>>> Have you figured out what the forced 16 byte offset is for?
>>>
>>> I've not managed to figure out why it's there, and it looks like
>>> Alexander couldn't either, judging by his comments in the x86 asm.
>>
>> From get_wchan in arch/x86/kernel/process.c, it might be be to
>> account for the start of the frame correctly? I don't have a
>> definitive answer though and plan on just removing this for the
>> next version.
> 
> I've investigated it carefully: we should not remove this 16-byte offset.
> 
> I looked at the bottom of the kernel stack with the debugger and found a
> non-zero value 0x57AC6E9D. It is STACK_END_MAGIC, which is defined in
> include/uapi/linux/magic.h. This value is checked if we enable
> CONFIG_SCHED_STACK_END_CHECK.
> 
> Then I removed this 16-byte offset in stackleak patch (including the OR
> instruction in erase_kstack()) to see how the first erase_kstack() call happily
> overwrites that magic value:
> 
> [    1.574655] Freeing unused kernel memory: 1244K
> [    1.575026] Kernel memory protection disabled.
> [    1.578575] Kernel panic - not syncing: corrupted stack end detected inside
> scheduler
> [    1.578575]
> [    1.579420] CPU: 0 PID: 1 Comm: init Not tainted 4.12.0+ #9
> [    1.579420] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [    1.579420] Call Trace:
> [    1.579420]  dump_stack+0x63/0x81
> [    1.579420]  panic+0xd0/0x212
> [    1.579420]  __schedule+0x6d8/0x6e0
> [    1.579420]  schedule+0x31/0x80
> [    1.579420]  io_schedule+0x11/0x40
> [    1.579420]  __lock_page_or_retry+0x17d/0x2b0
> [    1.579420]  ? page_cache_tree_insert+0x90/0x90
> [    1.579420]  filemap_fault+0x3aa/0x5c0
> [    1.579420]  ? filemap_map_pages+0x1a6/0x280
> [    1.579420]  ext4_filemap_fault+0x2d/0x40
> [    1.579420]  __do_fault+0x1b/0x60
> [    1.579420]  __handle_mm_fault+0x641/0x8b0
> [    1.579420]  handle_mm_fault+0x87/0x130
> [    1.579420]  __do_page_fault+0x25f/0x4a0
> [    1.579420]  trace_do_page_fault+0x37/0xd0
> [    1.579420]  do_async_page_fault+0x23/0x80
> [    1.579420]  async_page_fault+0x28/0x30
> [    1.579420] RIP: 0033:0x7f81be514ab0
> [    1.579420] RSP: 002b:00007ffc8de73768 EFLAGS: 00010202
> [    1.579420] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [    1.579420] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffc8de73770
> [    1.579420] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [    1.579420] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [    1.579420] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    1.579420] Dumping ftrace buffer:
> [    1.579420]    (ftrace buffer empty)
> [    1.579420] Kernel Offset: disabled
> [    1.579420] Rebooting in 86400 seconds..
> 
> 
> So let's keep it not to break CONFIG_SCHED_STACK_END_CHECK.
> 


That makes sense, good find! I wonder if CONFIG_SCHED_STACK_END_CHECK
should go on the list of hardening options and/or if we can enhance
it somehow?

I'm not sure why it requires two words though since the
poison only seems to be 32-bits?

> Again, I want to say kudos to PaX Team for his awesome code.

Agreed!

> Best regards,
> Alexander
> 

Thanks,
Laura
