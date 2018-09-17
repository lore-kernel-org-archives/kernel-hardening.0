From: Julian Stecklina <jsteckli@amazon.de>
Subject: Re: Redoing eXclusive Page Frame Ownership (XPFO) with isolated CPUs in mind (for KVM to isolate its guests per CPU)
References: <CA+55aFxyUdhYjnQdnmWAt8tTwn4HQ1xz3SAMZJiawkLpMiJ_+w@mail.gmail.com>
	<ciirm8a7p3alos.fsf@u54ee758033e858cfa736.ant.amazon.com>
	<CA+55aFzHj_GNZWG4K2oDu4DPP9sZdTZ9PY7sBxGB6WoN9g8d=A@mail.gmail.com>
	<ciirm8zhwyiqh4.fsf@u54ee758033e858cfa736.ant.amazon.com>
	<ciirm8efdy916l.fsf@u54ee758033e858cfa736.ant.amazon.com>
	<CADLDEKsxx=MSFu=4_4JLX1afUMr3GVjNxSQ-726NrbLn8KQaQg@mail.gmail.com>
Date: Mon, 17 Sep 2018 12:01:02 +0200
In-Reply-To: <CADLDEKsxx=MSFu=4_4JLX1afUMr3GVjNxSQ-726NrbLn8KQaQg@mail.gmail.com>
	(Juerg Haefliger's message of "Thu, 13 Sep 2018 08:11:49 +0200")
Message-ID: <ciirm8r2hs30kh.fsf@u54ee758033e858cfa736.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Juerg Haefliger <juergh@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Woodhouse <dwmw@amazon.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, deepa.srinivasan@oracle.com, Jim Mattson <jmattson@google.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>, joao.m.martins@oracle.com, pradeep.vincent@oracle.com, Andi Kleen <ak@linux.intel.com>, Khalid Aziz <khalid.aziz@oracle.com>, kanth.ghatraju@oracle.com, Liran Alon <liran.alon@oracle.com>, Kees Cook <keescook@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, chris.hyser@oracle.com, Tyler Hicks <tyhicks@canonical.com>, John Haxby <john.haxby@oracle.com>, Jon Masters <jcm@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Juerg Haefliger <juergh@gmail.com> writes:

>> I've updated my XPFO branch[1] to make some of the debugging optional
>> and also integrated the XPFO bookkeeping with struct page, instead of
>> requiring CONFIG_PAGE_EXTENSION, which removes some checks in the hot
>> path.
>
> FWIW, that was my original design but there was some resistance to
> adding more to the page struct and page extension was suggested
> instead.

>From looking at both versions, I have to say that having the metadata in
struct page makes the code easier to understand and removes some special
cases and bookkeeping.

> I'm wondering how much performance we're loosing by having to split
> hugepages. Any chance this can be quantified somehow? Maybe we can
> have a pool of some sorts reserved for userpages and group allocations
> so that we can track the XPFO state at the hugepage level instead of
> at the 4k level to prevent/reduce page splitting. Not sure if that
> causes issues or has any unwanted side effects though...

Optimizing the allocation/deallocation path might be worthwhile, because
that's where most of the overhead goes. I haven't looked into how to do
this yet. I'd appreciate if someone has pointers to code that tries to
achieve similar functionality to get me started.

That being said, I'm wondering whether we have unrealistic expectations
about the overhead here and whether it's worth turning this patch into
something far more complicated. Opinions?

Julian
--
Amazon Development Center Germany GmbH
Berlin - Dresden - Aachen
main office: Krausenstr. 38, 10117 Berlin
Geschaeftsfuehrer: Dr. Ralf Herbrich, Christian Schlaeger
Ust-ID: DE289237879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
