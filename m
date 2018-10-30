MIME-Version: 1.0
In-Reply-To: <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
References: <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com> <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net> <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net> <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net> <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco> <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com> <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 Oct 2018 14:07:45 -0700
Message-ID: <CAGXu5j+58PcvXmt6qp4aZdDz_pBFV-P_rmp3zg6vQnpMvoMdXA@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andy Lutomirski <luto@amacapital.net>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 2:02 PM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
>
>
>> On Oct 30, 2018, at 1:43 PM, Igor Stoppa <igor.stoppa@gmail.com> wrote:
>>
>>> On 30/10/2018 21:20, Matthew Wilcox wrote:
>>>> On Tue, Oct 30, 2018 at 12:28:41PM -0600, Tycho Andersen wrote:
>>>>> On Tue, Oct 30, 2018 at 10:58:14AM -0700, Matthew Wilcox wrote:
>>>>> On Tue, Oct 30, 2018 at 10:06:51AM -0700, Andy Lutomirski wrote:
>>>>>>> On Oct 30, 2018, at 9:37 AM, Kees Cook <keescook@chromium.org> wrot=
e:
>>>>>> I support the addition of a rare-write mechanism to the upstream ker=
nel.
>>>>>> And I think that there is only one sane way to implement it: using a=
n
>>>>>> mm_struct. That mm_struct, just like any sane mm_struct, should only
>>>>>> differ from init_mm in that it has extra mappings in the *user* regi=
on.
>>>>>
>>>>> I'd like to understand this approach a little better.  In a syscall p=
ath,
>>>>> we run with the user task's mm.  What you're proposing is that when w=
e
>>>>> want to modify rare data, we switch to rare_mm which contains a
>>>>> writable mapping to all the kernel data which is rare-write.
>>>>>
>>>>> So the API might look something like this:
>>>>>
>>>>>    void *p =3D rare_alloc(...);    /* writable pointer */
>>>>>    p->a =3D x;
>>>>>    q =3D rare_protect(p);        /* read-only pointer */
>>
>> With pools and memory allocated from vmap_areas, I was able to say
>>
>> protect(pool)
>>
>> and that would do a swipe on all the pages currently in use.
>> In the SELinux policyDB, for example, one doesn't really want to individ=
ually protect each allocation.
>>
>> The loading phase happens usually at boot, when the system can be assume=
d to be sane (one might even preload a bare-bone set of rules from initramf=
s and then replace it later on, with the full blown set).
>>
>> There is no need to process each of these tens of thousands allocations =
and initialization as write-rare.
>>
>> Would it be possible to do the same here?
>
> I don=E2=80=99t see why not, although getting the API right will be a tad=
 complicated.
>
>>
>>>>>
>>>>> To subsequently modify q,
>>>>>
>>>>>    p =3D rare_modify(q);
>>>>>    q->a =3D y;
>>>>
>>>> Do you mean
>>>>
>>>>     p->a =3D y;
>>>>
>>>> here? I assume the intent is that q isn't writable ever, but that's
>>>> the one we have in the structure at rest.
>>> Yes, that was my intent, thanks.
>>> To handle the list case that Igor has pointed out, you might want to
>>> do something like this:
>>>    list_for_each_entry(x, &xs, entry) {
>>>        struct foo *writable =3D rare_modify(entry);
>>
>> Would this mapping be impossible to spoof by other cores?
>>
>
> Indeed. Only the core with the special mm loaded could see it.
>
> But I dislike allowing regular writes in the protected region. We really =
only need four write primitives:
>
> 1. Just write one value.  Call at any time (except NMI).
>
> 2. Just copy some bytes. Same as (1) but any number of bytes.
>
> 3,4: Same as 1 and 2 but must be called inside a special rare write regio=
n. This is purely an optimization.
>
> Actually getting a modifiable pointer should be disallowed for two reason=
s:
>
> 1. Some architectures may want to use a special write-different-address-s=
pace operation. Heck, x86 could, too: make the actual offset be a secret an=
d shove the offset into FSBASE or similar. Then %fs-prefixed writes would d=
o the rare writes.
>
> 2. Alternatively, x86 could set the U bit. Then the actual writes would u=
se the uaccess helpers, giving extra protection via SMAP.
>
> We don=E2=80=99t really want a situation where an unchecked pointer in th=
e rare write region completely defeats the mechanism.

We still have to deal with certain structures under the write-rare
window. For example, see:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=3D=
kspp/write-rarely&id=3D60430b4d3b113aae4adab66f8339074986276474
They are wrappers to non-inline functions that have the same sanity-checkin=
g.

--=20
Kees Cook
