MIME-Version: 1.0
In-Reply-To: <1490811363-93944-5-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org> <1490811363-93944-5-git-send-email-keescook@chromium.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Mar 2017 15:38:43 -0700
Message-ID: <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 11:15 AM, Kees Cook <keescook@chromium.org> wrote:
> Based on PaX's x86 pax_{open,close}_kernel() implementation, this
> allows HAVE_ARCH_RARE_WRITE to work on x86.
>

> +
> +static __always_inline unsigned long __arch_rare_write_begin(void)
> +{
> +       unsigned long cr0;
> +
> +       preempt_disable();

This looks wrong.  DEBUG_LOCKS_WARN_ON(!irqs_disabled()) would work,
as would local_irq_disable().  There's no way that just disabling
preemption is enough.

(Also, how does this interact with perf nmis?)

--Andy
