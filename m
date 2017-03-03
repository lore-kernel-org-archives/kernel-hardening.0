MIME-Version: 1.0
In-Reply-To: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com>
References: <1488466831-13918-1-git-send-email-hoeun.ryu@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Mar 2017 12:50:28 -0800
Message-ID: <CALCETrVNRbswNWeoVLdntdNXmb4ur3a-xiVNqALajHNG-bLJgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] arm64: support HAVE_ARCH_RARE_WRITE
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, PaX Team <pageexec@freemail.hu>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 2, 2017 at 7:00 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> +unsigned long __rare_write_rw_alias_start = TASK_SIZE_64 / 4;
> +
> +__always_inline unsigned long __arch_rare_write_map(void)
> +{
> +       struct mm_struct *mm = &rare_write_mm;
> +
> +       preempt_disable();
> +
> +       __switch_mm(mm);

...

> +__always_inline unsigned long __arch_rare_write_unmap(void)
> +{
> +       struct mm_struct *mm = current->active_mm;
> +
> +       __switch_mm(mm);
> +

This reminds me: this code imposes constraints on the context in which
it's called.  I'd advise making it very explicit, asserting
correctness, and putting the onus on the caller to set things up.  For
example:

DEBUG_LOCKS_WARN_ON(preemptible() || in_interrupt() || in_nmi());

in both the map and unmap functions, along with getting rid of the
preempt_disable().  I don't think we want the preempt-disabledness to
depend on the arch.  The generic non-arch rare_write helpers can do
the preempt_disable().

This code also won't work if the mm is wacky when called.  On x86, we could do:

DEBUG_LOCKS_WARN_ON(read_cr3() != current->active_mm->pgd);

or similar (since that surely doesn't compile as is).

--Andy
