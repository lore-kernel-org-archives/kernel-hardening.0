Date: Fri, 8 Dec 2017 07:47:46 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171207204746.GI2191@eros>
References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-6-git-send-email-alex.popov@linux.com>
 <f7c64050-bbb6-be37-ec09-cb757bad116a@redhat.com>
 <5fb044ec-cf1e-6281-01a9-c845b738914e@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fb044ec-cf1e-6281-01a9-c845b738914e@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v6 5/6] fs/proc: Show STACKLEAK metrics in the /proc
 file system
To: Alexander Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 07, 2017 at 10:09:27AM +0300, Alexander Popov wrote:
> Hello Laura and Kees,
> 
> [adding Tobin C. Harding]
> 
> On 06.12.2017 22:22, Laura Abbott wrote:
> > On 12/05/2017 03:33 PM, Alexander Popov wrote:
> >> Introduce CONFIG_STACKLEAK_METRICS providing STACKLEAK information about
> >> tasks via the /proc file system. In particular, /proc/<pid>/lowest_stack
> >> shows the current lowest_stack value and its final value from the previous
> >> syscall. That information can be useful for estimating the STACKLEAK
> >> performance impact for different workloads.
> >>
> >> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> >> ---
> >>   arch/Kconfig                     | 11 +++++++++++
> >>   arch/x86/entry/entry_32.S        |  4 ++++
> >>   arch/x86/entry/entry_64.S        |  4 ++++
> >>   arch/x86/include/asm/processor.h |  3 +++
> >>   arch/x86/kernel/asm-offsets.c    |  3 +++
> >>   arch/x86/kernel/process_32.c     |  3 +++
> >>   arch/x86/kernel/process_64.c     |  3 +++
> >>   fs/proc/base.c                   | 14 ++++++++++++++
> >>   8 files changed, 45 insertions(+)
> 
> [...]
> 
> >> +#ifdef CONFIG_STACKLEAK_METRICS
> >> +static int proc_lowest_stack(struct seq_file *m, struct pid_namespace *ns,
> >> +				struct pid *pid, struct task_struct *task)
> >> +{
> >> +	seq_printf(m, "prev_lowest_stack: %pK\nlowest_stack: %pK\n",
> >> +		   (void *)task->thread.prev_lowest_stack,
> >> +		   (void *)task->thread.lowest_stack);
> >> +	return 0;
> >> +}
> >> +#endif /* CONFIG_STACKLEAK_METRICS */
> >> +
> > 
> > This just prints the hashed value with the new pointer leak work.
> > I don't think we want to print the fully exposed value via %px so
> > it's not clear how valuable this proc file is now.
> 
> Yes, I tested that before sending the patch. I was confused when I saw the
> hashed values. But setting kptr_restrict to 1 fixed that for me:
> 
> root@hobbit:~# cat /proc/2627/lowest_stack
> prev_lowest_stack: 00000000ed8ca991
> lowest_stack: 0000000040579d76
> root@hobbit:~# echo 1 > /proc/sys/kernel/kptr_restrict
> root@hobbit:~# cat /proc/2627/lowest_stack
> prev_lowest_stack: ffffc9000094fdb8
> lowest_stack: ffffc9000094f9e0
> 
> However, Documentation/printk-formats.txt and Documentation/sysctl/kernel.txt
> don't specify that behaviour.

thanks for pointing this out. Yes, %pK hashes the address now when
kptr_restrict==0

And yes, I forgot to update the docs :( will amend.

thanks,
Tobin.
