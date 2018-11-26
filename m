Subject: Re: [PATCH] x86/fpu: XRSTOR is expected to raise #GP
References: <20181126172706.184008-1-jannh@google.com>
 <20181126174945.r2ubrlg2gzwog2ez@linutronix.de>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <4d4c4f1f-72e3-0182-151e-8bd455ccd143@zytor.com>
Date: Mon, 26 Nov 2018 11:49:37 -0800
MIME-Version: 1.0
In-Reply-To: <20181126174945.r2ubrlg2gzwog2ez@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 11/26/18 9:49 AM, Sebastian Andrzej Siewior wrote:
> On 2018-11-26 18:27:06 [+0100], Jann Horn wrote:
>> commit 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess
>> fixups") incorrectly replaced the fixup entry for XSTATE_OP with a
>> user-#PF-only fixup. However, XRSTOR can also raise #GP when the supplied
>> address points to userspace memory. Change it back.
> 
> The #GP is raised if the xstate content is invalid. But I guess the
> details don't matter.
> 
>> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Fixes: 75045f77f7a7 ("x86/extable: Introduce _ASM_EXTABLE_UA for uaccess fixups")
>> Signed-off-by: Jann Horn <jannh@google.com>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 

It does matter -- please correct the patch description, or we might have some
serious confusion at some arbitrary point in the future with the result that
the bug gets re-introduced; it would not be the first time.

	-hpa
