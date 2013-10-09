Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5255D7D4.8050204@gmail.com>
Date: Thu, 10 Oct 2013 09:25:24 +1100
From: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
References: <5255D023.2030907@gmail.com>	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com> <1381356861.2050.33.camel@joe-AO722>
In-Reply-To: <1381356861.2050.33.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] vsprintf: Check real user/group id for %pK
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/10/13 09:14, Joe Perches wrote:
> On Thu, 2013-10-10 at 09:04 +1100, Ryan Mallon wrote:
>> On 10/10/13 09:00, Joe Perches wrote:
> []
>>> Move the interrupt tests and pK-error printk
>>> into case 1:
>>>
>>> It's the only case where CAP_SYSLOG needs to be
>>> tested so it doesn't need to be above the switch.
>>
>> Like I said, I think it is useful to do the pK-error check anyway. It is
>> checking for internal kernel bugs, since if 'pK-error' ever gets
>> printed, then some kernel code is doing the wrong thing.
> 
> I think you don't quite understand how kptr_restrict works.
> 
> If it's 0, then the ptr value is always emitted naturally.
> if it's 2, then the ptr value is always emitted as 0.

I understand this.

> 
>> Therefore, I
>> think it is useful to print it always (I would argue it even makes sense
>> when kptr_restrict=0).
> 
> How?  Maybe it's me that doesn't quite understand.

This check:

	if (kptr_restrict && (in_irq() || in_serving_softirq() ||
			      in_nmi())) {

Is making sure that you don't have kernel code doing something like this:

	irqreturn_t some_irq_handler(int irq, void *data)
	{
		struct seq_file *seq = to_seq(data);

		seq_printf(seq, "value = %pK\n");
		return IRQ_HANDLED;
	}

Because that obviously won't work when kptr_restrict=1 (because the
CAP_SYSLOG check is meaningless). However, the code is broken regardless
of the kptr_restrict value. Since the default value of kptr_restrict is
0, this kind of bug can go over-looked because the seq file will print
the pointer value correctly when kptr_restrict=0, and it will correctly
print 0's when kptr_restrict=2, but it will print 'pK-error' when
kptr_restrict=1. Doing the check in all cases makes it more likely that
bugs like this get found. In fact, doing something like:

	if (WARN_ON(in_irq() || in_serving_softirq() || in_nmi())) {

Might be better, since that will print a stack-trace showing where the
offending vsprintf is.

~Ryan
