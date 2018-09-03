Date: Mon, 3 Sep 2018 08:36:41 -0700
From: Andi Kleen <ak@linux.intel.com>
Subject: Re: Redoing eXclusive Page Frame Ownership (XPFO) with isolated CPUs
 in mind (for KVM to isolate its guests per CPU)
Message-ID: <20180903153641.GF27886@tassilo.jf.intel.com>
References: <CA+55aFxyUdhYjnQdnmWAt8tTwn4HQ1xz3SAMZJiawkLpMiJ_+w@mail.gmail.com>
 <ciirm8a7p3alos.fsf@u54ee758033e858cfa736.ant.amazon.com>
 <CA+55aFzHj_GNZWG4K2oDu4DPP9sZdTZ9PY7sBxGB6WoN9g8d=A@mail.gmail.com>
 <CACfEFw_h5uup-anKZwfBcWMJB7gHxb9NEPTRSUAY0+t11RiQbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACfEFw_h5uup-anKZwfBcWMJB7gHxb9NEPTRSUAY0+t11RiQbg@mail.gmail.com>
To: Wes Turner <wes.turner@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "jsteckli@amazon.de" <jsteckli@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "juerg.haefliger@hpe.com" <juerg.haefliger@hpe.com>, "deepa.srinivasan@oracle.com" <deepa.srinivasan@oracle.com>, Jim Mattson <jmattson@google.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "pradeep.vincent@oracle.com" <pradeep.vincent@oracle.com>, Khalid Aziz <khalid.aziz@oracle.com>, "kanth.ghatraju@oracle.com" <kanth.ghatraju@oracle.com>, Liran Alon <liran.alon@oracle.com>, Kees Cook <keescook@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "chris.hyser@oracle.com" <chris.hyser@oracle.com>, Tyler Hicks <tyhicks@canonical.com>, John Haxby <john.haxby@oracle.com>, Jon Masters <jcm@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 01, 2018 at 06:33:22PM -0400, Wes Turner wrote:
>    Speaking of pages and slowdowns,
>    is there a better place to ask this question:
>    From "'Turning Tables' shared page tables vuln":
>    """
>    'New "Turning Tables" Technique Bypasses All Windows Kernel Mitigations'
>    https://www.bleepingcomputer.com/news/security/new-turning-tables-technique-bypasses-all-windows-kernel-mitigations/
>    > Furthermore, since the concept of page tables is also used by Apple and
>    the Linux project, macOS and Linux are, in theory, also vulnerable to this
>    technique, albeit the researchers have not verified such attacks, as of
>    yet.
>    Slides:
>    https://cdn2.hubspot.net/hubfs/487909/Turning%20(Page)%20Tables_Slides.pdf
>    Naturally, I took notice and decided to forward the latest scary headline
>    to this list to see if this is already being addressed?

This essentially just says that if you can change page tables you can subvert kernels.
That's always been the case, always will be, I'm sure has been used forever by root kits,
and I don't know why anybody would pass it off as a "new attack".

-Andi
