MIME-Version: 1.0
In-Reply-To: <CA+55aFxLEL+8YA4MYkeyeUH7K8rZwBmGe6Z9V8QS=TYCREWDTQ@mail.gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128085500.djlm5rlbhjlpfj4i@gmail.com> <CAPcyv4jTaskPT1qXhdCO2mWVkcaMDMBq12vUJ_hSfjOU49qvgQ@mail.gmail.com>
 <alpine.DEB.2.20.1801281931180.2126@nanos> <CAPcyv4hSZ7=+076s+fmJ0HQ293H4X8829-LTrbvd8ZqJygGV6A@mail.gmail.com>
 <CA+55aFxLEL+8YA4MYkeyeUH7K8rZwBmGe6Z9V8QS=TYCREWDTQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Jan 2018 12:13:18 -0800
Message-ID: <CAPcyv4jTbH6As_SC2Po8j5mB6jKLcwMr3Yn=19aTN2yMgBR=iw@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] array_idx: sanitize speculative array de-references
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arjan Van De Ven <arjan.van.de.ven@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

[ adding Arjan ]

On Tue, Jan 30, 2018 at 11:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
[..]
> Anyway, I do think the patches I've seen so far are ok, and the real
> reason I'm writing this email is actually more about future patches:
> do we have a good handle on where these array index sanitations will
> be needed?
>
> Also, while array limit checking was obviously the official
> "spectre-v1" issue, I do wonder if there are possible other issues
> where mispredicted conditional branches can end up leaking
> information?
>
> IOW, is there some work on tooling/analysis/similar? Not asking for
> near-term, but more of a "big picture" question..
>
>             Linus
