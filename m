MIME-Version: 1.0
References: <CA+55aFxyUdhYjnQdnmWAt8tTwn4HQ1xz3SAMZJiawkLpMiJ_+w@mail.gmail.com>
 <ciirm8a7p3alos.fsf@u54ee758033e858cfa736.ant.amazon.com>
In-Reply-To: <ciirm8a7p3alos.fsf@u54ee758033e858cfa736.ant.amazon.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Sep 2018 14:38:43 -0700
Message-ID: <CA+55aFzHj_GNZWG4K2oDu4DPP9sZdTZ9PY7sBxGB6WoN9g8d=A@mail.gmail.com>
Subject: Re: Redoing eXclusive Page Frame Ownership (XPFO) with isolated CPUs
 in mind (for KVM to isolate its guests per CPU)
Content-Type: text/plain; charset="UTF-8"
To: jsteckli@amazon.de
Cc: David Woodhouse <dwmw@amazon.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, juerg.haefliger@hpe.com, deepa.srinivasan@oracle.com, Jim Mattson <jmattson@google.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>, joao.m.martins@oracle.com, pradeep.vincent@oracle.com, Andi Kleen <ak@linux.intel.com>, Khalid Aziz <khalid.aziz@oracle.com>, kanth.ghatraju@oracle.com, Liran Alon <liran.alon@oracle.com>, Kees Cook <keescook@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, chris.hyser@oracle.com, Tyler Hicks <tyhicks@canonical.com>, John Haxby <john.haxby@oracle.com>, Jon Masters <jcm@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 31, 2018 at 12:45 AM Julian Stecklina <jsteckli@amazon.de> wrote:
>
> I've been spending some cycles on the XPFO patch set this week. For the
> patch set as it was posted for v4.13, the performance overhead of
> compiling a Linux kernel is ~40% on x86_64[1]. The overhead comes almost
> completely from TLB flushing. If we can live with stale TLB entries
> allowing temporary access (which I think is reasonable), we can remove
> all TLB flushing (on x86). This reduces the overhead to 2-3% for
> kernel compile.

I have to say, even 2-3% for a kernel compile sounds absolutely horrendous.

Kernel bullds are 90% user space at least for me, so a 2-3% slowdown
from a kernel is not some small unnoticeable thing.

           Linus
