MIME-Version: 1.0
References: <6f60afc9-0fed-7f95-a11a-9a2eef33094c@gmail.com>
 <CALCETrXNckT9W288VXx-6inO5qYn-6dUPocKGcBT0GCO3xi3ZQ@mail.gmail.com>
 <386C0CB1-C4B1-43E2-A754-DA8DBE4FB3CB@gmail.com> <CALCETrWWcfLK4W3mn0bavzejmMBVKMX29aAUA3+VPQ8m9vmfhw@mail.gmail.com>
 <9373ccf0-f51b-4bfa-2b16-e03ebf3c670d@huawei.com> <2e52e103-15d0-0c26-275f-894dfd07e8ec@huawei.com>
 <CALCETrV0sPgf4ZgG1joF_5hM-ycPsWM9DWGO=diQ_LQKin4VuA@mail.gmail.com>
 <1166e55c-0c06-195c-a501-383b4055ea46@gmail.com> <3BB9DE07-E0AE-43E2-99F1-E4AA774CD462@amacapital.net>
 <5e10c8e4-aa71-1eea-b1ce-50d7d0a60e8c@gmail.com> <20181122200416.GS3065@bombadil.infradead.org>
In-Reply-To: <20181122200416.GS3065@bombadil.infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Nov 2018 12:53:52 -0800
Message-ID: <CALCETrXB34QBcYk=k5DT1t4h7EezaPxbxM2S_h2nYk5Nv1c4_Q@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Andrew Lutomirski <luto@kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 22, 2018 at 12:04 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Nov 22, 2018 at 09:27:02PM +0200, Igor Stoppa wrote:
> > I have studied the code involved with Nadav's patchset.
> > I am perplexed about these sentences you wrote.
> >
> > More to the point (to the best of my understanding):
> >
> > poking_init()
> > -------------
> >   1. it gets one random poking address and ensures to have at least 2
> >      consecutive PTEs from the same PMD
> >   2. it then proceeds to map/unmap an address from the first of the 2
> >      consecutive PTEs, so that, later on, there will be no need to
> >      allocate pages, which might fail, if poking from atomic context.
> >   3. at this point, the page tables are populated, for the address that
> >      was obtained at point 1, and this is ok, because the address is fixed
> >
> > write_rare
> > ----------
> >   4. it can happen on any available core / thread at any time, therefore
> >      each of them needs a different address
>
> No?  Each CPU has its own CR3 (eg each CPU might be running a different
> user task).  If you have _one_ address for each allocation, it may or
> may not be mapped on other CPUs at the same time -- you simply don't care.
>
> The writable address can even be a simple formula to calculate from
> the read-only address, you don't have to allocate an address in the
> writable mapping space.
>

Agreed.  I suggest the formula:

writable_address = readable_address - rare_write_offset.  For
starters, rare_write_offset can just be a constant.  If we want to get
fancy later on, it can be randomized.

If we do it like this, then we don't need to modify any pagetables at
all when we do a rare write.  Instead we can set up the mapping at
boot or when we allocate the rare write space, and the actual rare
write code can just switch mms and do the write.
