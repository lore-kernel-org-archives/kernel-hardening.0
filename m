MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 1 Feb 2019 08:59:21 +1300
Message-ID: <CAGXu5jLGFd2UY89bPm_WQvcsX+RDMg0XoJvuXwfknJrGxpn4Ng@mail.gmail.com>
Subject: Re: [PATCH v6 00/27] x86: PIE support and option to extend KASLR randomization
Content-Type: text/plain; charset="UTF-8"
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Steven Rostedt <rostedt@goodmis.org>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Stefano Stabellini <sstabellini@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Jason Baron <jbaron@akamai.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Thomas Garnier <thgarnie@google.com>, Baoquan He <bhe@redhat.com>, Alexander Popov <alex.popov@linux.com>, Jordan Borgner <mail@jordan-borgner.de>, Nathan Chancellor <natechancellor@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H.J. Lu" <hjl.tools@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, Nadav Amit <namit@vmware.com>, Yonghong Song <yhs@fb.com>, Nick Desaulniers <ndesaulniers@google.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Jann Horn <jannh@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Jan Kiszka <jan.kiszka@siemens.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, Jan Beulich <JBeulich@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, =?UTF-8?Q?Rafael_=C3=81vila_de_Esp=C3=ADndola?= <rafael@espindo.la>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Nicholas Piggin <npiggin@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Song Liu <songliubraving@fb.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Michael Forney <forney@google.com>, Palmer Dabbelt <palmer@sifive.com>, James Hogan <jhogan@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, nixiaoming <nixiaoming@huawei.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, KVM <kvm@vger.kernel.org>, virtualization@lists.linux-foundation.org, Linux PM list <linux-pm@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 1, 2019 at 8:28 AM Thomas Garnier <thgarnie@chromium.org> wrote:
> These patches make the changes necessary to build the kernel as Position
> Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
> the top 2G of the virtual address space. It allows to optionally extend the
> KASLR randomization range from 1G to 3G. The chosen range is the one currently
> available, future changes will allow the kernel module to have a wider
> randomization range.

This also lays the groundwork for doing compilation-unit-granularity
KASLR, as Kristen has been working on. With PIE working, the
relocations are more sane and boot-time reordering becomes possible
(or at least, it becomes the same logically as doing the work on
modules, etc).

-- 
Kees Cook
