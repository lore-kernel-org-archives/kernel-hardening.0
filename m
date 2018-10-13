MIME-Version: 1.0
References: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
 <20181011233117.7883-2-rick.p.edgecombe@intel.com> <CAG48ez2fWg64nGxDXUQS3695KpVNrakAbarXJnYPd6xv5wOD+A@mail.gmail.com>
 <7b0714e26c7c2216721641d7df16a49687927e37.camel@intel.com>
 <CAG48ez0XfGFAWDYa75COMPCsKqqGfBFOtcNuGD4_dubGf2YeAQ@mail.gmail.com> <657e6d0ada18e8ca0350bc6b3a80c49b3c0b341c.camel@intel.com>
In-Reply-To: <657e6d0ada18e8ca0350bc6b3a80c49b3c0b341c.camel@intel.com>
From: Jann Horn <jannh@google.com>
Date: Sat, 13 Oct 2018 02:09:09 +0200
Message-ID: <CAG48ez383rjt+v_DvLF902X33od_SwMh8dZ-6=w1DZ-YPZ_U9Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] modules: Create rlimit for module space
Content-Type: text/plain; charset="UTF-8"
To: rick.p.edgecombe@intel.com
Cc: linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, jeyu@kernel.org, Arjan van de Ven <arjan@linux.intel.com>, linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, kristen@linux.intel.com, deneen.t.dock@intel.com, Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, linux-arm-kernel@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, sparclinux@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 13, 2018 at 2:04 AM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> On Fri, 2018-10-12 at 19:22 +0200, Jann Horn wrote:
> > On Fri, Oct 12, 2018 at 7:04 PM Edgecombe, Rick P
> > <rick.p.edgecombe@intel.com> wrote:
> > > On Fri, 2018-10-12 at 02:35 +0200, Jann Horn wrote:
> > > > Why all the rbtree stuff instead of stashing a pointer in struct
> > > > vmap_area, or something like that?
> > >
> > > Since the tracking was not for all vmalloc usage, the intention was to not
> > > bloat
> > > the structure for other usages likes stacks. I thought usually there
> > > wouldn't be
> > > nearly as much module space allocations as there would be kernel stacks, but
> > > I
> > > didn't do any actual measurements on the tradeoffs.
> >
> > I imagine that one extra pointer in there - pointing to your struct
> > mod_alloc_user - would probably not be terrible. 8 bytes more per
> > kernel stack shouldn't be so bad?
>
> I looked into this and it starts to look a little messy. The nommu.c version of
> vmalloc doesn't use or expose access to vmap_area or vm_struct. So it starts to
> look like a bunch of IFDEFs to remove the rlimit in the nommu case or making a
> stand in that maintains pretend vm struct's in nommu.c. I had actually
> previously tried to at least pull the allocations size from vmalloc structs, but it broke on nommu.
>
> Thought I would check back and see. How important do you think this is?

I don't think it's important - I just thought that it would be nice to
avoid the extra complexity if it is easily avoidable.
