From: Julian Stecklina <jsteckli@amazon.de>
Subject: Re: Redoing eXclusive Page Frame Ownership (XPFO) with isolated CPUs in mind (for KVM to isolate its guests per CPU)
References: <CA+55aFxyUdhYjnQdnmWAt8tTwn4HQ1xz3SAMZJiawkLpMiJ_+w@mail.gmail.com>
	<ciirm8a7p3alos.fsf@u54ee758033e858cfa736.ant.amazon.com>
	<CA+55aFzHj_GNZWG4K2oDu4DPP9sZdTZ9PY7sBxGB6WoN9g8d=A@mail.gmail.com>
Date: Mon, 03 Sep 2018 16:51:35 +0200
In-Reply-To: <CA+55aFzHj_GNZWG4K2oDu4DPP9sZdTZ9PY7sBxGB6WoN9g8d=A@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 1 Sep 2018 14:38:43 -0700")
Message-ID: <ciirm8zhwyiqh4.fsf@u54ee758033e858cfa736.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, juerg.haefliger@hpe.com, deepa.srinivasan@oracle.com, Jim Mattson <jmattson@google.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>, joao.m.martins@oracle.com, pradeep.vincent@oracle.com, Andi Kleen <ak@linux.intel.com>, Khalid Aziz <khalid.aziz@oracle.com>, kanth.ghatraju@oracle.com, Liran Alon <liran.alon@oracle.com>, Kees Cook <keescook@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, chris.hyser@oracle.com, Tyler Hicks <tyhicks@canonical.com>, John Haxby <john.haxby@oracle.com>, Jon Masters <jcm@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Aug 31, 2018 at 12:45 AM Julian Stecklina <jsteckli@amazon.de> wrote:
>>
>> I've been spending some cycles on the XPFO patch set this week. For the
>> patch set as it was posted for v4.13, the performance overhead of
>> compiling a Linux kernel is ~40% on x86_64[1]. The overhead comes almost
>> completely from TLB flushing. If we can live with stale TLB entries
>> allowing temporary access (which I think is reasonable), we can remove
>> all TLB flushing (on x86). This reduces the overhead to 2-3% for
>> kernel compile.
>
> I have to say, even 2-3% for a kernel compile sounds absolutely horrendous.

Well, it's at least in a range where it doesn't look hopeless.

> Kernel bullds are 90% user space at least for me, so a 2-3% slowdown
> from a kernel is not some small unnoticeable thing.

The overhead seems to come from the hooks that XPFO adds to
alloc/free_pages. These hooks add a couple of atomic operations per
allocated (4K) page for book keeping. Some of these atomic ops are only
for debugging and could be removed. There is also some opportunity to
streamline the per-page space overhead of XPFO.

I'll do some more in-depth profiling later this week.

Julian
Amazon Development Center Germany GmbH
Berlin - Dresden - Aachen
main office: Krausenstr. 38, 10117 Berlin
Geschaeftsfuehrer: Dr. Ralf Herbrich, Christian Schlaeger
Ust-ID: DE289237879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
