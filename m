Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH 10/17] prmem: documentation
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALCETrXNckT9W288VXx-6inO5qYn-6dUPocKGcBT0GCO3xi3ZQ@mail.gmail.com>
Date: Tue, 13 Nov 2018 09:43:53 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <386C0CB1-C4B1-43E2-A754-DA8DBE4FB3CB@gmail.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <6f60afc9-0fed-7f95-a11a-9a2eef33094c@gmail.com>
 <CALCETrXNckT9W288VXx-6inO5qYn-6dUPocKGcBT0GCO3xi3ZQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

From: Andy Lutomirski
Sent: November 13, 2018 at 5:16:09 PM GMT
> To: Igor Stoppa <igor.stoppa@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra =
<peterz@infradead.org>, Nadav Amit <nadav.amit@gmail.com>, Mimi Zohar =
<zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave =
Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal =
Hocko <mhocko@kernel.org>, Kernel Hardening =
<kernel-hardening@lists.openwall.com>, linux-integrity =
<linux-integrity@vger.kernel.org>, LSM List =
<linux-security-module@vger.kernel.org>, Igor Stoppa =
<igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, =
Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, =
Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport =
<rppt@linux.vnet.ibm.com>, open list:DOCUMENTATION =
<linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas =
Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH 10/17] prmem: documentation
>=20
>=20
> On Tue, Nov 13, 2018 at 6:25 AM Igor Stoppa <igor.stoppa@gmail.com> =
wrote:
>> Hello,
>> I've been studying v4 of the patch-set [1] that Nadav has been =
working on.
>> Incidentally, I think it would be useful to cc also the
>> security/hardening ml.
>> The patch-set seems to be close to final, so I am resuming this =
discussion.
>>=20
>> On 30/10/2018 19:06, Andy Lutomirski wrote:
>>=20
>>> I support the addition of a rare-write mechanism to the upstream =
kernel.  And I think that there is only one sane way to implement it: =
using an mm_struct. That mm_struct, just like any sane mm_struct, should =
only differ from init_mm in that it has extra mappings in the *user* =
region.
>>=20
>> After reading the code, I see what you meant.
>> I think I can work with it.
>>=20
>> But I have a couple of questions wrt the use of this mechanism, in =
the
>> context of write rare.
>>=20
>>=20
>> 1) mm_struct.
>>=20
>> Iiuc, the purpose of the patchset is mostly (only?) to patch kernel =
code
>> (live patch?), which seems to happen sequentially and in a relatively
>> standardized way, like replacing the NOPs specifically placed in the
>> functions that need patching.
>>=20
>> This is a bit different from the more generic write-rare case, =
applied
>> to data.
>>=20
>> As example, I have in mind a system where both IMA and SELinux are in =
use.
>>=20
>> In this system, a file is accessed for the first time.
>>=20
>> That would trigger 2 things:
>> - evaluation of the SELinux rules and probably update of the AVC =
cache
>> - IMA measurement and update of the measurements
>>=20
>> Both of them could be write protected, meaning that they would both =
have
>> to be modified through the write rare mechanism.
>>=20
>> While the events, for 1 specific file, would be sequential, it's not
>> difficult to imagine that multiple files could be accessed at the =
same time.
>>=20
>> If the update of the data structures in both IMA and SELinux must use
>> the same mm_struct, that would have to be somehow regulated and it =
would
>> introduce an unnecessary (imho) dependency.
>>=20
>> How about having one mm_struct for each writer (core or thread)?
>=20
> I don't think that helps anything.  I think the mm_struct used for
> prmem (or rare_write or whatever you want to call it) should be
> entirely abstracted away by an appropriate API, so neither SELinux nor
> IMA need to be aware that there's an mm_struct involved.  It's also
> entirely possible that some architectures won't even use an mm_struct
> behind the scenes -- x86, for example, could have avoided it if there
> were a kernel equivalent of PKRU.  Sadly, there isn't.
>=20
>> 2) Iiuc, the purpose of the 2 pages being remapped is that the target =
of
>> the patch might spill across the page boundary, however if I deal =
with
>> the modification of generic data, I shouldn't (shouldn't I?) assume =
that
>> the data will not span across multiple pages.
>=20
> The reason for the particular architecture of text_poke() is to avoid
> memory allocation to get it working.  i think that prmem/rare_write
> should have each rare-writable kernel address map to a unique user
> address, possibly just by offsetting everything by a constant.  For
> rare_write, you don't actually need it to work as such until fairly
> late in boot, since the rare_writable data will just be writable early
> on.
>=20
>> If the data spans across multiple pages, in unknown amount, I suppose
>> that I should not keep interrupts disabled for an unknown time, as it
>> would hurt preemption.
>>=20
>> What I thought, in my initial patch-set, was to iterate over each =
page
>> that must be written to, in a loop, re-enabling interrupts in-between
>> iterations, to give pending interrupts a chance to be served.
>>=20
>> This would mean that the data being written to would not be =
consistent,
>> but it's a problem that would have to be addressed anyways, since it =
can
>> be still read by other cores, while the write is ongoing.
>=20
> This probably makes sense, except that enabling and disabling
> interrupts means you also need to restore the original mm_struct (most
> likely), which is slow.  I don't think there's a generic way to check
> whether in interrupt is pending without turning interrupts on.

I guess that enabling IRQs might break some hidden assumptions in the =
code,
but is there a fundamental reason that IRQs need to be disabled? =
use_mm()
got them enabled, although it is only suitable for kernel threads.
