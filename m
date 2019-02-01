MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-15-thgarnie@chromium.org>
 <01000168a5b35a86-b79bfe67-191e-43bc-a5c7-0e74eac06195-000000@email.amazonses.com>
 <CAJcbSZGKR7dKVqNEDEO7Qzf7tnNqmL=p1uVKvsUefS=Hs-=iNA@mail.gmail.com> <01000168a6e5ab88-0deea73f-387f-4941-bd11-d1c161aac88a-000000@email.amazonses.com>
In-Reply-To: <01000168a6e5ab88-0deea73f-387f-4941-bd11-d1c161aac88a-000000@email.amazonses.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Fri, 1 Feb 2019 09:13:58 -0800
Message-ID: <CAJcbSZFvafvNX1pS96jaTBGNJad+NszLwSgKnRQgyT70gUGWqQ@mail.gmail.com>
Subject: Re: [PATCH v6 14/27] x86/percpu: Adapt percpu for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Christopher Lameter <cl@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kristen@linux.intel.com, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Cao jin <caoj.fnst@cn.fujitsu.com>, Brijesh Singh <brijesh.singh@amd.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Joerg Roedel <jroedel@suse.de>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 6:31 PM Christopher Lameter <cl@linux.com> wrote:
>
> On Thu, 31 Jan 2019, Thomas Garnier wrote:
>
> > The per-cpu symbols are in a section that is zero based to create
> > offsets. The compiler doesn't see them as offsets but as relative
> > symbol and try to relocate them. Given the distance between zero and
> > the mapped kernel is much larger than the instruction offset range, it
> > fails to do it.
>
> We switch that off in the linker. If that does not work with your
> modifications then you need to figure out how to update the link
> configuration.
>

It didn't work originally but I will revisit to see if I missed something.
