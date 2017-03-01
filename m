MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jKTunStRbQ0FpuZpE5bXkmbv0wPmHYqJB2HNxnOzUTvXw@mail.gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org>
 <1488270174.1747.11.camel@gmail.com> <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
 <20170301104337.GA28874@leverpostej> <CAGXu5jKTunStRbQ0FpuZpE5bXkmbv0wPmHYqJB2HNxnOzUTvXw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 1 Mar 2017 12:31:24 -0800
Message-ID: <CAGXu5j+EAXaSHL_6r65OcaMS687ijxmiJaYhYG66-HrJi6uuVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Mark Rutland <mark.rutland@arm.com>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 1, 2017 at 12:13 PM, Kees Cook <keescook@chromium.org> wrote:

> Here's some sed output: http://paste.ubuntu.com/24092015/
>
> grsecurity currently has 314 instances of using
> pax_open/close_kernel(). The number of lines of code between them is
> about half a single line, but there is a lot of variation on how it's
> used:
>
> count  lines-of-code
>     164 1
>      72 2
>      21 3
>      20 4
>       2 5
>       8 6
>       3 7
>       2 8
>       1 9
>      18 10+

Oops, bug in grsecurity fooled my scripts and evaded detection.
There's another 3 line use. If you search the pastebin for
pax_open_kernel, you can see a giant bit in the middle that isn't
supposed to be there:

drivers/pci/hotplug/cpcihp_zt5550.c
       pax_open_kernel();
       const_cast(zt5550_hpc_ops.enable_irq) = zt5550_hc_enable_irq;
       const_cast(zt5550_hpc_ops.disable_irq) = zt5550_hc_disable_irq;
       const_cast(zt5550_hpc_ops.check_irq) = zt5550_hc_check_irq;
       pax_open_kernel();

I'll send a patch...

-Kees

-- 
Kees Cook
Pixel Security
