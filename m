MIME-Version: 1.0
In-Reply-To: <CA+55aFxLOMcSfodeV5WV=n0+tuz7rVs4bEtnfv9qT9c8H0TfLA@mail.gmail.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648239535.34747.4422108674633222531.stgit@dwillia2-desk3.amr.corp.intel.com>
 <867402A5-BED8-4A44-9770-7D3B153BEE82@amacapital.net> <CAG48ez3dWLJEoiUOLKRD3e8uJmAz87FNQB5MOLTxJg=y3KahRw@mail.gmail.com>
 <CALCETrVxf06iNYWUxtsBU4ApNSK0jbnEUBoSvnGGQ7z1cyPJ9A@mail.gmail.com> <CA+55aFxLOMcSfodeV5WV=n0+tuz7rVs4bEtnfv9qT9c8H0TfLA@mail.gmail.com>
From: Samuel Neves <samuel.c.p.neves@gmail.com>
Date: Mon, 22 Jan 2018 11:59:55 +0000
Message-ID: <CAEX_ruEw_0R4XZWXhdpDQHpEbf23CRCNvgQjAKiLs-TMycXd=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v4.1 07/10] x86: narrow out of
 bounds syscalls to sys_read under speculation
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 22, 2018 at 2:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> However, I suspect it actually has a slightly higher register
> pressure, since you'd need to have that zero register (zero being the
> "safe" value), and the only good way to get a zero value is the xor
> thing, which affects flags and thus needs to be before the cmp.
>
> In contrast, the sbb trick has no early inputs needed.

On the flipside, sbb carries a false dependency [*] on the destination
register. Imagine something like

divq %rcx
...
cmpq %rdi, %rsi
sbbq %rax,%rax

sbb needs to wait not only for the comparison, but also for the
earlier unrelated slow division. On the other hand, zeroing with mov
or xor breaks dependencies on the destination register, making the
computation independent of what came before.

[*] Recent AMD chips are smart enough to understand the sbb r,r idiom
and ignore the value of r, but as far as I know none of the Intel
chips do.
