Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 10/17] prmem: documentation
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20181031100237.GN744@hirez.programming.kicks-ass.net>
Date: Wed, 31 Oct 2018 13:36:48 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <659CFC78-22BF-492B-B2E4-B8E89AA08446@amacapital.net>
References: <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com> <20181030152641.GE8177@hirez.programming.kicks-ass.net> <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com> <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net> <20181030175814.GB10491@bombadil.infradead.org> <20181030182841.GE7343@cisco> <20181030192021.GC10491@bombadil.infradead.org> <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com> <20181030213557.GE10491@bombadil.infradead.org> <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com> <20181031100237.GN744@hirez.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>


> On Oct 31, 2018, at 3:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>> On Tue, Oct 30, 2018 at 09:41:13PM -0700, Andy Lutomirski wrote:
>> To clarify some of this thread, I think that the fact that rare_write
>> uses an mm_struct and alias mappings under the hood should be
>> completely invisible to users of the API.  No one should ever be
>> handed a writable pointer to rare_write memory (except perhaps during
>> bootup or when initializing a large complex data structure that will
>> be rare_write but isn't yet, e.g. the policy db).
>=20
> Being able to use pointers would make it far easier to do atomics and
> other things though.

This stuff is called *rare* write for a reason. Do we really want to allow a=
tomics beyond just store-release?  Taking a big lock and then writing in the=
 right order should cover everything, no?

>=20
>> For example, there could easily be architectures where having a
>> writable alias is problematic.
>=20
> Mostly we'd just have to be careful of cache aliases, alignment should
> be able to sort that I think.
>=20
>> If you have multiple pools and one mm_struct per pool, you'll need a
>> way to find the mm_struct from a given allocation.
>=20
> Or keep track of it externally. For example by context. If you modify
> page-tables you pick the page-table pool, if you modify selinux state,
> you pick the selinux pool.
>=20
>> Regardless of how the mm_structs are set up, changing rare_write
>> memory to normal memory or vice versa will require a global TLB flush
>> (all ASIDs and global pages) on all CPUs, so having extra mm_structs
>> doesn't seem to buy much.
>=20
> The way I understand it, the point is that if you stick page-tables and
> selinux state in different pools, a stray write in one will never affect
> the other.
>=20

Hmm. That=E2=80=99s not totally crazy, but the API would need to be carefull=
y designed. And some argument would have to be made as to why it=E2=80=99s b=
etter to use a different address space as opposed to checking in software al=
ong the lines of the uaccess checking.=
