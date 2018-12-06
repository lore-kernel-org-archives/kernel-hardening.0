MIME-Version: 1.0
References: <20181204160304.GB7195@arm.com> <51281e69a3722014f718a6840f43b2e6773eed90.camel@intel.com>
 <CALCETrUiEWkSjnruCbBSi8WsDm071YiU5WEqoPhZbjezS0CrFw@mail.gmail.com>
 <20181205114148.GA15160@arm.com> <CALCETrUdTShjY+tQoRsE1uR1cnL9cr2Trbz-g5=WaLGA3rWXzA@mail.gmail.com>
 <CAKv+Gu_EEjhwbfp1mdB0Pu3ZyAsZgNeaCDArs569hAeWzHMWpw@mail.gmail.com>
 <CALCETrVedB7yacMU=i3JaUZxiwsnM+PnABfG48K9TZK32UWshA@mail.gmail.com>
 <CAKv+Gu_Fo3qG1DaA2T1MZZau_7e6rzZQY7eJ49FQDQe0QnOgHg@mail.gmail.com>
 <CALCETrUUe+X6dAfcqkL=Lncy5RyDHx6m4s1g9QgMWPE9kOBoVw@mail.gmail.com>
 <CAKv+Gu8pQcb_5AoRS8yyvT0FxHTe=yUQYNoQX2z6mysyC9noZA@mail.gmail.com> <20181206193108.GA21002@arm.com>
In-Reply-To: <20181206193108.GA21002@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 6 Dec 2018 20:36:28 +0100
Message-ID: <CAKv+Gu-NhxUFuce+tZmpiZPLrsNaKWKjtHAg0-6iBnR1VEWc0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmalloc: New flag for flush before releasing pages
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Will Deacon <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Nadav Amit <nadav.amit@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, Linux-MM <linux-mm@kvack.org>, Jann Horn <jannh@google.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Peter Zijlstra <peterz@infradead.org>, kristen@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, anil.s.keshavamurthy@intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masami Hiramatsu <mhiramat@kernel.org>, naveen.n.rao@linux.vnet.ibm.com, "David S. Miller" <davem@davemloft.net>, "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 6 Dec 2018 at 20:30, Will Deacon <will.deacon@arm.com> wrote:
>
> On Thu, Dec 06, 2018 at 08:23:20PM +0100, Ard Biesheuvel wrote:
> > On Thu, 6 Dec 2018 at 20:21, Andy Lutomirski <luto@kernel.org> wrote:
> > >
> > > On Thu, Dec 6, 2018 at 11:04 AM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > On Thu, 6 Dec 2018 at 19:54, Andy Lutomirski <luto@kernel.org> wrot=
e:
> > > > >
> > >
> > > > > That=E2=80=99s not totally nuts. Do we ever have code that expect=
s __va() to
> > > > > work on module data?  Perhaps crypto code trying to encrypt stati=
c
> > > > > data because our APIs don=E2=80=99t understand virtual addresses.=
  I guess if
> > > > > highmem is ever used for modules, then we should be fine.
> > > > >
> > > >
> > > > The crypto code shouldn't care, but I think it will probably break =
hibernate :-(
> > >
> > > How so?  Hibernate works (or at least should work) on x86 PAE, where
> > > __va doesn't work on module data, and, on x86, the direct map has som=
e
> > > RO parts with where the module is, so hibernate can't be writing to
> > > the memory through the direct map with its final permissions.
> >
> > On arm64 at least, hibernate reads the contents of memory via the
> > linear mapping. Not sure about other arches.
>
> Can we handle this like the DEBUG_PAGEALLOC case, and extract the pfn fro=
m
> the pte when we see that it's PROT_NONE?
>

As long as we can easily figure out whether a certain linear address
is mapped or not, having a special case like that for these mappings
doesn't sound unreasonable.
