Subject: Re: [RFC PATCH v8 03/14] mm, x86: Add support for eXclusive Page
 Frame Ownership (XPFO)
References: <cover.1550088114.git.khalid.aziz@oracle.com>
 <8275de2a7e6b72d19b1cd2ec5d71a42c2c7dd6c5.1550088114.git.khalid.aziz@oracle.com>
 <20190214105631.GJ32494@hirez.programming.kicks-ass.net>
 <e157e274-1bdf-0987-bfe9-21c9301578ab@oracle.com>
 <20190214190803.GQ32477@hirez.programming.kicks-ass.net>
From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <3b55fb25-9571-2208-4e04-052cd6dd4fee@oracle.com>
Date: Thu, 14 Feb 2019 12:58:53 -0700
MIME-Version: 1.0
In-Reply-To: <20190214190803.GQ32477@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Peter Zijlstra <peterz@infradead.org>
Cc: juergh@gmail.com, jsteckli@amazon.de, tycho@tycho.ws, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com, Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, joao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Marco Benatto <marco.antonio.780@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2/14/19 12:08 PM, Peter Zijlstra wrote:
> On Thu, Feb 14, 2019 at 10:13:54AM -0700, Khalid Aziz wrote:
>=20
>> Patch 11 ("xpfo, mm: remove dependency on CONFIG_PAGE_EXTENSION") clea=
ns
>> all this up. If the original authors of these two patches, Juerg
>> Haefliger and Julian Stecklina, are ok with it, I would like to combin=
e
>> the two patches in one.
>=20
> Don't preserve broken patches because of different authorship or
> whatever.
>=20
> If you care you can say things like:
>=20
>  Based-on-code-from:
>  Co-developed-by:
>  Originally-from:
>=20
> or whatever other things there are. But individual patches should be
> correct and complete.
>=20

That sounds reasonable. I will merge these two patches in the next versio=
n.

Thanks,
Khalid
