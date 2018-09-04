From: Julian Stecklina <jsteckli@amazon.de>
Subject: Re: Redoing eXclusive Page Frame Ownership (XPFO) with isolated CPUs in mind (for KVM to isolate its guests per CPU)
References: <CA+55aFxyUdhYjnQdnmWAt8tTwn4HQ1xz3SAMZJiawkLpMiJ_+w@mail.gmail.com>
	<ciirm8a7p3alos.fsf@u54ee758033e858cfa736.ant.amazon.com>
	<CA+55aFzHj_GNZWG4K2oDu4DPP9sZdTZ9PY7sBxGB6WoN9g8d=A@mail.gmail.com>
	<20180903152616.GE27886@tassilo.jf.intel.com>
Date: Tue, 04 Sep 2018 11:37:25 +0200
In-Reply-To: <20180903152616.GE27886@tassilo.jf.intel.com> (Andi Kleen's
	message of "Mon, 3 Sep 2018 08:26:16 -0700")
Message-ID: <ciirm88t4hhacq.fsf@u54ee758033e858cfa736.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Woodhouse <dwmw@amazon.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, deepa.srinivasan@oracle.com, Jim Mattson <jmattson@google.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>, joao.m.martins@oracle.com, pradeep.vincent@oracle.com, Khalid Aziz <khalid.aziz@oracle.com>, kanth.ghatraju@oracle.com, Liran Alon <liran.alon@oracle.com>, Kees Cook <keescook@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, chris.hyser@oracle.com, Tyler Hicks <tyhicks@canonical.com>, John Haxby <john.haxby@oracle.com>, Jon Masters <jcm@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Andi Kleen <ak@linux.intel.com> writes:

> On Sat, Sep 01, 2018 at 02:38:43PM -0700, Linus Torvalds wrote:
>> On Fri, Aug 31, 2018 at 12:45 AM Julian Stecklina <jsteckli@amazon.de> wrote:
>> >
>> > I've been spending some cycles on the XPFO patch set this week. For the
>> > patch set as it was posted for v4.13, the performance overhead of
>> > compiling a Linux kernel is ~40% on x86_64[1]. The overhead comes almost
>> > completely from TLB flushing. If we can live with stale TLB entries
>> > allowing temporary access (which I think is reasonable), we can remove
>> > all TLB flushing (on x86). This reduces the overhead to 2-3% for
>> > kernel compile.
>> 
>> I have to say, even 2-3% for a kernel compile sounds absolutely horrendous.
>> 
>> Kernel bullds are 90% user space at least for me, so a 2-3% slowdown
>> from a kernel is not some small unnoticeable thing.
>
> Also the problem is that depending on the workload everything may fit
> into the TLBs, so the temporary stale TLB entries may be around
> for a long time. Modern CPUs have very large TLBs, and good
> LRU policies. For the kernel entries with global bit set and
> which are used for something there may be no reason ever to evict.
>
> Julian, I think you would need at least some quantitative perfmon data about
> TLB replacement rates in the kernel to show that it's "reasonable"
> instead of hand waving.

That's a fair point. It definitely depends on the workload. My idle
laptop gnome GUI session still causes ~40k dtlb-load-misses per second
per core. My idle server (some shells, IRC client) still has ~8k dTLB
load misses per second per core. Compiling something pushes this to
millions of misses per second.

For comparison according to https://www.7-cpu.com/cpu/Skylake_X.html SKX
can fit 1536 entries into its L2 dTLB.

> Most likely I suspect you would need a low frequency regular TLB
> flush for the global entries at least, which will increase
> the overhead again.

Given the tiny experiment above, I don't think this is necessary except
for highly special usecases. If stale TLB entries are a concern, the
better intermediate step is to do INVLPG on the core that modified the
page table.

And even with these shortcomings, XPFO severely limits the data an
attacker can leak from the kernel.

Julian
Amazon Development Center Germany GmbH
Berlin - Dresden - Aachen
main office: Krausenstr. 38, 10117 Berlin
Geschaeftsfuehrer: Dr. Ralf Herbrich, Christian Schlaeger
Ust-ID: DE289237879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
