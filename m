MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131214038.GI28234@char.us.oracle.com>
In-Reply-To: <20190131214038.GI28234@char.us.oracle.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Thu, 31 Jan 2019 14:42:21 -0800
Message-ID: <CAJcbSZE890YgtEv_Z9A3kPukQzmZmgo0xM=pruMB3uTziBFwMw@mail.gmail.com>
Subject: Re: [PATCH v6 00/27] x86: PIE support and option to extend KASLR randomization
Content-Type: text/plain; charset="UTF-8"
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Steven Rostedt <rostedt@goodmis.org>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Stefano Stabellini <sstabellini@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Jason Baron <jbaron@akamai.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Baoquan He <bhe@redhat.com>, Alexander Popov <alex.popov@linux.com>, Jordan Borgner <mail@jordan-borgner.de>, Nathan Chancellor <natechancellor@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H.J. Lu" <hjl.tools@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, Nadav Amit <namit@vmware.com>, Yonghong Song <yhs@fb.com>, Nick Desaulniers <ndesaulniers@google.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Jann Horn <jannh@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Jan Kiszka <jan.kiszka@siemens.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Brijesh Singh <brijesh.singh@amd.com>, Jan Beulich <JBeulich@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, =?UTF-8?Q?Rafael_=C3=81vila_de_Esp=C3=ADndola?= <rafael@espindo.la>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Nicholas Piggin <npiggin@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Song Liu <songliubraving@fb.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Michael Forney <forney@google.com>, Palmer Dabbelt <palmer@sifive.com>, James Hogan <jhogan@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, nixiaoming <nixiaoming@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-kbuild@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, virtualization@lists.linux-foundation.org, Linux PM list <linux-pm@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 1:41 PM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Thu, Jan 31, 2019 at 11:24:07AM -0800, Thomas Garnier wrote:
> > There has been no major concern in the latest iterations. I am interested on
> > what would be the best way to slowly integrate this patchset upstream.
>
> One question that I was somehow expected in this cover letter - what
> about all those lovely speculative bugs? As in say some one hasn't
> updated their machine with the Spectre v3a microcode - wouldn't they
> be able to get the kernel virtual address space?

Yes they would be.

>
> In effect rendering all this hard-work not needed?

Only if we think Spectre bugs will never be fixed.
